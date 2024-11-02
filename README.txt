To make encrypted archive files to write to DVD-R media, issue bellow command.

    read PASSWORD; export PASSWORD
    sh make_archive.sh config

Example command of how to restore the data from encrypted chunks.

    read PASSWORD; export PASSWORD
    cat dvd-files/DISK01/* | sh decrypt_archive.sh config | (cd /restore/path && tar xzf -)
