" static-import.vim - Add static imports
" Maintainer:         Matthew Franglen
" Version:            0.1.0

if exists('g:loaded_static_import') || &compatible
    finish
endif
let g:loaded_static_import = 1

if ! exists('g:static_import_search_dir')
    let g:static_import_search_dir = expand('$PWD')
endif

if ! exists('g:static_import_search_cmd')
    let g:static_import_search_cmd = 'grep --no-filename --no-messages --recursive --binary-files=without-match'
endif

function! g:LoadStaticImportCommand()
    command! -buffer AddStaticImport call s:AddStaticImport()
endfunction

function s:DisplayNotLoadedFailure()
    echo "AddStaticImport has not been loaded as this is not a java file.\nUse :LoadStaticImportCommand to load it manually"
endfunction

command! LoadStaticImportCommand call g:LoadStaticImportCommand()
command! AddStaticImport call s:DisplayNotLoadedFailure()
autocmd FileType java call g:LoadStaticImportCommand()

function s:AddStaticImport()
    let l:word = s:GetCurrentWord()
    let l:imports = s:FindStaticImports(l:word)

    if len(l:imports) == 0
        call s:DisplaySearchFailure(l:word)
        return
    endif

    if len(l:imports) == 1
        let l:import = l:imports[0]
    else
        let l:import = s:QueryUserForStaticImport(l:imports)
    endif

    call s:AddImport(l:import)
    call s:SortImports()
endfunction

function s:FindStaticImports(word)
    let l:search_cmd = g:static_import_search_cmd . ' ' . shellescape(a:word) . ' ' . g:static_import_search_dir . '/*'
    let l:filter_cmd = 'grep "import static" | sort | uniq'
    let l:command = l:search_cmd . ' | ' . l:filter_cmd

    return split(system(l:command), '\n\+')
endfunction

function s:AddImport(import)
    let l:register = @i
    let @i = a:import
    let l:saved_view = winsaveview()
    :2put i
    call winrestview(l:saved_view)
    let @i = l:register
endfunction

function s:SortImports()
    :JavaImportOrganize
endfunction

function s:GetCurrentWord()
    return expand('<cword>')
endfunction

function s:DisplaySearchFailure(word)
    echo 'Unable to find any static import for "' . a:word . '"'
endfunction

function s:QueryUserForStaticImport(imports)
    let l:options = ['Select import:'] + s:PrefixListEntriesWithIndex(a:imports)
    let l:index = inputlist(l:options)
    return a:imports[l:index - 1]
endfunction

function s:PrefixListEntriesWithIndex(list)
    let l:result = []
    let l:index = 1

    for l:entry in a:list
        let l:result = l:result + [l:index . '. ' . l:entry]
        let l:index = l:index + 1
    endfor

    return l:result
endfunction

