" static-import.vim - Add static imports
" Maintainer:         Matthew Franglen
" Version:            0.0.1

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

function g:AddStaticImport()
    let l:word = s:GetCurrentWord()
    let l:imports = s:FindStaticImports(l:word)
    call s:AddImport(l:imports[0])
    call s:SortImports()
endfunction
command! AddStaticImport call g:AddStaticImport()

function s:FindStaticImports(word)
    let l:search_cmd = g:static_import_search_cmd . ' ' . shellescape(a:word) . ' ' . g:static_import_search_dir . '/*'
    let l:filter_cmd = 'grep "import static" | sort | uniq'
    let l:command = l:search_cmd . ' | ' . l:filter_cmd

    return split(system(l:command), '\[\r\n\]')
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

function s:DisplayAvailableStaticImports(imports)

endfunction

function s:DismissStaticImportDisplay()

endfunction

