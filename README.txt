Example config file

    TAR_BASE_DIR='/home/user'
    TAR_TARGETS='target_dir'
    # PASSWORD=''

Example archive command

    read PASSWORD; export PASSWORD
    sh make_archive.sh config/sample

Example restore command

    read PASSWORD; export PASSWORD
    cat result/* | sh decrypt_archive.sh config/sample | (cd /restore/path && tar xpzf -)
