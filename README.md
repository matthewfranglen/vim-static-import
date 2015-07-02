Vim Static Import
=================

This allows you to add a static import for the current word under the cursor.
You invoke this using:

    :AddStaticImport

This command can be bound to a key:

    nnoremap <leader>I :AddStaticImport

This works by searching for an existing static import for that word. Once found
the import is added to the current file.

This searches for the import in the folder that you were in when this plugin
was loaded. You can override this at any time by changing the value of
`g:static_import_search_dir`.

This uses grep to search for the import. You can change this at any time by
changing the value of `g:static_import_search_cmd`. See the help for more
information on this.
