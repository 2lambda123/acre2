class Prc117f_RscBackground {
        type = CT_STATIC;
        idc = -1;
        style = QUOTE(ST_BACKGROUND + ST_KEEP_ASPECT_RATIO);
        colorBackground[] = {0, 0, 0, 0.75};
        colorText[] = {1, 1, 1, 1};
        font = FontM;
        sizeEx = 0.04;
};

// text
class Prc117f_RscText {
    idc = -1;
    type = CT_STATIC;
    style = ST_CENTER;
    font = "PixelSplitterBold";
    colorText[] = {1,1,1,1};
    colorBackground[] = {0, 0, 0, 0};
    sizeEx = 0.024;
    shadow = 0;
    w = 0.2;
    h = 0.03;
};

class Prc117f_RscButton {
  type = CT_BUTTON;
  idc = -1;
  style = QUOTE(ST_CENTER + ST_KEEP_ASPECT_RATIO);

  x = 0.0;
  y = 0.0;
  w = 0.1;
  //h = Dlg_CONTROLHGT; // TODO HEMTT Did this ever do anything - undefined macro
  sizeEx = 0.0325;
  offsetX = 0;
  offsetY = 0.002;
  offsetPressedX = 0;
  offsetPressedY = 0.002;
  borderSize = 0;

  #define ClrWhite 1,1,1
  #define ClrBlack 0,0,0
  #define ClrGray 0.5,0.5,0.5
  #define ClrBlue 0.2,0.5,1

  colorText[] = {ClrWhite,1};
  colorBackground[] = {ClrGray, 0};
  colorFocused[] = {ClrGray,00};

  colorShadow[] = {ClrBlack,0};
  colorBorder[] = {ClrWhite,0};
  colorBackgroundActive[] = {ClrGray,0};
  colorDisabled[] = {ClrGray, 0};
  colorBackgroundDisabled[] = {ClrGray,0};
  font = FontM;

  soundEnter[] = {"", 0.2, 1};
  soundPush[] = {"", 0.2, 1};
  soundClick[] = {"", 0.2, 1};
  soundEscape[] = {"", 0.2, 1};

  default = 0;
  text = "";
  action = "";
};

class Prc117f_RscPicture: Prc117f_RscButton {
    type = CT_STATIC;
    idc = -1;
    style = QUOTE(ST_PICTURE + ST_KEEP_ASPECT_RATIO);
    text = "";
};
