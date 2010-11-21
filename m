Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0KUWiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 17:38:06 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:56637 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab0KUWiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 17:38:04 -0500
Message-ID: <4CE99F43.3050903@gmail.com>
Date: Sun, 21 Nov 2010 23:37:55 +0100
From: Vincent Vanackere <vincent.vanackere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [i915] 2.6.37-rc1 G33 regression : no DVI output
References: <AANLkTinEbBirwkREAVaaB4gH0w44tem0ik9nPU5-6aNJ@mail.gmail.com> <c6d829$pk1i4l@fmsmga001.fm.intel.com> <4CE95893.8040008@gmail.com> <b9dded$h5cocn@orsmga002.jf.intel.com>
In-Reply-To: <b9dded$h5cocn@orsmga002.jf.intel.com>
Content-Type: multipart/mixed;
 boundary="------------050808010908070007060203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808010908070007060203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/2010 09:32 PM, Chris Wilson wrote:
> It found the SDVO DVI-D device, successfully queried its modelines, and
> attached it to a crtc and framebuffer... In all appearances it should be
> working. Can you attach the Xorg.log and xrandr output?
> -Chris
>

Here are the Xorg.log and xrandr output with the same kernel.

Vincent

--------------050808010908070007060203
Content-Type: text/x-log;
 name="Xorg.0.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Xorg.0.log"

[    15.844] 
X.Org X Server 1.9.0.902 (1.9.1 RC 2)
Release Date: 2010-10-15
[    15.844] X Protocol Version 11, Revision 0
[    15.844] Build Operating System: Linux 2.6.24-27-server x86_64 Ubuntu
[    15.844] Current Operating System: Linux marvin 2.6.37-rc2-custom+ #1 SMP Sun Nov 21 18:21:43 CET 2010 x86_64
[    15.844] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.37-rc2-custom+ root=UUID=bab2f734-5563-4c1a-84ff-06562667f32e ro quiet splash security=selinux selinux=1
[    15.844] Build Date: 08 November 2010  08:08:39PM
[    15.844] xorg-server 2:1.9.0.902-1ubuntu1 (For technical support please see http://www.ubuntu.com/support) 
[    15.844] Current version of pixman: 0.18.4
[    15.844] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    15.844] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    15.844] (==) Log file: "/var/log/Xorg.0.log", Time: Sun Nov 21 23:17:30 2010
[    15.844] (==) Using config file: "/etc/X11/xorg.conf"
[    15.844] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    15.844] (==) ServerLayout "Default Layout"
[    15.844] (**) |-->Screen "Default Screen" (0)
[    15.844] (**) |   |-->Monitor "Configured Monitor"
[    15.844] (**) |   |-->Device "Configured Video Device"
[    15.844] (==) Automatically adding devices
[    15.845] (==) Automatically enabling devices
[    15.845] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
[    15.845] 	Entry deleted from font path.
[    15.845] (==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    15.845] (==) ModulePath set to "/usr/lib/xorg/extra-modules,/usr/lib/xorg/modules"
[    15.845] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    15.845] (II) Loader magic: 0x7d8200
[    15.845] (II) Module ABI versions:
[    15.845] 	X.Org ANSI C Emulation: 0.4
[    15.845] 	X.Org Video Driver: 8.0
[    15.845] 	X.Org XInput driver : 11.0
[    15.845] 	X.Org Server Extension : 4.0
[    15.845] (--) PCI:*(0:0:2:0) 8086:29c2:1458:d000 rev 2, Mem @ 0xf2200000/524288, 0xe0000000/268435456, 0xf2100000/1048576, I/O @ 0x0000e200/8
[    15.845] (--) PCI: (0:0:2:1) 8086:29c3:1458:d000 rev 2, Mem @ 0xf2280000/524288
[    15.845] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
[    15.845] (II) LoadModule: "extmod"
[    15.849] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    15.849] (II) Module extmod: vendor="X.Org Foundation"
[    15.849] 	compiled for 1.9.0.902, module version = 1.0.0
[    15.849] 	Module class: X.Org Server Extension
[    15.849] 	ABI class: X.Org Server Extension, version 4.0
[    15.849] (II) Loading extension MIT-SCREEN-SAVER
[    15.849] (II) Loading extension XFree86-VidModeExtension
[    15.849] (II) Loading extension XFree86-DGA
[    15.849] (II) Loading extension DPMS
[    15.849] (II) Loading extension XVideo
[    15.849] (II) Loading extension XVideo-MotionCompensation
[    15.849] (II) Loading extension X-Resource
[    15.849] (II) LoadModule: "dbe"
[    15.849] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    15.849] (II) Module dbe: vendor="X.Org Foundation"
[    15.849] 	compiled for 1.9.0.902, module version = 1.0.0
[    15.849] 	Module class: X.Org Server Extension
[    15.849] 	ABI class: X.Org Server Extension, version 4.0
[    15.849] (II) Loading extension DOUBLE-BUFFER
[    15.849] (II) LoadModule: "glx"
[    15.849] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    15.849] (II) Module glx: vendor="X.Org Foundation"
[    15.849] 	compiled for 1.9.0.902, module version = 1.0.0
[    15.849] 	ABI class: X.Org Server Extension, version 4.0
[    15.849] (==) AIGLX enabled
[    15.849] (II) Loading extension GLX
[    15.849] (II) LoadModule: "record"
[    15.850] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    15.850] (II) Module record: vendor="X.Org Foundation"
[    15.850] 	compiled for 1.9.0.902, module version = 1.13.0
[    15.850] 	Module class: X.Org Server Extension
[    15.850] 	ABI class: X.Org Server Extension, version 4.0
[    15.850] (II) Loading extension RECORD
[    15.850] (II) LoadModule: "dri"
[    15.850] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    15.850] (II) Module dri: vendor="X.Org Foundation"
[    15.850] 	compiled for 1.9.0.902, module version = 1.0.0
[    15.850] 	ABI class: X.Org Server Extension, version 4.0
[    15.850] (II) Loading extension XFree86-DRI
[    15.850] (II) LoadModule: "dri2"
[    15.850] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    15.850] (II) Module dri2: vendor="X.Org Foundation"
[    15.850] 	compiled for 1.9.0.902, module version = 1.2.0
[    15.850] 	ABI class: X.Org Server Extension, version 4.0
[    15.850] (II) Loading extension DRI2
[    15.850] (II) LoadModule: "intel"
[    15.850] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    15.851] (II) Module intel: vendor="X.Org Foundation"
[    15.851] 	compiled for 1.9.0.902, module version = 2.13.0
[    15.851] 	Module class: X.Org Video Driver
[    15.851] 	ABI class: X.Org Video Driver, version 8.0
[    15.851] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge, Sandybridge, Sandybridge, Sandybridge, Sandybridge,
	Sandybridge, Sandybridge
[    15.851] (++) using VT number 7

[    15.852] drmOpenDevice: node name is /dev/dri/card0
[    15.852] drmOpenDevice: open result is 8, (OK)
[    15.852] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    15.852] drmOpenDevice: node name is /dev/dri/card0
[    15.852] drmOpenDevice: open result is 8, (OK)
[    15.852] drmOpenByBusid: drmOpenMinor returns 8
[    15.852] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    15.852] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen" for depth/fbbpp 24/32
[    15.852] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    15.852] (==) intel(0): RGB weight 888
[    15.852] (==) intel(0): Default visual is TrueColor
[    15.853] (**) intel(0): Option "AccelMethod" "UXA"
[    15.853] (II) intel(0): Integrated Graphics Chipset: Intel(R) G33
[    15.853] (--) intel(0): Chipset: "G33"
[    15.853] (**) intel(0): Tiling enabled
[    15.853] (**) intel(0): SwapBuffers wait enabled
[    15.853] (==) intel(0): video overlay key set to 0x101fe
[    15.890] (II) intel(0): Output VGA1 using monitor section Configured Monitor
[    16.123] (II) intel(0): Output DVI1 has no monitor section
[    16.160] (II) intel(0): EDID for output VGA1
[    16.393] (II) intel(0): EDID for output DVI1
[    16.393] (II) intel(0): Manufacturer: IVM  Model: 5601  Serial#: 11471
[    16.393] (II) intel(0): Year: 2007  Week: 30
[    16.393] (II) intel(0): EDID Version: 1.3
[    16.393] (II) intel(0): Digital Display Input
[    16.393] (II) intel(0): Max Image Size [cm]: horiz.: 52  vert.: 33
[    16.393] (II) intel(0): Gamma: 2.20
[    16.393] (II) intel(0): DPMS capabilities: StandBy Suspend Off
[    16.393] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    16.393] (II) intel(0): First detailed timing is preferred mode
[    16.393] (II) intel(0): redX: 0.653 redY: 0.337   greenX: 0.295 greenY: 0.607
[    16.393] (II) intel(0): blueX: 0.144 blueY: 0.075   whiteX: 0.313 whiteY: 0.329
[    16.393] (II) intel(0): Supported established timings:
[    16.393] (II) intel(0): 720x400@70Hz
[    16.393] (II) intel(0): 640x480@60Hz
[    16.393] (II) intel(0): 640x480@67Hz
[    16.393] (II) intel(0): 640x480@72Hz
[    16.393] (II) intel(0): 640x480@75Hz
[    16.394] (II) intel(0): 800x600@60Hz
[    16.394] (II) intel(0): 800x600@72Hz
[    16.394] (II) intel(0): 800x600@75Hz
[    16.394] (II) intel(0): 832x624@75Hz
[    16.394] (II) intel(0): 1024x768@60Hz
[    16.394] (II) intel(0): 1024x768@70Hz
[    16.394] (II) intel(0): 1024x768@75Hz
[    16.394] (II) intel(0): 1280x1024@75Hz
[    16.394] (II) intel(0): 1152x864@75Hz
[    16.394] (II) intel(0): Manufacturer's mask: 0
[    16.394] (II) intel(0): Supported standard timings:
[    16.394] (II) intel(0): #0: hsize: 1152  vsize 864  refresh: 75  vid: 20337
[    16.394] (II) intel(0): #1: hsize: 1280  vsize 1024  refresh: 76  vid: 36993
[    16.394] (II) intel(0): #2: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    16.394] (II) intel(0): #3: hsize: 1280  vsize 1024  refresh: 72  vid: 35969
[    16.394] (II) intel(0): #4: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[    16.394] (II) intel(0): #5: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[    16.394] (II) intel(0): #6: hsize: 1440  vsize 900  refresh: 75  vid: 3989
[    16.394] (II) intel(0): #7: hsize: 1440  vsize 900  refresh: 60  vid: 149
[    16.394] (II) intel(0): Supported detailed timing:
[    16.394] (II) intel(0): clock: 154.0 MHz   Image Size:  519 x 324 mm
[    16.394] (II) intel(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
[    16.394] (II) intel(0): v_active: 1200  v_sync: 1203  v_sync_end 1209 v_blanking: 1235 v_border: 0
[    16.394] (II) intel(0): Ranges: V min: 56 V max: 76 Hz, H min: 30 H max: 83 kHz, PixClock max 175 MHz
[    16.394] (II) intel(0): Monitor name: PLB2403WS
[    16.394] (II) intel(0): Supported detailed timing:
[    16.394] (II) intel(0): clock: 74.2 MHz   Image Size:  708 x 398 mm
[    16.394] (II) intel(0): h_active: 1280  h_sync: 1390  h_sync_end 1430 h_blank_end 1650 h_border: 0
[    16.394] (II) intel(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[    16.394] (II) intel(0): Supported detailed timing:
[    16.394] (II) intel(0): clock: 74.2 MHz   Image Size:  708 x 398 mm
[    16.394] (II) intel(0): h_active: 1920  h_sync: 2008  h_sync_end 2052 h_blank_end 2200 h_border: 0
[    16.394] (II) intel(0): v_active: 540  v_sync: 542  v_sync_end 547 v_blanking: 562 v_border: 0
[    16.394] (II) intel(0): Supported detailed timing:
[    16.394] (II) intel(0): clock: 27.0 MHz   Image Size:  708 x 398 mm
[    16.394] (II) intel(0): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[    16.394] (II) intel(0): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[    16.394] (II) intel(0): Supported detailed timing:
[    16.394] (II) intel(0): clock: 27.0 MHz   Image Size:  531 x 398 mm
[    16.394] (II) intel(0): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[    16.394] (II) intel(0): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[    16.394] (II) intel(0): Supported detailed timing:
[    16.394] (II) intel(0): clock: 27.0 MHz   Image Size:  708 x 398 mm
[    16.394] (II) intel(0): h_active: 1440  h_sync: 1478  h_sync_end 1602 h_blank_end 1716 h_border: 0
[    16.394] (II) intel(0): v_active: 240  v_sync: 244  v_sync_end 247 v_blanking: 262 v_border: 0
[    16.394] (II) intel(0): Number of EDID sections to follow: 1
[    16.394] (II) intel(0): EDID (in hex):
[    16.394] (II) intel(0): 	00ffffffffffff0026cd0156cf2c0000
[    16.394] (II) intel(0): 	1e11010380342178ea5ad5a7564b9b24
[    16.394] (II) intel(0): 	135054bdef80714f81908180818ca940
[    16.394] (II) intel(0): 	b300950f9500283c80a070b023403020
[    16.394] (II) intel(0): 	360007442100001a0000001000f01600
[    16.394] (II) intel(0): 	267c4300c48e21000098000000fd0038
[    16.394] (II) intel(0): 	4c1e5311000a202020202020000000fc
[    16.394] (II) intel(0): 	00504c423234303357530a20202001ec
[    16.394] (II) intel(0): 	02031cf1490490030185070002066503
[    16.394] (II) intel(0): 	0c0010008301000023090704011d0072
[    16.394] (II) intel(0): 	51d01e206e285500c48e2100001e011d
[    16.394] (II) intel(0): 	8018711c1620582c2500c48e2100009e
[    16.394] (II) intel(0): 	8c0ad08a20e02d10103e9600c48e2100
[    16.394] (II) intel(0): 	00188c0ad08a20e02d10103e9600138e
[    16.394] (II) intel(0): 	210000188c0aa01451f01600267c4300
[    16.394] (II) intel(0): 	c48e2100009800000000000000000084
[    16.394] (II) intel(0): Printing probed modes for output DVI1
[    16.394] (II) intel(0): Modeline "1920x1200"x60.0  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync (74.0 kHz)
[    16.394] (II) intel(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    16.394] (II) intel(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[    16.394] (II) intel(0): Modeline "1280x1024"x76.0  141.81  1280 1376 1512 1744  1024 1025 1028 1070 -hsync +vsync (81.3 kHz)
[    16.394] (II) intel(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    16.394] (II) intel(0): Modeline "1280x1024"x72.0  132.84  1280 1368 1504 1728  1024 1025 1028 1067 -hsync +vsync (76.9 kHz)
[    16.394] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    16.394] (II) intel(0): Modeline "1440x900"x75.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz)
[    16.394] (II) intel(0): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    16.394] (II) intel(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    16.394] (II) intel(0): Modeline "1280x720"x60.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    16.394] (II) intel(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    16.394] (II) intel(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    16.394] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    16.394] (II) intel(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    16.394] (II) intel(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    16.394] (II) intel(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    16.394] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    16.394] (II) intel(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz)
[    16.394] (II) intel(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    16.394] (II) intel(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    16.394] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    16.394] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    16.394] (II) intel(0): Output VGA1 disconnected
[    16.394] (II) intel(0): Output DVI1 connected
[    16.394] (II) intel(0): Using exact sizes for initial modes
[    16.394] (II) intel(0): Output DVI1 using initial mode 1920x1200
[    16.394] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    16.395] (II) intel(0): Kernel page flipping support detected, enabling
[    16.395] (==) intel(0): DPI set to (96, 96)
[    16.395] (II) Loading sub module "fb"
[    16.395] (II) LoadModule: "fb"
[    16.395] (II) Loading /usr/lib/xorg/modules/libfb.so
[    16.395] (II) Module fb: vendor="X.Org Foundation"
[    16.395] 	compiled for 1.9.0.902, module version = 1.0.0
[    16.395] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    16.395] (==) Depth 24 pixmap format is 32 bpp
[    16.395] (==) intel(0): VideoRam: 262144 KB
[    16.395] (II) intel(0): [DRI2] Setup complete
[    16.395] (II) intel(0): [DRI2]   DRI driver: i915
[    16.395] (II) intel(0): Allocated new frame buffer 1920x1200 stride 8192, tiled
[    16.395] (II) UXA(0): Driver registered support for the following operations:
[    16.395] (II)         solid
[    16.395] (II)         copy
[    16.395] (II)         composite (RENDER acceleration)
[    16.395] (II)         put_image
[    16.395] (II)         get_image
[    16.395] (==) intel(0): Backing store disabled
[    16.395] (==) intel(0): Silken mouse enabled
[    16.395] (II) intel(0): Initializing HW Cursor
[    16.412] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    16.412] (==) intel(0): DPMS enabled
[    16.412] (==) intel(0): Intel XvMC decoder disabled
[    16.412] (II) intel(0): Set up textured video
[    16.412] (II) intel(0): Set up overlay video
[    16.412] (II) intel(0): direct rendering: DRI2 Enabled
[    16.413] (--) RandR disabled
[    16.413] (II) Initializing built-in extension Generic Event Extension
[    16.413] (II) Initializing built-in extension SHAPE
[    16.413] (II) Initializing built-in extension MIT-SHM
[    16.413] (II) Initializing built-in extension XInputExtension
[    16.413] (II) Initializing built-in extension XTEST
[    16.413] (II) Initializing built-in extension BIG-REQUESTS
[    16.413] (II) Initializing built-in extension SYNC
[    16.413] (II) Initializing built-in extension XKEYBOARD
[    16.413] (II) Initializing built-in extension XC-MISC
[    16.413] (II) Initializing built-in extension SECURITY
[    16.413] (II) Initializing built-in extension XINERAMA
[    16.413] (II) Initializing built-in extension XFIXES
[    16.413] (II) Initializing built-in extension RENDER
[    16.413] (II) Initializing built-in extension RANDR
[    16.413] (II) Initializing built-in extension COMPOSITE
[    16.413] (II) Initializing built-in extension DAMAGE
[    16.413] (II) Initializing built-in extension GESTURE
[    16.419] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    16.419] (II) AIGLX: enabled GLX_INTEL_swap_event
[    16.419] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    16.419] (II) AIGLX: enabled GLX_SGI_make_current_read
[    16.419] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    16.419] (II) AIGLX: Loaded and initialized /usr/lib/dri/i915_dri.so
[    16.419] (II) GLX: Initialized DRI2 GL provider for screen 0
[    16.419] (II) intel(0): Setting screen physical size to 508 x 317
[    16.433] (II) XKB: reuse xkmfile /var/lib/xkb/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
[    16.440] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[    16.440] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    16.440] (II) LoadModule: "evdev"
[    16.440] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    16.440] (II) Module evdev: vendor="X.Org Foundation"
[    16.440] 	compiled for 1.9.0, module version = 2.3.2
[    16.440] 	Module class: X.Org XInput Driver
[    16.440] 	ABI class: X.Org XInput driver, version 11.0
[    16.440] (**) Power Button: always reports core events
[    16.440] (**) Power Button: Device: "/dev/input/event1"
[    16.490] (II) Power Button: Found keys
[    16.490] (II) Power Button: Configuring as keyboard
[    16.490] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    16.490] (**) Option "xkb_rules" "evdev"
[    16.490] (**) Option "xkb_model" "pc105"
[    16.490] (**) Option "xkb_layout" "fr"
[    16.491] (II) XKB: reuse xkmfile /var/lib/xkb/server-1CA37FD61409D6C1EDB80880DF2DB1A574556A6A.xkm
[    16.494] (II) config/udev: Adding input device Power Button (/dev/input/event0)
[    16.494] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    16.494] (**) Power Button: always reports core events
[    16.494] (**) Power Button: Device: "/dev/input/event0"
[    16.550] (II) Power Button: Found keys
[    16.550] (II) Power Button: Configuring as keyboard
[    16.550] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    16.550] (**) Option "xkb_rules" "evdev"
[    16.550] (**) Option "xkb_model" "pc105"
[    16.550] (**) Option "xkb_layout" "fr"
[    16.551] (II) config/udev: Adding input device A4Tech Wireless Battery Free Optical Mouse (/dev/input/event7)
[    16.551] (**) A4Tech Wireless Battery Free Optical Mouse: Applying InputClass "evdev pointer catchall"
[    16.551] (**) A4Tech Wireless Battery Free Optical Mouse: always reports core events
[    16.551] (**) A4Tech Wireless Battery Free Optical Mouse: Device: "/dev/input/event7"
[    16.551] (II) A4Tech Wireless Battery Free Optical Mouse: Found 12 mouse buttons
[    16.551] (II) A4Tech Wireless Battery Free Optical Mouse: Found scroll wheel(s)
[    16.551] (II) A4Tech Wireless Battery Free Optical Mouse: Found relative axes
[    16.551] (II) A4Tech Wireless Battery Free Optical Mouse: Found x and y relative axes
[    16.551] (II) A4Tech Wireless Battery Free Optical Mouse: Configuring as mouse
[    16.551] (**) A4Tech Wireless Battery Free Optical Mouse: YAxisMapping: buttons 4 and 5
[    16.551] (**) A4Tech Wireless Battery Free Optical Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    16.551] (II) XINPUT: Adding extended input device "A4Tech Wireless Battery Free Optical Mouse" (type: MOUSE)
[    16.551] (II) A4Tech Wireless Battery Free Optical Mouse: initialized for relative axes.
[    16.551] (II) config/udev: Adding input device A4Tech Wireless Battery Free Optical Mouse (/dev/input/mouse0)
[    16.552] (II) No input driver/identifier specified (ignoring)
[    16.553] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event5)
[    16.553] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[    16.553] (**) Logitech USB Receiver: always reports core events
[    16.553] (**) Logitech USB Receiver: Device: "/dev/input/event5"
[    16.553] (II) Logitech USB Receiver: Found keys
[    16.553] (II) Logitech USB Receiver: Configuring as keyboard
[    16.553] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[    16.553] (**) Option "xkb_rules" "evdev"
[    16.553] (**) Option "xkb_model" "pc105"
[    16.553] (**) Option "xkb_layout" "fr"
[    16.553] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event6)
[    16.553] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[    16.553] (**) Logitech USB Receiver: always reports core events
[    16.553] (**) Logitech USB Receiver: Device: "/dev/input/event6"
[    16.570] (II) Logitech USB Receiver: Found keys
[    16.570] (II) Logitech USB Receiver: Configuring as keyboard
[    16.570] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[    16.570] (**) Option "xkb_rules" "evdev"
[    16.570] (**) Option "xkb_model" "pc105"
[    16.570] (**) Option "xkb_layout" "fr"
[    16.570] (II) config/udev: Adding input device Elan USB Audio (/dev/input/event2)
[    16.570] (**) Elan USB Audio: Applying InputClass "evdev keyboard catchall"
[    16.570] (**) Elan USB Audio: always reports core events
[    16.570] (**) Elan USB Audio: Device: "/dev/input/event2"
[    16.570] (II) Elan USB Audio: Found keys
[    16.570] (II) Elan USB Audio: Configuring as keyboard
[    16.570] (II) XINPUT: Adding extended input device "Elan USB Audio" (type: KEYBOARD)
[    16.570] (**) Option "xkb_rules" "evdev"
[    16.570] (**) Option "xkb_model" "pc105"
[    16.570] (**) Option "xkb_layout" "fr"
[    16.571] (II) config/udev: Adding input device HID 0566:3108 (/dev/input/event3)
[    16.571] (**) HID 0566:3108: Applying InputClass "evdev keyboard catchall"
[    16.571] (**) HID 0566:3108: always reports core events
[    16.571] (**) HID 0566:3108: Device: "/dev/input/event3"
[    16.571] (II) HID 0566:3108: Found keys
[    16.571] (II) HID 0566:3108: Configuring as keyboard
[    16.571] (II) XINPUT: Adding extended input device "HID 0566:3108" (type: KEYBOARD)
[    16.571] (**) Option "xkb_rules" "evdev"
[    16.571] (**) Option "xkb_model" "pc105"
[    16.571] (**) Option "xkb_layout" "fr"
[    16.572] (II) config/udev: Adding input device HID 0566:3108 (/dev/input/event4)
[    16.572] (**) HID 0566:3108: Applying InputClass "evdev keyboard catchall"
[    16.572] (**) HID 0566:3108: always reports core events
[    16.572] (**) HID 0566:3108: Device: "/dev/input/event4"
[    16.572] (II) HID 0566:3108: Found 1 mouse buttons
[    16.572] (II) HID 0566:3108: Found scroll wheel(s)
[    16.572] (II) HID 0566:3108: Found relative axes
[    16.572] (II) HID 0566:3108: Found absolute axes
[    16.572] (II) evdev-grail: failed to open grail, no gesture support
[    16.572] (II) HID 0566:3108: Found keys
[    16.572] (II) HID 0566:3108: Configuring as mouse
[    16.572] (II) HID 0566:3108: Configuring as keyboard
[    16.572] (**) HID 0566:3108: YAxisMapping: buttons 4 and 5
[    16.572] (**) HID 0566:3108: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    16.572] (II) XINPUT: Adding extended input device "HID 0566:3108" (type: KEYBOARD)
[    16.572] (**) Option "xkb_rules" "evdev"
[    16.572] (**) Option "xkb_model" "pc105"
[    16.572] (**) Option "xkb_layout" "fr"
[    16.572] (EE) HID 0566:3108: failed to initialize for relative axes.
[    16.572] (II) HID 0566:3108: initialized for absolute axes.
[    16.995] (II) intel(0): EDID vendor "IVM", prod id 22017
[    16.995] (II) intel(0): Using EDID range info for horizontal sync
[    16.995] (II) intel(0): Using EDID range info for vertical refresh
[    16.995] (II) intel(0): Printing DDC gathered Modelines:
[    16.995] (II) intel(0): Modeline "1920x1200"x0.0  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync (74.0 kHz)
[    16.995] (II) intel(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    16.995] (II) intel(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    16.995] (II) intel(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    16.995] (II) intel(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    16.995] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    16.995] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    16.995] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    16.995] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    16.995] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    16.995] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    16.995] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    16.995] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    16.995] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    16.995] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    16.995] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    16.995] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    16.995] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    16.995] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    16.995] (II) intel(0): Modeline "1280x1024"x76.0  141.82  1280 1376 1512 1744  1024 1025 1028 1070 -hsync +vsync (81.3 kHz)
[    16.995] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    16.995] (II) intel(0): Modeline "1280x1024"x72.0  132.75  1280 1368 1504 1728  1024 1025 1028 1067 -hsync +vsync (76.8 kHz)
[    16.995] (II) intel(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    16.995] (II) intel(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    16.995] (II) intel(0): Modeline "1440x900"x0.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz)
[    16.995] (II) intel(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    16.995] (II) intel(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    16.995] (II) intel(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    17.264] (II) intel(0): EDID vendor "IVM", prod id 22017
[    17.265] (II) intel(0): Using hsync ranges from config file
[    17.265] (II) intel(0): Using vrefresh ranges from config file
[    17.265] (II) intel(0): Printing DDC gathered Modelines:
[    17.265] (II) intel(0): Modeline "1920x1200"x0.0  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync (74.0 kHz)
[    17.265] (II) intel(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    17.265] (II) intel(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    17.265] (II) intel(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    17.265] (II) intel(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    17.265] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    17.265] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    17.265] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    17.265] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    17.265] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    17.265] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    17.265] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    17.265] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    17.265] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    17.265] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    17.265] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    17.265] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    17.265] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    17.265] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    17.265] (II) intel(0): Modeline "1280x1024"x76.0  141.82  1280 1376 1512 1744  1024 1025 1028 1070 -hsync +vsync (81.3 kHz)
[    17.265] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    17.265] (II) intel(0): Modeline "1280x1024"x72.0  132.75  1280 1368 1504 1728  1024 1025 1028 1067 -hsync +vsync (76.8 kHz)
[    17.265] (II) intel(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    17.265] (II) intel(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    17.265] (II) intel(0): Modeline "1440x900"x0.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz)
[    17.265] (II) intel(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    17.265] (II) intel(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    17.265] (II) intel(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    17.533] (II) intel(0): EDID vendor "IVM", prod id 22017
[    17.534] (II) intel(0): Using hsync ranges from config file
[    17.534] (II) intel(0): Using vrefresh ranges from config file
[    17.534] (II) intel(0): Printing DDC gathered Modelines:
[    17.534] (II) intel(0): Modeline "1920x1200"x0.0  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync (74.0 kHz)
[    17.534] (II) intel(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    17.534] (II) intel(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    17.534] (II) intel(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    17.534] (II) intel(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    17.534] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    17.534] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    17.534] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    17.534] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    17.534] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    17.534] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    17.534] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    17.534] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    17.534] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    17.534] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    17.534] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    17.534] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    17.534] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    17.534] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    17.534] (II) intel(0): Modeline "1280x1024"x76.0  141.82  1280 1376 1512 1744  1024 1025 1028 1070 -hsync +vsync (81.3 kHz)
[    17.534] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    17.534] (II) intel(0): Modeline "1280x1024"x72.0  132.75  1280 1368 1504 1728  1024 1025 1028 1067 -hsync +vsync (76.8 kHz)
[    17.534] (II) intel(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    17.534] (II) intel(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    17.534] (II) intel(0): Modeline "1440x900"x0.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz)
[    17.534] (II) intel(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    17.534] (II) intel(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    17.534] (II) intel(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    17.803] (II) intel(0): EDID vendor "IVM", prod id 22017
[    17.804] (II) intel(0): Using hsync ranges from config file
[    17.804] (II) intel(0): Using vrefresh ranges from config file
[    17.804] (II) intel(0): Printing DDC gathered Modelines:
[    17.804] (II) intel(0): Modeline "1920x1200"x0.0  154.00  1920 1968 2000 2080  1200 1203 1209 1235 +hsync -vsync (74.0 kHz)
[    17.804] (II) intel(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    17.804] (II) intel(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    17.804] (II) intel(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    17.804] (II) intel(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    17.804] (II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    17.804] (II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    17.804] (II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    17.804] (II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    17.804] (II) intel(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    17.804] (II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    17.804] (II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    17.804] (II) intel(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    17.804] (II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    17.804] (II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    17.804] (II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    17.804] (II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    17.804] (II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    17.804] (II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    17.804] (II) intel(0): Modeline "1280x1024"x76.0  141.82  1280 1376 1512 1744  1024 1025 1028 1070 -hsync +vsync (81.3 kHz)
[    17.804] (II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    17.804] (II) intel(0): Modeline "1280x1024"x72.0  132.75  1280 1368 1504 1728  1024 1025 1028 1067 -hsync +vsync (76.8 kHz)
[    17.804] (II) intel(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    17.804] (II) intel(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    17.804] (II) intel(0): Modeline "1440x900"x0.0  136.75  1440 1536 1688 1936  900 903 909 942 -hsync +vsync (70.6 kHz)
[    17.804] (II) intel(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    17.804] (II) intel(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    17.804] (II) intel(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)

--------------050808010908070007060203
Content-Type: text/x-log;
 name="xrandr.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xrandr.log"

Screen 0: minimum 320 x 200, current 1920 x 1200, maximum 4096 x 4096
VGA1 disconnected (normal left inverted right x axis y axis)
DVI1 connected 1920x1200+0+0 (normal left inverted right x axis y axis) 519mm x 324mm
   1920x1200      60.0*+
   1600x1200      60.0  
   1680x1050      60.0  
   1280x1024      76.0     75.0     72.0     60.0  
   1440x900       75.0     59.9  
   1152x864       75.0  
   1280x720       60.0  
   1024x768       75.1     70.1     60.0  
   832x624        74.6  
   800x600        72.2     75.0     60.3  
   640x480        72.8     75.0     66.7     60.0  
   720x400        70.1  

--------------050808010908070007060203--
