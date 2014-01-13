function varargout = e(varargin)
% EEG_PLOTGUI MATLAB code for eeg_plotgui.fig
%      EEG_PLOTGUI, by itself, creates a new EEG_PLOTGUI or raises the existing
%      singleton*.
%
%      H = EEG_PLOTGUI returns the handle to a new EEG_PLOTGUI or the handle to
%      the existing singleton*.
%
%      EEG_PLOTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEG_PLOTGUI.M with the given input arguments.
%
%      EEG_PLOTGUI('Property','Value',...) creates a new EEG_PLOTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eeg_plotgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eeg_plotgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eeg_plotgui

% Last Modified by GUIDE v2.5 20-Mar-2013 14:12:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eeg_plotgui_OpeningFcn, ...
                   'gui_OutputFcn',  @eeg_plotgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before eeg_plotgui is made visible.
function eeg_plotgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eeg_plotgui (see VARARGIN)

% Choose default command line output for eeg_plotgui
handles.output = hObject;


% add some more parameters here:
handles.sig=[]; handles.Fs=[]; 
handles.channel_labs=[]; handles.amplitude_scale=[];
handles.HARD_LIMIT_VOLT=[]; handles.highlight_chan=[];
handles.bipolar=1; handles.message_str=[];

handles.sig=varargin{1};
if( length(varargin)>1 ), handles.Fs=varargin{2}; end
if( length(varargin)>2 ), handles.channel_labs=varargin{3}; end
if( length(varargin)>3 ), handles.amplitude_scale=varargin{4}; end
if( length(varargin)>4 ), handles.HARD_LIMIT_VOLT=varargin{5}; end
if( length(varargin)>5 ), handles.highlight_chan=varargin{6}; end
if( length(varargin)>6 ), handles.bipolar=varargin{7}; end
if( length(varargin)>7 ), handles.message_str=varargin{8}; end

% length of data (in seconds):
L=size(handles.sig,2); 
if(~isempty(handles.Fs)), L=L/handles.Fs; end
epoch_handle=findobj(hObject,'Tag','epoch_size');
set(epoch_handle,'String',num2str(L));

% message (if any)
if(~isempty(handles.message_str))
  info_handle=findobj(hObject,'Tag','info_panel');
  set(info_handle,'String',handles.message_str);
end



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eeg_plotgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% do the plot on initialize:
eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
           handles.channel_labs,handles.amplitude_scale,...
           handles.HARD_LIMIT_VOLT,handles.highlight_chan,...
           [],handles.bipolar);

handles.x_limit=get(handles.plot_axes,'xlim');
guidata(hObject, handles);


montage_handle=findobj(hObject,'Tag','montage_list');
contents=cellstr(get(montage_handle,'String'));

if(handles.bipolar==1)
  ivalue=find( strcmp(contents(:),'bipolar')==1 );
  set(montage_handle,'Value',ivalue);
else
  ivalue=find( strcmp(contents(:),'monopolar')==1 );
  set(montage_handle,'Value',ivalue);
end



% --- Outputs from this function are returned to the command line.
function varargout = eeg_plotgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in replot_data.
function replot_data_Callback(hObject, eventdata, handles)
% hObject    handle to replot_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject,handles);

eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
           handles.channel_labs,handles.amplitude_scale,...
           handles.HARD_LIMIT_VOLT,handles.highlight_chan,...
           handles.x_limit,handles.bipolar);


% --- Executes on selection change in amplitude_scale.
function amplitude_scale_Callback(hObject, eventdata, handles)
% hObject    handle to amplitude_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
str = get(hObject, 'String');
handles.amplitude_scale=str2num(str{val});
% Hints: contents = cellstr(get(hObject,'String')) returns amplitude_scale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from amplitude_scale

guidata(hObject,handles);

eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
           handles.channel_labs,handles.amplitude_scale,...
           handles.HARD_LIMIT_VOLT,handles.highlight_chan,...
           handles.x_limit,handles.bipolar);



% --- Executes during object creation, after setting all properties.
function amplitude_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amplitude_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in back_scroll.
function back_scroll_Callback(hObject, eventdata, handles)
% hObject    handle to back_scroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.x_limit=handles.x_limit-5;
set(handles.plot_axes,'xlim',handles.x_limit);
guidata(hObject,handles);



function epoch_size_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epoch_size as text
%        str2double(get(hObject,'String')) returns contents of epoch_size as a double

L_epoch=str2double( get(hObject,'String') );
handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];

set(handles.plot_axes,'xlim',handles.x_limit);
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function epoch_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epoch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in forward_scroll.
function forward_scroll_Callback(hObject, eventdata, handles)
% hObject    handle to forward_scroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.x_limit=handles.x_limit+5;
set(handles.plot_axes,'xlim',handles.x_limit);
guidata(hObject,handles);



function do_plot(handles)
d=handles.sigs;
N=length(d);

plot(handles.plot_axes,(1:N)./handles.Fs,d);


% --- Executes on key press with focus on amplitude_scale and none of its controls.
function amplitude_scale_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to amplitude_scale (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if( strcmp(eventdata.Key,'uparrow')==1 )
  amp_handle=findobj(gcbf,'Tag','amplitude_scale');

  val=get(amp_handle,'Value');
  str=get(amp_handle, 'String');
  val=val-1;
  if(val<1), val=1; end
  set(amp_handle,'Value',val);  

  % and replot with new amplitude value:
  handles.amplitude_scale=str2num(str{val});
  guidata(hObject,handles);
  eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
             handles.channel_labs,handles.amplitude_scale,...
             handles.HARD_LIMIT_VOLT,handles.highlight_chan,...
             handles.x_limit,handles.bipolar);

elseif( strcmp(eventdata.Key,'downarrow')==1 )
  amp_handle=findobj(gcbf,'Tag','amplitude_scale');

  val=get(amp_handle,'Value');
  str=get(amp_handle, 'String');
  L=length(str);
  val=val+1;
  if(val>L), val=L; end
  set(amp_handle,'Value',val);  
  
  % and replot with new amplitude value:
  handles.amplitude_scale=str2num(str{val});
  guidata(hObject,handles);
  eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
             handles.channel_labs,handles.amplitude_scale, ...
             handles.HARD_LIMIT_VOLT,handles.highlight_chan, ...
             handles.x_limit,handles.bipolar);
  
% CHANGE montage:
elseif( strcmp(eventdata.Key,'m')==1 )
  montage_handle=findobj(gcbf,'Tag','montage_list');

  val=get(montage_handle,'Value');
  str=get(montage_handle, 'String');
  L=length(str);
  val=val+1;
  if(val>L), val=1; end
  set(montage_handle,'Value',val);  
  
  
  if(strcmp(str{get(montage_handle,'Value')},'monopolar')==1)
    handles.bipolar=0;
  else
    handles.bipolar=1;
  end

  guidata(hObject,handles);

  eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
             handles.channel_labs,handles.amplitude_scale, ...
             handles.HARD_LIMIT_VOLT,handles.highlight_chan, ...
             handles.x_limit,handles.bipolar);
  
elseif( strcmp(eventdata.Key,'leftarrow')==1 )

  handles.x_limit=handles.x_limit-5;
  set(handles.plot_axes,'xlim',handles.x_limit);
  guidata(hObject,handles);

elseif( strcmp(eventdata.Key,'rightarrow')==1 )

  handles.x_limit=handles.x_limit+5;
  set(handles.plot_axes,'xlim',handles.x_limit);
  guidata(hObject,handles);

  
elseif( strcmp(eventdata.Key,'a')==1 )
  time_handle=findobj(hObject,'Tag','time_scale');

  val=get(time_handle,'Value');
  str=get(time_handle, 'String');
  L=length(str);
  val=val+1;
  if(val>L), val=1; end
  set(time_handle,'Value',val);  
  L_epoch=str2double(str{val});
  
  handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];
  set(handles.plot_axes,'xlim',handles.x_limit);

  % and put this number for display in the 'epoch box':
  epoch_handle=findobj(hObject,'Tag','epoch_size');
  set(epoch_handle,'String',num2str(L_epoch));
  guidata(hObject,handles);

elseif( strcmp(eventdata.Key,'s')==1 )
  time_handle=findobj(hObject,'Tag','time_scale');

  val=get(time_handle,'Value');
  str=get(time_handle, 'String');
  L=length(str);
  val=val-1;
  if(val<1), val=L; end
  set(time_handle,'Value',val);  
  L_epoch=str2double(str{val});
  
  handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];
  set(handles.plot_axes,'xlim',handles.x_limit);

  % and put this number for display in the 'epoch box':
  epoch_handle=findobj(hObject,'Tag','epoch_size');
  set(epoch_handle,'String',num2str(L_epoch));
  guidata(hObject,handles);

  
  
end


% --- Executes on selection change in montage_list.
function montage_list_Callback(hObject, eventdata, handles)
% hObject    handle to montage_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns montage_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from montage_list
contents=cellstr(get(hObject,'String'));
if(strcmp(contents{get(hObject,'Value')},'monopolar')==1)
  handles.bipolar=0;
else
  handles.bipolar=1;
end

guidata(gcbf,handles);

eplot_data(handles.sig,handles.Fs,handles.plot_axes, ...
           handles.channel_labs,handles.amplitude_scale, ...
           handles.HARD_LIMIT_VOLT,handles.highlight_chan, ...
           handles.x_limit,handles.bipolar);



% --- Executes during object creation, after setting all properties.
function montage_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to montage_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function info_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to info_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in time_scale.
function time_scale_Callback(hObject, eventdata, handles)
% hObject    handle to time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns time_scale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from time_scale

contents=cellstr(get(hObject,'String'));
val=contents{get(hObject,'Value')};

L_epoch=str2double(val);

handles.x_limit=[handles.x_limit(1) handles.x_limit(1)+L_epoch];

set(handles.plot_axes,'xlim',handles.x_limit);

% and put this number for display in the 'epoch box':
epoch_handle=findobj(gcbf,'Tag','epoch_size');
set(epoch_handle,'String',num2str(L_epoch));


guidata(gcbf,handles);






% --- Executes during object creation, after setting all properties.
function time_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end