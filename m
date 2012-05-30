Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2E3W05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 18:26:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab2E3W04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 18:26:56 -0400
Date: Wed, 30 May 2012 18:26:51 -0400
From: Dave Jones <davej@redhat.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Lots of i915/drm spew on 3.4
Message-ID: <20120530222651.GA22449@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <20120530213128.GA10407@redhat.com>
 <CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
 <20120530215848.GB19223@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20120530215848.GB19223@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 30, 2012 at 05:58:48PM -0400, Dave Jones wrote:
 > On Wed, May 30, 2012 at 11:51:54PM +0200, Daniel Vetter wrote:
 >  > On Wed, May 30, 2012 at 11:31 PM, Dave Jones <davej@redhat.com> wrote:
 >  > > On this hardware:
 >  > >
 >  > > 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
 >  > >
 >  > > I get this every boot with Linus current tree (up to af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76)
 >  > 
 >  > Just a quick question, is this a regression? 
 > 
 > seems so, I don't see it on 3.3
 > 
 >  > If so, can you please
 >  > attach the output of xrandr --verbose from a noisy and a quite kernel
 >  > (otherwise just please attach it from this noisy kernel).
 > 
 > this machine runs headless, so has no X installed right now, I'll get it in a while.

Attached.

	Dave 

--17pEHd4RhPHOinZp
Content-Type: application/x-troff-man
Content-Disposition: attachment; filename="xrandr-3.3"
Content-Transfer-Encoding: quoted-printable

Screen 0: minimum 320 x 200, current 1280 x 1024, maximum 4096 x 4096=0AVGA=
1 connected 1280x1024+0+0 (0x45) normal (normal left inverted right x axis =
y axis) 375mm x 301mm=0A	Identifier: 0x41=0A	Timestamp:  84507=0A	Subpixel:=
   unknown=0A	Gamma:      1.0:1.0:1.0=0A	Brightness: 1.0=0A	Clones:     TV1=
=0A	CRTC:       0=0A	CRTCs:      0 1=0A	Transform:  1.000000 0.000000 0.000=
000=0A	            0.000000 1.000000 0.000000=0A	            0.000000 0.000=
000 1.000000=0A	           filter: =0A	EDID:=0A		00ffffffffffff000472905963=
0d0000=0A		050f01036d251e78ea5ec0a4594a9825=0A		205054bfef007140714a714f814=
0814a=0A		814f81800101302a009851002a403070=0A		1300772d1100001e000000ff0045=
544c=0A		323330323032320a2020000000fd0031=0A		4b18500e000a20202020202000000=
0fc=0A		004163657220414c313931320a20005e=0A  1280x1024 (0x45)  108.0MHz +HS=
ync +VSync *current +preferred=0A        h: width  1280 start 1328 end 1440=
 total 1688 skew    0 clock   64.0KHz=0A        v: height 1024 start 1025 e=
nd 1028 total 1066           clock   60.0Hz=0A  1280x1024 (0x46)  135.0MHz =
+HSync +VSync=0A        h: width  1280 start 1296 end 1440 total 1688 skew =
   0 clock   80.0KHz=0A        v: height 1024 start 1025 end 1028 total 106=
6           clock   75.0Hz=0A  1280x960 (0x47)  129.9MHz -HSync +VSync=0A  =
      h: width  1280 start 1368 end 1504 total 1728 skew    0 clock   75.2K=
Hz=0A        v: height  960 start  961 end  964 total 1002           clock =
  75.0Hz=0A  1280x960 (0x48)  120.9MHz -HSync +VSync=0A        h: width  12=
80 start 1368 end 1504 total 1728 skew    0 clock   70.0KHz=0A        v: he=
ight  960 start  961 end  964 total  999           clock   70.0Hz=0A  1280x=
960 (0x49)  108.0MHz +HSync +VSync=0A        h: width  1280 start 1376 end =
1488 total 1800 skew    0 clock   60.0KHz=0A        v: height  960 start  9=
61 end  964 total 1000           clock   60.0Hz=0A  1152x864 (0x4a)  108.0M=
Hz +HSync +VSync=0A        h: width  1152 start 1216 end 1344 total 1600 sk=
ew    0 clock   67.5KHz=0A        v: height  864 start  865 end  868 total =
 900           clock   75.0Hz=0A  1152x864 (0x4b)   96.7MHz -HSync +VSync=
=0A        h: width  1152 start 1224 end 1344 total 1536 skew    0 clock   =
63.0KHz=0A        v: height  864 start  865 end  868 total  900           c=
lock   70.0Hz=0A  1152x864 (0x4c)   81.6MHz -HSync +VSync=0A        h: widt=
h  1152 start 1216 end 1336 total 1520 skew    0 clock   53.7KHz=0A        =
v: height  864 start  865 end  868 total  895           clock   60.0Hz=0A  =
1024x768 (0x4d)   78.8MHz +HSync +VSync=0A        h: width  1024 start 1040=
 end 1136 total 1312 skew    0 clock   60.1KHz=0A        v: height  768 sta=
rt  769 end  772 total  800           clock   75.1Hz=0A  1024x768 (0x4e)   =
75.0MHz -HSync -VSync=0A        h: width  1024 start 1048 end 1184 total 13=
28 skew    0 clock   56.5KHz=0A        v: height  768 start  771 end  777 t=
otal  806           clock   70.1Hz=0A  1024x768 (0x4f)   65.0MHz -HSync -VS=
ync=0A        h: width  1024 start 1048 end 1184 total 1344 skew    0 clock=
   48.4KHz=0A        v: height  768 start  771 end  777 total  806         =
  clock   60.0Hz=0A  832x624 (0x50)   57.3MHz -HSync -VSync=0A        h: wi=
dth   832 start  864 end  928 total 1152 skew    0 clock   49.7KHz=0A      =
  v: height  624 start  625 end  628 total  667           clock   74.6Hz=0A=
  800x600 (0x51)   50.0MHz +HSync +VSync=0A        h: width   800 start  85=
6 end  976 total 1040 skew    0 clock   48.1KHz=0A        v: height  600 st=
art  637 end  643 total  666           clock   72.2Hz=0A  800x600 (0x52)   =
49.5MHz +HSync +VSync=0A        h: width   800 start  816 end  896 total 10=
56 skew    0 clock   46.9KHz=0A        v: height  600 start  601 end  604 t=
otal  625           clock   75.0Hz=0A  800x600 (0x53)   40.0MHz +HSync +VSy=
nc=0A        h: width   800 start  840 end  968 total 1056 skew    0 clock =
  37.9KHz=0A        v: height  600 start  601 end  605 total  628          =
 clock   60.3Hz=0A  800x600 (0x54)   36.0MHz +HSync +VSync=0A        h: wid=
th   800 start  824 end  896 total 1024 skew    0 clock   35.2KHz=0A       =
 v: height  600 start  601 end  603 total  625           clock   56.2Hz=0A =
 640x480 (0x55)   31.5MHz -HSync -VSync=0A        h: width   640 start  664=
 end  704 total  832 skew    0 clock   37.9KHz=0A        v: height  480 sta=
rt  489 end  491 total  520           clock   72.8Hz=0A  640x480 (0x56)   3=
1.5MHz -HSync -VSync=0A        h: width   640 start  656 end  720 total  84=
0 skew    0 clock   37.5KHz=0A        v: height  480 start  481 end  484 to=
tal  500           clock   75.0Hz=0A  640x480 (0x57)   30.2MHz -HSync -VSyn=
c=0A        h: width   640 start  704 end  768 total  864 skew    0 clock  =
 35.0KHz=0A        v: height  480 start  483 end  486 total  525           =
clock   66.7Hz=0A  640x480 (0x58)   25.2MHz -HSync -VSync=0A        h: widt=
h   640 start  656 end  752 total  800 skew    0 clock   31.5KHz=0A        =
v: height  480 start  490 end  492 total  525           clock   60.0Hz=0A  =
720x400 (0x59)   28.3MHz -HSync +VSync=0A        h: width   720 start  738 =
end  846 total  900 skew    0 clock   31.5KHz=0A        v: height  400 star=
t  412 end  414 total  449           clock   70.1Hz=0ATV1 disconnected (nor=
mal left inverted right x axis y axis)=0A	Identifier: 0x42=0A	Timestamp:  8=
4507=0A	Subpixel:   horizontal rgb=0A	Clones:     VGA1=0A	CRTCs:      0 1=
=0A	Transform:  1.000000 0.000000 0.000000=0A	            0.000000 1.000000=
 0.000000=0A	            0.000000 0.000000 1.000000=0A	           filter: =
=0A	tv_chroma_filter: 1 (0x00000001)	range:  (0,3)=0A	flicker_filter_adapti=
ve: 7 (0x00000007)	range:  (0,7)=0A	brightness: 128 (0x00000080)	range:  (0=
,255)=0A	sharpness: 4 (0x00000004)	range:  (0,7)=0A	hue: 64 (0x00000040)	ra=
nge:  (0,127)=0A	contrast: 64 (0x00000040)	range:  (0,127)=0A	saturation: 6=
9 (0x00000045)	range:  (0,127)=0A	vpos: 512 (0x00000200)	range:  (0,1023)=
=0A	hpos: 512 (0x00000200)	range:  (0,1023)=0A	bottom_margin: 15 (0x0000000=
f)	range:  (0,47)=0A	top_margin: 15 (0x0000000f)	range:  (0,47)=0A	right_ma=
rgin: 15 (0x0000000f)	range:  (0,47)=0A	left_margin: 15 (0x0000000f)	range:=
  (0,47)=0A	mode:	NTSC_M=0A		supported: NTSC_M       NTSC_J       NTSC_443 =
    PAL_B       =0A		           PAL_D        PAL_G        PAL_H        PAL_=
I       =0A		           PAL_M        PAL_N        PAL_NC       PAL_60      =
=0A		           SECAM_B      SECAM_D      SECAM_G      SECAM_K     =0A		   =
        SECAM_K1     SECAM_L      SECAM_60    =0ATV2 disconnected (normal l=
eft inverted right x axis y axis)=0A	Identifier: 0x43=0A	Timestamp:  84507=
=0A	Subpixel:   horizontal rgb=0A	Clones:     VGA1 TV1=0A	CRTCs:      0 1=
=0A	Transform:  1.000000 0.000000 0.000000=0A	            0.000000 1.000000=
 0.000000=0A	            0.000000 0.000000 1.000000=0A	           filter: =
=0A	tv_chroma_filter: 1 (0x00000001)	range:  (0,3)=0A	flicker_filter_adapti=
ve: 7 (0x00000007)	range:  (0,7)=0A	brightness: 128 (0x00000080)	range:  (0=
,255)=0A	sharpness: 4 (0x00000004)	range:  (0,7)=0A	hue: 64 (0x00000040)	ra=
nge:  (0,127)=0A	contrast: 64 (0x00000040)	range:  (0,127)=0A	saturation: 6=
9 (0x00000045)	range:  (0,127)=0A	vpos: 512 (0x00000200)	range:  (0,1023)=
=0A	hpos: 512 (0x00000200)	range:  (0,1023)=0A	bottom_margin: 15 (0x0000000=
f)	range:  (0,47)=0A	top_margin: 15 (0x0000000f)	range:  (0,47)=0A	right_ma=
rgin: 15 (0x0000000f)	range:  (0,47)=0A	left_margin: 15 (0x0000000f)	range:=
  (0,47)=0A	mode:	NTSC_M=0A		supported: NTSC_M       NTSC_J       NTSC_443 =
    PAL_B       =0A		           PAL_D        PAL_G        PAL_H        PAL_=
I       =0A		           PAL_M        PAL_N        PAL_NC       PAL_60      =
=0A		           SECAM_B      SECAM_D      SECAM_G      SECAM_K     =0A		   =
        SECAM_K1     SECAM_L      SECAM_60    =0AVGA2 disconnected (normal =
left inverted right x axis y axis)=0A	Identifier: 0x44=0A	Timestamp:  84507=
=0A	Subpixel:   horizontal rgb=0A	Clones:     VGA1 TV1=0A	CRTCs:      0 1=
=0A	Transform:  1.000000 0.000000 0.000000=0A	            0.000000 1.000000=
 0.000000=0A	            0.000000 0.000000 1.000000=0A	           filter: =
=0A
--17pEHd4RhPHOinZp
Content-Type: application/x-troff-man
Content-Disposition: attachment; filename="xrandr-3.4"
Content-Transfer-Encoding: quoted-printable

Screen 0: minimum 320 x 200, current 1280 x 1024, maximum 4096 x 4096=0AVGA=
1 connected 1280x1024+0+0 (0x46) normal (normal left inverted right x axis =
y axis) 375mm x 301mm=0A	Identifier: 0x41=0A	Timestamp:  3299703=0A	Subpixe=
l:   unknown=0A	Gamma:      1.0:1.0:1.0=0A	Brightness: 1.0=0A	Clones:     T=
V1=0A	CRTC:       0=0A	CRTCs:      0 1=0A	Transform:  1.000000 0.000000 0.0=
00000=0A	            0.000000 1.000000 0.000000=0A	            0.000000 0.0=
00000 1.000000=0A	           filter: =0A	EDID:=0A		00ffffffffffff0004729059=
630d0000=0A		050f01036d251e78ea5ec0a4594a9825=0A		205054bfef007140714a714f8=
140814a=0A		814f81800101302a009851002a403070=0A		1300772d1100001e000000ff00=
45544c=0A		323330323032320a2020000000fd0031=0A		4b18500e000a202020202020000=
000fc=0A		004163657220414c313931320a20005e=0A  1280x1024 (0x46)  108.0MHz +=
HSync +VSync *current +preferred=0A        h: width  1280 start 1328 end 14=
40 total 1688 skew    0 clock   64.0KHz=0A        v: height 1024 start 1025=
 end 1028 total 1066           clock   60.0Hz=0A  1680x945 (0x47)  131.5MHz=
 -HSync +VSync=0A        h: width  1680 start 1784 end 1960 total 2240 skew=
    0 clock   58.7KHz=0A        v: height  945 start  946 end  949 total  9=
78           clock   60.0Hz=0A  1400x1050 (0x48)  121.8MHz -HSync +VSync=0A=
        h: width  1400 start 1488 end 1632 total 1864 skew    0 clock   65.=
3KHz=0A        v: height 1050 start 1053 end 1057 total 1089           cloc=
k   60.0Hz=0A  1600x900 (0x49)  119.0MHz -HSync +VSync=0A        h: width  =
1600 start 1696 end 1864 total 2128 skew    0 clock   55.9KHz=0A        v: =
height  900 start  901 end  904 total  932           clock   60.0Hz=0A  128=
0x1024 (0x4a)  135.0MHz +HSync +VSync=0A        h: width  1280 start 1296 e=
nd 1440 total 1688 skew    0 clock   80.0KHz=0A        v: height 1024 start=
 1025 end 1028 total 1066           clock   75.0Hz=0A  1440x900 (0x4b)  136=
=2E8MHz -HSync +VSync=0A        h: width  1440 start 1536 end 1688 total 19=
36 skew    0 clock   70.6KHz=0A        v: height  900 start  903 end  909 t=
otal  942           clock   75.0Hz=0A  1440x900 (0x4c)  106.5MHz -HSync +VS=
ync=0A        h: width  1440 start 1520 end 1672 total 1904 skew    0 clock=
   55.9KHz=0A        v: height  900 start  903 end  909 total  934         =
  clock   59.9Hz=0A  1280x960 (0x4d)  129.9MHz -HSync +VSync=0A        h: w=
idth  1280 start 1368 end 1504 total 1728 skew    0 clock   75.2KHz=0A     =
   v: height  960 start  961 end  964 total 1002           clock   75.0Hz=
=0A  1280x960 (0x4e)  120.9MHz -HSync +VSync=0A        h: width  1280 start=
 1368 end 1504 total 1728 skew    0 clock   70.0KHz=0A        v: height  96=
0 start  961 end  964 total  999           clock   70.0Hz=0A  1280x960 (0x4=
f)  108.0MHz +HSync +VSync=0A        h: width  1280 start 1376 end 1488 tot=
al 1800 skew    0 clock   60.0KHz=0A        v: height  960 start  961 end  =
964 total 1000           clock   60.0Hz=0A  1366x768 (0x50)   85.9MHz -HSyn=
c +VSync=0A        h: width  1366 start 1439 end 1583 total 1800 skew    0 =
clock   47.7KHz=0A        v: height  768 start  769 end  772 total  795    =
       clock   60.0Hz=0A  1360x768 (0x51)   85.5MHz +HSync +VSync=0A       =
 h: width  1360 start 1424 end 1536 total 1792 skew    0 clock   47.7KHz=0A=
        v: height  768 start  771 end  777 total  795           clock   60.=
0Hz=0A  1280x800 (0x52)  106.5MHz -HSync +VSync=0A        h: width  1280 st=
art 1360 end 1488 total 1696 skew    0 clock   62.8KHz=0A        v: height =
 800 start  803 end  809 total  838           clock   74.9Hz=0A  1280x800 (=
0x53)   83.5MHz +HSync -VSync=0A        h: width  1280 start 1352 end 1480 =
total 1680 skew    0 clock   49.7KHz=0A        v: height  800 start  803 en=
d  809 total  831           clock   59.8Hz=0A  1152x864 (0x54)  108.0MHz +H=
Sync +VSync=0A        h: width  1152 start 1216 end 1344 total 1600 skew   =
 0 clock   67.5KHz=0A        v: height  864 start  865 end  868 total  900 =
          clock   75.0Hz=0A  1152x864 (0x55)   96.7MHz -HSync +VSync=0A    =
    h: width  1152 start 1224 end 1344 total 1536 skew    0 clock   63.0KHz=
=0A        v: height  864 start  865 end  868 total  900           clock   =
70.0Hz=0A  1152x864 (0x56)   81.6MHz -HSync +VSync=0A        h: width  1152=
 start 1216 end 1336 total 1520 skew    0 clock   53.7KHz=0A        v: heig=
ht  864 start  865 end  868 total  895           clock   60.0Hz=0A  1280x76=
8 (0x57)  102.2MHz +HSync -VSync=0A        h: width  1280 start 1360 end 14=
88 total 1696 skew    0 clock   60.3KHz=0A        v: height  768 start  771=
 end  778 total  805           clock   74.9Hz=0A  1280x768 (0x58)   79.5MHz=
 -HSync +VSync=0A        h: width  1280 start 1344 end 1472 total 1664 skew=
    0 clock   47.8KHz=0A        v: height  768 start  771 end  778 total  7=
98           clock   59.9Hz=0A  1024x768 (0x59)   78.8MHz +HSync +VSync=0A =
       h: width  1024 start 1040 end 1136 total 1312 skew    0 clock   60.1=
KHz=0A        v: height  768 start  769 end  772 total  800           clock=
   75.1Hz=0A  1024x768 (0x5a)   78.8MHz +HSync +VSync=0A        h: width  1=
024 start 1040 end 1136 total 1312 skew    0 clock   60.0KHz=0A        v: h=
eight  768 start  769 end  772 total  800           clock   75.0Hz=0A  1024=
x768 (0x5b)   75.0MHz -HSync -VSync=0A        h: width  1024 start 1048 end=
 1184 total 1328 skew    0 clock   56.5KHz=0A        v: height  768 start  =
771 end  777 total  806           clock   70.1Hz=0A  1024x768 (0x5c)   65.0=
MHz -HSync -VSync=0A        h: width  1024 start 1048 end 1184 total 1344 s=
kew    0 clock   48.4KHz=0A        v: height  768 start  771 end  777 total=
  806           clock   60.0Hz=0A  1024x576 (0x5d)   47.0MHz -HSync +VSync=
=0A        h: width  1024 start 1064 end 1168 total 1312 skew    0 clock   =
35.8KHz=0A        v: height  576 start  577 end  580 total  597           c=
lock   60.0Hz=0A  832x624 (0x5e)   57.3MHz -HSync -VSync=0A        h: width=
   832 start  864 end  928 total 1152 skew    0 clock   49.7KHz=0A        v=
: height  624 start  625 end  628 total  667           clock   74.6Hz=0A  8=
00x600 (0x5f)   50.0MHz +HSync +VSync=0A        h: width   800 start  856 e=
nd  976 total 1040 skew    0 clock   48.1KHz=0A        v: height  600 start=
  637 end  643 total  666           clock   72.2Hz=0A  800x600 (0x60)   49.=
5MHz +HSync +VSync=0A        h: width   800 start  816 end  896 total 1056 =
skew    0 clock   46.9KHz=0A        v: height  600 start  601 end  604 tota=
l  625           clock   75.0Hz=0A  800x600 (0x61)   40.0MHz +HSync +VSync=
=0A        h: width   800 start  840 end  968 total 1056 skew    0 clock   =
37.9KHz=0A        v: height  600 start  601 end  605 total  628           c=
lock   60.3Hz=0A  800x600 (0x62)   36.0MHz +HSync +VSync=0A        h: width=
   800 start  824 end  896 total 1024 skew    0 clock   35.2KHz=0A        v=
: height  600 start  601 end  603 total  625           clock   56.2Hz=0A  8=
48x480 (0x63)   33.8MHz +HSync +VSync=0A        h: width   848 start  864 e=
nd  976 total 1088 skew    0 clock   31.0KHz=0A        v: height  480 start=
  486 end  494 total  517           clock   60.0Hz=0A  640x480 (0x64)   31.=
5MHz -HSync -VSync=0A        h: width   640 start  656 end  720 total  840 =
skew    0 clock   37.5KHz=0A        v: height  480 start  481 end  484 tota=
l  500           clock   75.0Hz=0A  640x480 (0x65)   31.5MHz -HSync -VSync=
=0A        h: width   640 start  664 end  704 total  832 skew    0 clock   =
37.9KHz=0A        v: height  480 start  489 end  492 total  520           c=
lock   72.8Hz=0A  640x480 (0x66)   31.5MHz -HSync -VSync=0A        h: width=
   640 start  664 end  704 total  832 skew    0 clock   37.9KHz=0A        v=
: height  480 start  489 end  491 total  520           clock   72.8Hz=0A  6=
40x480 (0x67)   30.2MHz -HSync -VSync=0A        h: width   640 start  704 e=
nd  768 total  864 skew    0 clock   35.0KHz=0A        v: height  480 start=
  483 end  486 total  525           clock   66.7Hz=0A  640x480 (0x68)   25.=
2MHz -HSync -VSync=0A        h: width   640 start  656 end  752 total  800 =
skew    0 clock   31.5KHz=0A        v: height  480 start  490 end  492 tota=
l  525           clock   60.0Hz=0A  640x480 (0x69)   25.2MHz -HSync -VSync=
=0A        h: width   640 start  656 end  752 total  800 skew    0 clock   =
31.5KHz=0A        v: height  480 start  489 end  492 total  525           c=
lock   59.9Hz=0A  720x400 (0x6a)   28.3MHz -HSync +VSync=0A        h: width=
   720 start  738 end  846 total  900 skew    0 clock   31.5KHz=0A        v=
: height  400 start  412 end  414 total  449           clock   70.1Hz=0ATV1=
 unknown connection (normal left inverted right x axis y axis)=0A	Identifie=
r: 0x42=0A	Timestamp:  3299703=0A	Subpixel:   horizontal rgb=0A	Clones:    =
 VGA1=0A	CRTCs:      0 1=0A	Transform:  1.000000 0.000000 0.000000=0A	     =
       0.000000 1.000000 0.000000=0A	            0.000000 0.000000 1.000000=
=0A	           filter: =0A	tv_chroma_filter: 1 (0x00000001)	range:  (0,3)=
=0A	flicker_filter_adaptive: 7 (0x00000007)	range:  (0,7)=0A	brightness: 12=
8 (0x00000080)	range:  (0,255)=0A	sharpness: 4 (0x00000004)	range:  (0,7)=
=0A	hue: 64 (0x00000040)	range:  (0,127)=0A	contrast: 64 (0x00000040)	range=
:  (0,127)=0A	saturation: 69 (0x00000045)	range:  (0,127)=0A	vpos: 512 (0x0=
0000200)	range:  (0,1023)=0A	hpos: 512 (0x00000200)	range:  (0,1023)=0A	bot=
tom_margin: 15 (0x0000000f)	range:  (0,47)=0A	top_margin: 15 (0x0000000f)	r=
ange:  (0,47)=0A	right_margin: 15 (0x0000000f)	range:  (0,47)=0A	left_margi=
n: 15 (0x0000000f)	range:  (0,47)=0A	mode:	NTSC_M=0A		supported: NTSC_M    =
   NTSC_J       NTSC_443     PAL_B       =0A		           PAL_D        PAL_G=
        PAL_H        PAL_I       =0A		           PAL_M        PAL_N        =
PAL_NC       PAL_60      =0A		           SECAM_B      SECAM_D      SECAM_G =
     SECAM_K     =0A		           SECAM_K1     SECAM_L      SECAM_60    =0A =
 1024x768 (0x5c)   65.0MHz -HSync -VSync=0A        h: width  1024 start 104=
8 end 1184 total 1344 skew    0 clock   48.4KHz=0A        v: height  768 st=
art  771 end  777 total  806           clock   60.0Hz=0A  800x600 (0x61)   =
40.0MHz +HSync +VSync=0A        h: width   800 start  840 end  968 total 10=
56 skew    0 clock   37.9KHz=0A        v: height  600 start  601 end  605 t=
otal  628           clock   60.3Hz=0A  640x480 (0x6b)   25.2MHz -HSync -VSy=
nc=0A        h: width   640 start  656 end  752 total  800 skew    0 clock =
  31.5KHz=0A        v: height  480 start  490 end  492 total  525          =
 clock   59.9Hz=0ATV2 unknown connection (normal left inverted right x axis=
 y axis)=0A	Identifier: 0x43=0A	Timestamp:  3299703=0A	Subpixel:   horizont=
al rgb=0A	Clones:     VGA1 TV1=0A	CRTCs:      0 1=0A	Transform:  1.000000 0=
=2E000000 0.000000=0A	            0.000000 1.000000 0.000000=0A	           =
 0.000000 0.000000 1.000000=0A	           filter: =0A	tv_chroma_filter: 1 (=
0x00000001)	range:  (0,3)=0A	flicker_filter_adaptive: 7 (0x00000007)	range:=
  (0,7)=0A	brightness: 128 (0x00000080)	range:  (0,255)=0A	sharpness: 4 (0x=
00000004)	range:  (0,7)=0A	hue: 64 (0x00000040)	range:  (0,127)=0A	contrast=
: 64 (0x00000040)	range:  (0,127)=0A	saturation: 69 (0x00000045)	range:  (0=
,127)=0A	vpos: 512 (0x00000200)	range:  (0,1023)=0A	hpos: 512 (0x00000200)	=
range:  (0,1023)=0A	bottom_margin: 15 (0x0000000f)	range:  (0,47)=0A	top_ma=
rgin: 15 (0x0000000f)	range:  (0,47)=0A	right_margin: 15 (0x0000000f)	range=
:  (0,47)=0A	left_margin: 15 (0x0000000f)	range:  (0,47)=0A	mode:	NTSC_M=0A=
		supported: NTSC_M       NTSC_J       NTSC_443     PAL_B       =0A		      =
     PAL_D        PAL_G        PAL_H        PAL_I       =0A		           PAL=
_M        PAL_N        PAL_NC       PAL_60      =0A		           SECAM_B    =
  SECAM_D      SECAM_G      SECAM_K     =0A		           SECAM_K1     SECAM_=
L      SECAM_60    =0A  1024x768 (0x5c)   65.0MHz -HSync -VSync=0A        h=
: width  1024 start 1048 end 1184 total 1344 skew    0 clock   48.4KHz=0A  =
      v: height  768 start  771 end  777 total  806           clock   60.0H=
z=0A  800x600 (0x61)   40.0MHz +HSync +VSync=0A        h: width   800 start=
  840 end  968 total 1056 skew    0 clock   37.9KHz=0A        v: height  60=
0 start  601 end  605 total  628           clock   60.3Hz=0A  640x480 (0x6b=
)   25.2MHz -HSync -VSync=0A        h: width   640 start  656 end  752 tota=
l  800 skew    0 clock   31.5KHz=0A        v: height  480 start  490 end  4=
92 total  525           clock   59.9Hz=0ATV3 unknown connection (normal lef=
t inverted right x axis y axis)=0A	Identifier: 0x44=0A	Timestamp:  3299703=
=0A	Subpixel:   horizontal rgb=0A	Clones:     VGA1 TV1=0A	CRTCs:      0 1=
=0A	Transform:  1.000000 0.000000 0.000000=0A	            0.000000 1.000000=
 0.000000=0A	            0.000000 0.000000 1.000000=0A	           filter: =
=0A	tv_chroma_filter: 1 (0x00000001)	range:  (0,3)=0A	flicker_filter_adapti=
ve: 7 (0x00000007)	range:  (0,7)=0A	brightness: 128 (0x00000080)	range:  (0=
,255)=0A	sharpness: 4 (0x00000004)	range:  (0,7)=0A	hue: 64 (0x00000040)	ra=
nge:  (0,127)=0A	contrast: 64 (0x00000040)	range:  (0,127)=0A	saturation: 6=
9 (0x00000045)	range:  (0,127)=0A	vpos: 512 (0x00000200)	range:  (0,1023)=
=0A	hpos: 512 (0x00000200)	range:  (0,1023)=0A	bottom_margin: 15 (0x0000000=
f)	range:  (0,47)=0A	top_margin: 15 (0x0000000f)	range:  (0,47)=0A	right_ma=
rgin: 15 (0x0000000f)	range:  (0,47)=0A	left_margin: 15 (0x0000000f)	range:=
  (0,47)=0A	mode:	NTSC_M=0A		supported: NTSC_M       NTSC_J       NTSC_443 =
    PAL_B       =0A		           PAL_D        PAL_G        PAL_H        PAL_=
I       =0A		           PAL_M        PAL_N        PAL_NC       PAL_60      =
=0A		           SECAM_B      SECAM_D      SECAM_G      SECAM_K     =0A		   =
        SECAM_K1     SECAM_L      SECAM_60    =0A  1024x768 (0x5c)   65.0MH=
z -HSync -VSync=0A        h: width  1024 start 1048 end 1184 total 1344 ske=
w    0 clock   48.4KHz=0A        v: height  768 start  771 end  777 total  =
806           clock   60.0Hz=0A  800x600 (0x61)   40.0MHz +HSync +VSync=0A =
       h: width   800 start  840 end  968 total 1056 skew    0 clock   37.9=
KHz=0A        v: height  600 start  601 end  605 total  628           clock=
   60.3Hz=0A  640x480 (0x6b)   25.2MHz -HSync -VSync=0A        h: width   6=
40 start  656 end  752 total  800 skew    0 clock   31.5KHz=0A        v: he=
ight  480 start  490 end  492 total  525           clock   59.9Hz=0AVGA2 un=
known connection (normal left inverted right x axis y axis)=0A	Identifier: =
0x45=0A	Timestamp:  3299703=0A	Subpixel:   horizontal rgb=0A	Clones:     VG=
A1 TV1=0A	CRTCs:      0 1=0A	Transform:  1.000000 0.000000 0.000000=0A	    =
        0.000000 1.000000 0.000000=0A	            0.000000 0.000000 1.00000=
0=0A	           filter: =0A	EDID:=0A		00ffffffffffff0004729059630d0000=0A		=
050f01036d251e78ea5ec0a4594a9825=0A		205054bfef007140714a714f8140814a=0A		8=
14f81800101302a009851002a403070=0A		1300772d1100001e000000ff0045544c=0A		32=
3330323032320a2020000000fd0031=0A		4b18500e000a202020202020000000fc=0A		004=
163657220414c313931320a20005e=0A  1280x1024 (0x46)  108.0MHz +HSync +VSync =
+preferred=0A        h: width  1280 start 1328 end 1440 total 1688 skew    =
0 clock   64.0KHz=0A        v: height 1024 start 1025 end 1028 total 1066  =
         clock   60.0Hz=0A  1680x945 (0x47)  131.5MHz -HSync +VSync=0A     =
   h: width  1680 start 1784 end 1960 total 2240 skew    0 clock   58.7KHz=
=0A        v: height  945 start  946 end  949 total  978           clock   =
60.0Hz=0A  1400x1050 (0x48)  121.8MHz -HSync +VSync=0A        h: width  140=
0 start 1488 end 1632 total 1864 skew    0 clock   65.3KHz=0A        v: hei=
ght 1050 start 1053 end 1057 total 1089           clock   60.0Hz=0A  1600x9=
00 (0x49)  119.0MHz -HSync +VSync=0A        h: width  1600 start 1696 end 1=
864 total 2128 skew    0 clock   55.9KHz=0A        v: height  900 start  90=
1 end  904 total  932           clock   60.0Hz=0A  1280x1024 (0x4a)  135.0M=
Hz +HSync +VSync=0A        h: width  1280 start 1296 end 1440 total 1688 sk=
ew    0 clock   80.0KHz=0A        v: height 1024 start 1025 end 1028 total =
1066           clock   75.0Hz=0A  1440x900 (0x4b)  136.8MHz -HSync +VSync=
=0A        h: width  1440 start 1536 end 1688 total 1936 skew    0 clock   =
70.6KHz=0A        v: height  900 start  903 end  909 total  942           c=
lock   75.0Hz=0A  1440x900 (0x4c)  106.5MHz -HSync +VSync=0A        h: widt=
h  1440 start 1520 end 1672 total 1904 skew    0 clock   55.9KHz=0A        =
v: height  900 start  903 end  909 total  934           clock   59.9Hz=0A  =
1280x960 (0x4d)  129.9MHz -HSync +VSync=0A        h: width  1280 start 1368=
 end 1504 total 1728 skew    0 clock   75.2KHz=0A        v: height  960 sta=
rt  961 end  964 total 1002           clock   75.0Hz=0A  1280x960 (0x4e)  1=
20.9MHz -HSync +VSync=0A        h: width  1280 start 1368 end 1504 total 17=
28 skew    0 clock   70.0KHz=0A        v: height  960 start  961 end  964 t=
otal  999           clock   70.0Hz=0A  1280x960 (0x4f)  108.0MHz +HSync +VS=
ync=0A        h: width  1280 start 1376 end 1488 total 1800 skew    0 clock=
   60.0KHz=0A        v: height  960 start  961 end  964 total 1000         =
  clock   60.0Hz=0A  1366x768 (0x50)   85.9MHz -HSync +VSync=0A        h: w=
idth  1366 start 1439 end 1583 total 1800 skew    0 clock   47.7KHz=0A     =
   v: height  768 start  769 end  772 total  795           clock   60.0Hz=
=0A  1360x768 (0x51)   85.5MHz +HSync +VSync=0A        h: width  1360 start=
 1424 end 1536 total 1792 skew    0 clock   47.7KHz=0A        v: height  76=
8 start  771 end  777 total  795           clock   60.0Hz=0A  1280x800 (0x5=
2)  106.5MHz -HSync +VSync=0A        h: width  1280 start 1360 end 1488 tot=
al 1696 skew    0 clock   62.8KHz=0A        v: height  800 start  803 end  =
809 total  838           clock   74.9Hz=0A  1280x800 (0x53)   83.5MHz +HSyn=
c -VSync=0A        h: width  1280 start 1352 end 1480 total 1680 skew    0 =
clock   49.7KHz=0A        v: height  800 start  803 end  809 total  831    =
       clock   59.8Hz=0A  1152x864 (0x54)  108.0MHz +HSync +VSync=0A       =
 h: width  1152 start 1216 end 1344 total 1600 skew    0 clock   67.5KHz=0A=
        v: height  864 start  865 end  868 total  900           clock   75.=
0Hz=0A  1152x864 (0x55)   96.7MHz -HSync +VSync=0A        h: width  1152 st=
art 1224 end 1344 total 1536 skew    0 clock   63.0KHz=0A        v: height =
 864 start  865 end  868 total  900           clock   70.0Hz=0A  1152x864 (=
0x56)   81.6MHz -HSync +VSync=0A        h: width  1152 start 1216 end 1336 =
total 1520 skew    0 clock   53.7KHz=0A        v: height  864 start  865 en=
d  868 total  895           clock   60.0Hz=0A  1280x768 (0x57)  102.2MHz +H=
Sync -VSync=0A        h: width  1280 start 1360 end 1488 total 1696 skew   =
 0 clock   60.3KHz=0A        v: height  768 start  771 end  778 total  805 =
          clock   74.9Hz=0A  1280x768 (0x58)   79.5MHz -HSync +VSync=0A    =
    h: width  1280 start 1344 end 1472 total 1664 skew    0 clock   47.8KHz=
=0A        v: height  768 start  771 end  778 total  798           clock   =
59.9Hz=0A  1024x768 (0x59)   78.8MHz +HSync +VSync=0A        h: width  1024=
 start 1040 end 1136 total 1312 skew    0 clock   60.1KHz=0A        v: heig=
ht  768 start  769 end  772 total  800           clock   75.1Hz=0A  1024x76=
8 (0x5a)   78.8MHz +HSync +VSync=0A        h: width  1024 start 1040 end 11=
36 total 1312 skew    0 clock   60.0KHz=0A        v: height  768 start  769=
 end  772 total  800           clock   75.0Hz=0A  1024x768 (0x5b)   75.0MHz=
 -HSync -VSync=0A        h: width  1024 start 1048 end 1184 total 1328 skew=
    0 clock   56.5KHz=0A        v: height  768 start  771 end  777 total  8=
06           clock   70.1Hz=0A  1024x768 (0x5c)   65.0MHz -HSync -VSync=0A =
       h: width  1024 start 1048 end 1184 total 1344 skew    0 clock   48.4=
KHz=0A        v: height  768 start  771 end  777 total  806           clock=
   60.0Hz=0A  1024x576 (0x5d)   47.0MHz -HSync +VSync=0A        h: width  1=
024 start 1064 end 1168 total 1312 skew    0 clock   35.8KHz=0A        v: h=
eight  576 start  577 end  580 total  597           clock   60.0Hz=0A  832x=
624 (0x5e)   57.3MHz -HSync -VSync=0A        h: width   832 start  864 end =
 928 total 1152 skew    0 clock   49.7KHz=0A        v: height  624 start  6=
25 end  628 total  667           clock   74.6Hz=0A  800x600 (0x5f)   50.0MH=
z +HSync +VSync=0A        h: width   800 start  856 end  976 total 1040 ske=
w    0 clock   48.1KHz=0A        v: height  600 start  637 end  643 total  =
666           clock   72.2Hz=0A  800x600 (0x60)   49.5MHz +HSync +VSync=0A =
       h: width   800 start  816 end  896 total 1056 skew    0 clock   46.9=
KHz=0A        v: height  600 start  601 end  604 total  625           clock=
   75.0Hz=0A  800x600 (0x61)   40.0MHz +HSync +VSync=0A        h: width   8=
00 start  840 end  968 total 1056 skew    0 clock   37.9KHz=0A        v: he=
ight  600 start  601 end  605 total  628           clock   60.3Hz=0A  800x6=
00 (0x62)   36.0MHz +HSync +VSync=0A        h: width   800 start  824 end  =
896 total 1024 skew    0 clock   35.2KHz=0A        v: height  600 start  60=
1 end  603 total  625           clock   56.2Hz=0A  848x480 (0x63)   33.8MHz=
 +HSync +VSync=0A        h: width   848 start  864 end  976 total 1088 skew=
    0 clock   31.0KHz=0A        v: height  480 start  486 end  494 total  5=
17           clock   60.0Hz=0A  640x480 (0x64)   31.5MHz -HSync -VSync=0A  =
      h: width   640 start  656 end  720 total  840 skew    0 clock   37.5K=
Hz=0A        v: height  480 start  481 end  484 total  500           clock =
  75.0Hz=0A  640x480 (0x65)   31.5MHz -HSync -VSync=0A        h: width   64=
0 start  664 end  704 total  832 skew    0 clock   37.9KHz=0A        v: hei=
ght  480 start  489 end  492 total  520           clock   72.8Hz=0A  640x48=
0 (0x66)   31.5MHz -HSync -VSync=0A        h: width   640 start  664 end  7=
04 total  832 skew    0 clock   37.9KHz=0A        v: height  480 start  489=
 end  491 total  520           clock   72.8Hz=0A  640x480 (0x67)   30.2MHz =
-HSync -VSync=0A        h: width   640 start  704 end  768 total  864 skew =
   0 clock   35.0KHz=0A        v: height  480 start  483 end  486 total  52=
5           clock   66.7Hz=0A  640x480 (0x68)   25.2MHz -HSync -VSync=0A   =
     h: width   640 start  656 end  752 total  800 skew    0 clock   31.5KH=
z=0A        v: height  480 start  490 end  492 total  525           clock  =
 60.0Hz=0A  640x480 (0x69)   25.2MHz -HSync -VSync=0A        h: width   640=
 start  656 end  752 total  800 skew    0 clock   31.5KHz=0A        v: heig=
ht  480 start  489 end  492 total  525           clock   59.9Hz=0A  720x400=
 (0x6a)   28.3MHz -HSync +VSync=0A        h: width   720 start  738 end  84=
6 total  900 skew    0 clock   31.5KHz=0A        v: height  400 start  412 =
end  414 total  449           clock   70.1Hz=0A
--17pEHd4RhPHOinZp--
