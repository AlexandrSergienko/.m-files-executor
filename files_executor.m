% This program sequentially run all matlab .m files that contained in
% SOURCE_DIR. So you can specify your directory bellow in part of code
% wrapped with comment INITIALIZATION. 
% When file from SOURCE_DIR start to processing it moves in IN_PROGRESS_DIR
% and in that folder will be executed. If exeption appeared in runtime, then
% file will be moved in PROCESSED_WITH_ERRORS_DIR folder; it will be
% moved in PROCESSED_DIR otherwise.
% 
%
% NOTE: Do not put this file in SOURCE_DIR, because recursively execution
% will be started!
%

%------------------- INITIALIZATION START----------------
SOURCE_DIR = fullfile('HaveNotProcessed')
IN_PROGRESS_DIR = fullfile('InProgress')
PROCESSED_DIR = fullfile('ProcessedSuccessfully')
PROCESSED_WITH_ERRORS_DIR = fullfile('ProcessedWithErrors')
FILES_FOR_RUN = '*.m'
%------------------- INITIALIZATION END----------------

filesForProcessing = dir(fullfile(SOURCE_DIR,FILES_FOR_RUN));
% Prepare file system
if size(filesForProcessing,1)>0
    if size(dir(IN_PROGRESS_DIR),1)==0 mkdir(IN_PROGRESS_DIR); end;   
    if size(dir(PROCESSED_DIR),1)==0 mkdir(PROCESSED_DIR); end;   
    if size(dir(PROCESSED_WITH_ERRORS_DIR),1)==0 mkdir(PROCESSED_WITH_ERRORS_DIR); end;   
else
    log='No files was found for processing!'
end
%
while size(filesForProcessing,1)>0
    fileStruct =filesForProcessing(1);
    fileName = fileStruct.name;
    funcName = fileName(1:end-2)
    %move in progress directory
    allFilesByFunctNamePattern = [funcName,'.*'];
    allFilesByFunctName = dir(fullfile(SOURCE_DIR, allFilesByFunctNamePattern));
    for ii=1:size(allFilesByFunctName,1)
        file = allFilesByFunctName(ii);
        fn=file.name;
        if fn(size(funcName,2)+1:size(funcName,2)+1)=='.'
            log=['move in progress directory file:', fn]
            movefile(fullfile(SOURCE_DIR,fn),fullFile(IN_PROGRESS_DIR, fn));
        end
    end
    clear fn ii file allFilesByFunctName allFilesByFunctNamePattern
    %end move in progress directory
    resultDirectory = PROCESSED_DIR;
    cd(IN_PROGRESS_DIR)
    try
        log=['Run file:', funcName]
        eval(funcName);
        log=['File processed successfully. File ', funcName]
    catch e
        resultDirectory = PROCESSED_WITH_ERRORS_DIR;
        log=['File processing error. File ', funcName]
        e.message
    end
    cd('..')
    
    %move in result directory
    allFilesByFunctNamePattern = [funcName,'.*'];
    allFilesByFunctName = dir(fullfile(IN_PROGRESS_DIR, allFilesByFunctNamePattern));
    for ii=1:size(allFilesByFunctName,1)
       file = allFilesByFunctName(ii);
        fn=file.name;
        if fn(size(funcName,2)+1:size(funcName,2)+1)=='.'
            log=['move to result directory:',resultDirectory, ' file:', fn]
            movefile(fullfile(IN_PROGRESS_DIR,fn),fullFile(resultDirectory, fn));
        end
    end
    clear fn ii file allFilesByFunctName allFilesByFunctNamePattern
    %end move in result directory
    filesForProcessing = dir(fullfile(SOURCE_DIR,FILES_FOR_RUN));
end
    try
        rmdir(IN_PROGRESS_DIR)
        rmdir(PROCESSED_DIR)
        rmdir(PROCESSED_WITH_ERRORS_DIR)
    catch e
        e.message
    end
log='Programm finished.'
