function varargout = Recognition(varargin)
% RECOGNITION MATLAB code for Recognition.fig
%      RECOGNITION, by itself, creates a new RECOGNITION or raises the existing
%      singleton*.
%
%      H = RECOGNITION returns the handle to a new RECOGNITION or the handle to
%      the existing singleton*.
%
%      RECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGNITION.M with the given input arguments.
%
%      RECOGNITION('Property','Value',...) creates a new RECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Recognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Recognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Recognition

% Last Modified by GUIDE v2.5 25-May-2019 20:40:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Recognition_OpeningFcn, ...
                   'gui_OutputFcn',  @Recognition_OutputFcn, ...
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


% --- Executes just before Recognition is made visible.
function Recognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Recognition (see VARARGIN)

% Choose default command line output for Recognition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Recognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Recognition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)  %���ļ���ʾʱ��Ƶ��ͼ��ť
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x
global Fs
global music
[filename,filepath] = uigetfile({'*'},'ѡ����Ƶ�ļ�');
if filename==0
    return
else
    music=[filepath,filename];
    [x,Fs] = audioread(music);%��ȡ��Ƶ����
    samplesize=size(x);
    if samplesize(2)>1
        x=x(:,1);
    end
end
x = x(:,1);
x = x';
xx=x/max(abs(x));
N = length(x);%��ȡ��������
t = (0:N-1)/Fs;%��ʾʵ��ʱ��
y = fft(x);%���źŽ��и���Ҷ�任
f = Fs/N*(0:round(N/2)-1);%��ʾʵ��Ƶ���һ��
axes(handles.axes1)
plot(t,xx);%����ʱ����
axis([0 max(t) -1.1 1.1]);
xlabel('Time / (s)');ylabel('Amplitude');
title('�źŵĲ���');
grid;
axes(handles.axes2)
plot(f,abs(y(1:round(N/2))));
xlabel('Frequency / (Hz)');ylabel('Amplitude');
set(gca, 'XLim',[20 20000]); 
title('�źŵ�Ƶ��');
grid;
set(handles.text3,'String','');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)  %ʶ��ť
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text3,'String','ʶ����...');
global music
[sound,rfs] = audioread(music);
[v_num]=EndDetection(sound);
if (v_num<2)    %��һ�������ξ�Ϊ���֣�����������Ϊ����
    set(handles.text3,'String','����');
else
    set(handles.text3,'String','����');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)  %���Ű�ť
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global Fs;
sound(x,Fs);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)  %ֹͣ��ť
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)  %¼��10s
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text3,'String','¼����...');
R = audiorecorder(16000, 16 ,1) ;
recordblocking(R, 10);
myspeech = getaudiodata(R);
audiowrite('record.wav',myspeech,16000)
set(handles.text3,'String','¼�����');
