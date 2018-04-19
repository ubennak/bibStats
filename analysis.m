% close all;

% filePath = 'C:\Workspaces\Matlab\bibliTools\resources\2018-04-17_ZoteroLibrary.csv';
% uiopen(filePath, 1)
% csvread(filePath);
filePath = 'C:\Workspaces\Matlab\bibliTools\resources\2018-04-18_ZoteroLibrary.mat';
listSelectedTags = {'HRIR measurement'; ...
                    'HRTF calculation'; ...
                    'HRTF individualization from anthropometry'; ...
                    'Listener-driven HRTF individualization'};
% listSelectedItemType = unique(data.ItemType);
% listSelectedItemType = {'conferencePaper', 'journalArticle'};
% listSelectedItemType = {'journalArticle'};
listSelectedItemType = {'conferencePaper'};

data = load(filePath);
listYears = data.PublicationYear;

idxNotNan = ~isnan(listYears);

idxSelectType = zeros(size(listYears));
for ii = 1:numel(listSelectedItemType)
    type = listSelectedItemType{ii};
    idxSelectType = idxSelectType | strcmp(type, data.ItemType);
end

idxPreSelection = idxNotNan & idxSelectType;

binStep = 1;
bins = (1950:binStep:2020) + binStep * 0.5;
hists = zeros(numel(bins), numel(listSelectedTags));
cnt = 0;
for ii=1:numel(listSelectedTags)
    tag = listSelectedTags{ii};
    
    listTags = data.ManualTags;
    idxFilterTag = cell2mat(cellfun(@(x) ~isempty(strfind(x, tag)), ...
                                    listTags, ...
                                    'UniformOutput', false));
    idxFilterTag = idxFilterTag & idxPreSelection;
    cnt = cnt + sum(idxFilterTag);
    hists(:, ii) = hist(listYears(idxFilterTag), bins).';
end

hFig = figure();
hAxes = bar(bins, hists, 'stacked');
legend(listSelectedTags, 'Location', 'best');
title({sprintf('Number of ''%s'' articles per year', tag), ...
       sprintf('Total number of articles: %d', cnt)});
ylim([0 25]);