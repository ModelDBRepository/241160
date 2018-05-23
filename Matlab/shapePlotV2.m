%2017-12-24
%Ross Anderson
%{
This code is used to graph the potentials and generate the 3D shape plot
used in Figure 3A,B of:

Anderson R, Farokhniaee A, Gunalan K., Howell B, McIntyre C. 2018. Action
Potential Initiation, Propagation, and Cortical Invasion in the Hyperdirect
Pathway During Subthalamic Deep Brain Stimulation. Brain Stimulation.
%}

clear time answer

%Reload data on the first use of this code.

prompt = {'Enter timepoint (ms):','Reload data (1 = yes, 0 = no):', 'V min', 'V max', 'dt'};
dlg_title = 'Shape Plot Setup';
num_lines = 1;
defaultans = {'1.5','0', '-90', '45', '0.005'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);


time = (1/str2double(answer{5}))*str2double(answer{1}) + 1;  %Set for dt = 0.005

time = round(time);
%clear and load variable:

if str2double(answer{2}) == 1
    
    clear dend*NVm dendVm dendList huSectionStoreInter l5pcout
    clear aisVm myelinVm nodeVm hillVm somaVm nakeaxonVm
    clear axonStruct2* sectionStoreInter3*
    
    %Load membrane voltages
    load Vm/dend1NVm.txt
    load Vm/dend2NVm.txt
    load Vm/dend3NVm.txt
    load Vm/dend4NVm.txt
    load Vm/dend5NVm.txt
    load Vm/dend6NVm.txt
    load Vm/dend7NVm.txt
    load Vm/dend8NVm.txt
    load Vm/dend9NVm.txt
    load Vm/dend10NVm.txt
    load Vm/dend11NVm.txt

    load Vm/aisVm.txt
    load Vm/myelinVm.txt
    load Vm/nodeVm.txt
    load Vm/hillVm.txt
    load Vm/somaVm.txt
    load Vm/nakeaxonVm.txt

    
    %Load structures
    load axonStruct2.mat
    load axonStruct2NodeMyelin.mat
    load sectionStoreInter3.mat
    load sectionStoreInter3NodeMyelin.mat
    load dendList.mat
    load huSectionStoreInter
    load l5pcoutV2

    
    clear dendVm

    dendVm = [dend1NVm';dend2NVm';dend3NVm';dend4NVm';dend5NVm';dend6NVm';dend7NVm';dend8NVm';dend9NVm';dend10NVm';dend11NVm'];
    dendVm(1,:)=[]; %delete the first row (time)

    clear dend*NVm
    
    somaVm = somaVm';
    somaVm(1,:)=[];

    hillVm = hillVm';
    hillVm(1,:)=[];
    
    aisVm = aisVm';
    aisVm(1,:)=[];

    nakeaxonVm = nakeaxonVm';
    nakeaxonVm(1,:)=[];
    
    myelinVm = myelinVm';
    myelinVm(1,:)=[];

    nodeVm = nodeVm';
    nodeVm(1,:)=[];

end

%Set the min/max range for the shape plot heat map
cmin= str2double(answer{3}); %min([min(nodeVm) min(myelinVm)]);
cmax= str2double(answer{4}); %min([max(nodeVm) max(myelinVm)]);


%Dendrites
for j=1:size(dendList,1)
    for i = dendList(j,1):dendList(j,2)
        cline(l5pcout(huSectionStoreInter(i,3):huSectionStoreInter(i,4),1), l5pcout(huSectionStoreInter(i,3):huSectionStoreInter(i,4),2), l5pcout(huSectionStoreInter(i,3):huSectionStoreInter(i,4),3), dendVm(i,time)*ones(1+ huSectionStoreInter(i,4)-huSectionStoreInter(i,3),1), 'jet', cmin, cmax  ); %(dendVm(huSectionStoreInter(i,5) + 1,1))*ones(huSectionStoreInter(i,2)-huSectionStoreInter(i,1) + 1, 1), 'jet', cmin, cmax    ); %x, y, z, c
    end
end

%Soma


%Hill
for i = 1:size(sectionStoreInter3,1)
    if(sectionStoreInter3(i,4)==3)
        cline(axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),1), axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),2), axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),3), (hillVm(sectionStoreInter3(i,5) + 1,time))*ones(sectionStoreInter3(i,2)-sectionStoreInter3(i,1) + 1, 1), 'jet', cmin, cmax    ); %x, y, z, c
    end
end


%AIS
for i = 1:size(sectionStoreInter3,1)
    if(sectionStoreInter3(i,4)==4)
        cline(axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),1), axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),2), axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),3), (aisVm(sectionStoreInter3(i,5) + 1,time))*ones(sectionStoreInter3(i,2)-sectionStoreInter3(i,1) + 1, 1), 'jet', cmin, cmax    ); %x, y, z, c
    end
end

%nakeaxon (unmyelinated axon)
for i = 1:size(sectionStoreInter3,1)
    if(sectionStoreInter3(i,4)==5)
        cline(axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),1), axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),2), axonStruct2(sectionStoreInter3(i,1):sectionStoreInter3(i,2),3), (nakeaxonVm(sectionStoreInter3(i,5) + 1,time))*ones(sectionStoreInter3(i,2)-sectionStoreInter3(i,1) + 1, 1), 'jet', cmin, cmax    ); %x, y, z, c
    end
end


%Node
for i = 1:size(sectionStoreInter3NodeMyelin,1)
    if(sectionStoreInter3NodeMyelin(i,4)==1)
        cline(axonStruct2NodeMyelin(sectionStoreInter3NodeMyelin(i,1):sectionStoreInter3NodeMyelin(i,2),1), axonStruct2NodeMyelin(sectionStoreInter3NodeMyelin(i,1):sectionStoreInter3NodeMyelin(i,2),2), axonStruct2NodeMyelin(sectionStoreInter3NodeMyelin(i,1):sectionStoreInter3NodeMyelin(i,2),3), (nodeVm(sectionStoreInter3NodeMyelin(i,5) + 1,time))*ones(sectionStoreInter3NodeMyelin(i,2)-sectionStoreInter3NodeMyelin(i,1) + 1, 1), 'jet', cmin, cmax    ); %x, y, z, c
    end
end

%Myelin
for i = 1:size(sectionStoreInter3NodeMyelin,1)
    if(sectionStoreInter3NodeMyelin(i,4)==2)
        cline(axonStruct2NodeMyelin(sectionStoreInter3NodeMyelin(i,1):sectionStoreInter3NodeMyelin(i,2),1), axonStruct2NodeMyelin(sectionStoreInter3NodeMyelin(i,1):sectionStoreInter3NodeMyelin(i,2),2), axonStruct2NodeMyelin(sectionStoreInter3NodeMyelin(i,1):sectionStoreInter3NodeMyelin(i,2),3), (myelinVm(sectionStoreInter3NodeMyelin(i,5) + 1,time))*ones(sectionStoreInter3NodeMyelin(i,2)-sectionStoreInter3NodeMyelin(i,1) + 1, 1), 'jet', cmin, cmax    ); %x, y, z, c
    end
end




axis off
set(gcf,'color','w');

disp(answer{1}) %Print out the time chosen for this example

daspect([1 1 1])  %set the aspect ration constant
