Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0CUXFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:05:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab0CUXFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:05:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: Resume problem with radeon+KMS (2.6.34-rc2 and before)
Date: Mon, 22 Mar 2010 00:07:44 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?iso-8859-1?q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>
References: <201003212228.13923.rjw@sisk.pl> <21d7e9971003211536p78792320rf93f9ba5db6c54ff@mail.gmail.com>
In-Reply-To: <21d7e9971003211536p78792320rf93f9ba5db6c54ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003220007.44981.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 March 2010, Dave Airlie wrote:
> 2010/3/22 Rafael J. Wysocki <rjw@sisk.pl>:
> > Hi,
> >
> > Some time ago I reported a problem with resuming from suspend to RAM on
> > HP nx6325 with radeon+KMS.
> 
> Can you post the X.org log file? if you are really using 6.12.4 and
> not a backport
> then the userspace driver has no KMS support and it is trashing the system.

Appended below.

Rafael


X.Org X Server 1.6.5
Release Date: 2009-10-11
X Protocol Version 11, Revision 0
Build Operating System: openSUSE SUSE LINUX
Current Operating System: Linux ferrari 2.6.34-rc2-rjw #2 SMP PREEMPT Sun Mar 21 15:27:27 CET 2010 x86_64
Build Date: 02 November 2009  12:04:43PM
 
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sun Mar 21 22:32:50 2010
(==) Using config file: "/etc/X11/xorg.conf"
(==) ServerLayout "Layout[all]"
(**) |-->Screen "Screen[0]" (0)
(**) |   |-->Monitor "Monitor[0]"
(**) |   |-->Device "Device[0]"
(**) |-->Input Device "Keyboard[0]"
(**) |-->Input Device "Mouse[1]"
(**) Option "ZapWarning" "on"
(**) Option "AllowMouseOpenFail" "on"
(**) Option "Xinerama" "off"
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/local" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/PEX" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/misc" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/100dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin2/Type1" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/latin7/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/baekmuk" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/japanese" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/kwintv" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/uni" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/CID" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/ucs/misc" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/ucs/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/ucs/100dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/misc" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/75dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/100dpi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/hellas/Type1" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/misc/sgi" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/xtest" does not exist.
	Entry deleted from font path.
(WW) The directory "/opt/kde3/share/fonts" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/TTF/" does not exist.
	Entry deleted from font path.
(WW) The directory "/usr/share/fonts/OTF" does not exist.
	Entry deleted from font path.
(**) FontPath set to:
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/75dpi:unscaled,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/Type1,
	/usr/share/fonts/URW,
	/usr/share/fonts/Speedo,
	/usr/share/fonts/cyrillic,
	/usr/share/fonts/truetype,
	/usr/share/fonts/misc:unscaled,
	/usr/share/fonts/truetype/,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi:unscaled,
	/usr/share/fonts/75dpi:unscaled
(**) Input device list set to "/dev/gpmdata,/dev/input/mice"
(==) ModulePath set to "/usr/lib64/xorg/modules/updates,/usr/lib64/xorg/modules"
(WW) AllowEmptyInput is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
(WW) Disabling Keyboard[0]
(WW) Disabling Mouse[1]
(II) Loader magic: 0xcc0
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 5.0
	X.Org XInput driver : 4.0
	X.Org Server Extension : 2.0
(II) Loader running on linux
(++) using VT number 7

(--) PCI:*(0:1:5:0) 1002:9612:1025:029e rev 0, Mem @ 0xa0000000/268435456, 0x9fdf0000/65536, 0x9fe00000/1048576, I/O @ 0x00009000/256
(II) Open ACPI successful (/var/run/acpid.socket)
(II) System resource ranges:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[21] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[22] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[23] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[24] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[25] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[26] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[27] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[28] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[29] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) "extmod" will be loaded. This was enabled by default and also specified in the config file.
(II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
(II) "glx" will be loaded. This was enabled by default and also specified in the config file.
(II) "record" will be loaded by default.
(II) "dri" will be loaded. This was enabled by default and also specified in the config file.
(II) "dri2" will be loaded by default.
(II) LoadModule: "dbe"
(II) Loading /usr/lib64/xorg/modules//extensions/libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib64/xorg/modules//extensions/libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "dri"
(II) Loading /usr/lib64/xorg/modules//extensions/libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "extmod"
(II) Loading /usr/lib64/xorg/modules//extensions/libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "record"
(II) Loading /usr/lib64/xorg/modules//extensions/librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dri2"
(II) Loading /usr/lib64/xorg/modules//extensions/libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.1.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(II) LoadModule: "radeon"
(II) Loading /usr/lib64/xorg/modules//drivers/radeon_drv.so
(II) Module radeon: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 6.12.4
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON: Driver for ATI Radeon chipsets:
	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
	ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
	ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
	ATI Radeon 8500 AIW BB (AGP), ATI Radeon 8500 AIW BC (AGP),
	ATI Radeon IGP320M (U1) 4336, ATI Radeon IGP330M/340M/350M (U2) 4337,
	ATI Radeon Mobility 7000 IGP 4437, ATI Radeon 9000/PRO If (AGP/PCI),
	ATI Radeon 9000 Ig (AGP/PCI), ATI Radeon X800 (R420) JH (AGP),
	ATI Radeon X800PRO (R420) JI (AGP),
	ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
	ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
	ATI Radeon Mobility 9800 (M18) JN (AGP),
	ATI Radeon X800 SE (R420) (AGP), ATI Radeon X800XT (R420) JP (AGP),
	ATI Radeon X800 VE (R420) JT (AGP), ATI Radeon X850 (R480) (AGP),
	ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
	ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP),
	ATI Radeon Mobility M7 LW (AGP),
	ATI Mobility FireGL 7800 M7 LX (AGP),
	ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
	ATI FireGL Mobility 9000 (M9) Ld (AGP),
	ATI Radeon Mobility 9000 (M9) Lf (AGP),
	ATI Radeon Mobility 9000 (M9) Lg (AGP), ATI Radeon 9700 Pro ND (AGP),
	ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
	ATI FireGL X1 NG (AGP), ATI Radeon 9800PRO NH (AGP),
	ATI Radeon 9800 NI (AGP), ATI FireGL X2 NK (AGP),
	ATI Radeon 9800XT NJ (AGP),
	ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
	ATI Radeon Mobility 9600 (M10) NQ (AGP),
	ATI Radeon Mobility 9600 (M11) NR (AGP),
	ATI Radeon Mobility 9600 (M10) NS (AGP),
	ATI FireGL Mobility T2 (M10) NT (AGP),
	ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon QD (AGP),
	ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
	ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
	ATI Radeon 9100 QM (AGP), ATI Radeon 7500 QW (AGP/PCI),
	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon VE/7000 QY (AGP/PCI),
	ATI Radeon VE/7000 QZ (AGP/PCI), ATI ES1000 515E (PCI),
	ATI Radeon Mobility X300 (M22) 5460 (PCIE),
	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon X800 (R423) UH (PCIE),
	ATI Radeon X800PRO (R423) UI (PCIE),
	ATI Radeon X800LE (R423) UJ (PCIE),
	ATI Radeon X800SE (R423) UK (PCIE),
	ATI Radeon X800 XTP (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
	ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 (R430) (PCIE),
	ATI FireGL V7100 (R423) (PCIE), ATI FireGL V5100 (R423) UQ (PCIE),
	ATI FireGL unknown (R423) UR (PCIE),
	ATI FireGL unknown (R423) UT (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility Radeon X700 XL (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Radeon X550XTX 5657 (PCIE), ATI Radeon 9100 IGP (A5) 5834,
	ATI Radeon Mobility 9100 IGP (U3) 5835,
	ATI Radeon XPRESS 200 5954 (PCIE),
	ATI Radeon XPRESS 200M 5955 (PCIE), ATI Radeon 9250 5960 (AGP),
	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
	ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
	ATI ES1000 5969 (PCI), ATI Radeon XPRESS 200 5974 (PCIE),
	ATI Radeon XPRESS 200M 5975 (PCIE),
	ATI Radeon XPRESS 200 5A41 (PCIE),
	ATI Radeon XPRESS 200M 5A42 (PCIE),
	ATI Radeon XPRESS 200 5A61 (PCIE),
	ATI Radeon XPRESS 200M 5A62 (PCIE),
	ATI Radeon X300 (RV370) 5B60 (PCIE),
	ATI Radeon X600 (RV370) 5B62 (PCIE),
	ATI Radeon X550 (RV370) 5B63 (PCIE),
	ATI FireGL V3100 (RV370) 5B64 (PCIE),
	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
	ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP),
	ATI Mobility Radeon X800 XT (M28) (PCIE),
	ATI Mobility FireGL V5100 (M28) (PCIE),
	ATI Mobility Radeon X800 (M28) (PCIE), ATI Radeon X850 5D4C (PCIE),
	ATI Radeon X850 XT PE (R480) (PCIE),
	ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
	ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
	ATI Radeon X850 XT (R480) (PCIE),
	ATI Radeon X800XT (R423) 5D57 (PCIE),
	ATI FireGL V5000 (RV410) (PCIE), ATI Radeon X700 XT (RV410) (PCIE),
	ATI Radeon X700 PRO (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X1800,
	ATI Mobility Radeon X1800 XT, ATI Mobility Radeon X1800,
	ATI Mobility FireGL V7200, ATI FireGL V7200, ATI FireGL V5300,
	ATI Mobility FireGL V7100, ATI Radeon X1800, ATI Radeon X1800,
	ATI Radeon X1800, ATI Radeon X1800, ATI Radeon X1800,
	ATI FireGL V7300, ATI FireGL V7350, ATI Radeon X1600, ATI RV505,
	ATI Radeon X1300/X1550, ATI Radeon X1550, ATI M54-GL,
	ATI Mobility Radeon X1400, ATI Radeon X1300/X1550,
	ATI Radeon X1550 64-bit, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Radeon X1300, ATI Radeon X1300,
	ATI RV505, ATI RV505, ATI FireGL V3300, ATI FireGL V3350,
	ATI Radeon X1300, ATI Radeon X1550 64-bit, ATI Radeon X1300/X1550,
	ATI Radeon X1600, ATI Radeon X1300/X1550, ATI Mobility Radeon X1450,
	ATI Radeon X1300/X1550, ATI Mobility Radeon X2300,
	ATI Mobility Radeon X2300, ATI Mobility Radeon X1350,
	ATI Mobility Radeon X1350, ATI Mobility Radeon X1450,
	ATI Radeon X1300, ATI Radeon X1550, ATI Mobility Radeon X1350,
	ATI FireMV 2250, ATI Radeon X1550 64-bit, ATI Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1600, ATI Radeon X1600,
	ATI Mobility FireGL V5200, ATI Mobility Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1650, ATI Radeon X1600,
	ATI Radeon X1300 XT/X1600 Pro, ATI FireGL V3400,
	ATI Mobility FireGL V5250, ATI Mobility Radeon X1700,
	ATI Mobility Radeon X1700 XT, ATI FireGL V5200,
	ATI Mobility Radeon X1700, ATI Radeon X2300HD,
	ATI Mobility Radeon HD 2300, ATI Mobility Radeon HD 2300,
	ATI Radeon X1950, ATI Radeon X1900, ATI Radeon X1950,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI AMD Stream Processor, ATI Radeon X1900, ATI Radeon X1950,
	ATI RV560, ATI RV560, ATI Mobility Radeon X1900, ATI RV560,
	ATI Radeon X1950 GT, ATI RV570, ATI RV570, ATI FireGL V7400,
	ATI RV560, ATI Radeon X1650, ATI Radeon X1650, ATI RV560,
	ATI Radeon 9100 PRO IGP 7834, ATI Radeon Mobility 9200 IGP 7835,
	ATI Radeon X1200, ATI Radeon X1200, ATI Radeon X1200,
	ATI Radeon X1200, ATI Radeon X1200, ATI RS740, ATI RS740M, ATI RS740,
	ATI RS740M, ATI Radeon HD 2900 XT, ATI Radeon HD 2900 XT,
	ATI Radeon HD 2900 XT, ATI Radeon HD 2900 Pro, ATI Radeon HD 2900 GT,
	ATI FireGL V8650, ATI FireGL V8600, ATI FireGL V7600,
	ATI Radeon 4800 Series, ATI Radeon HD 4870 x2,
	ATI Radeon 4800 Series, ATI Radeon HD 4850 x2,
	ATI FirePro V8750 (FireGL), ATI FirePro V7760 (FireGL),
	ATI Mobility RADEON HD 4850, ATI Mobility RADEON HD 4850 X2,
	ATI Radeon 4800 Series, ATI FirePro RV770, AMD FireStream 9270,
	AMD FireStream 9250, ATI FirePro V8700 (FireGL),
	ATI Mobility RADEON HD 4870, ATI Mobility RADEON M98,
	ATI Radeon 4800 Series, ATI Radeon 4800 Series, ATI FirePro M7750,
	ATI M98, ATI M98, ATI M98, ATI Mobility Radeon HD 4650,
	ATI Radeon RV730 (AGP), ATI Mobility Radeon HD 4670,
	ATI FirePro M5750, ATI Radeon RV730 (AGP),
	ATI RV730XT [Radeon HD 4670], ATI RADEON E4600,
	ATI Radeon HD 4600 Series, ATI RV730 PRO [Radeon HD 4650],
	ATI FirePro V7750 (FireGL), ATI FirePro V5700 (FireGL),
	ATI FirePro V3750 (FireGL), ATI Mobility Radeon HD 4830,
	ATI Mobility Radeon HD 4850, ATI FirePro M7740, ATI RV740,
	ATI Radeon HD 4770, ATI Radeon HD 4700 Series, ATI Radeon HD 4770,
	ATI FirePro M5750, ATI RV610, ATI Radeon HD 2400 XT,
	ATI Radeon HD 2400 Pro, ATI Radeon HD 2400 PRO AGP, ATI FireGL V4000,
	ATI RV610, ATI Radeon HD 2350, ATI Mobility Radeon HD 2400 XT,
	ATI Mobility Radeon HD 2400, ATI RADEON E2400, ATI RV610,
	ATI FireMV 2260, ATI RV670, ATI Radeon HD3870,
	ATI Mobility Radeon HD 3850, ATI Radeon HD3850,
	ATI Mobility Radeon HD 3850 X2, ATI RV670,
	ATI Mobility Radeon HD 3870, ATI Mobility Radeon HD 3870 X2,
	ATI Radeon HD3870 X2, ATI FireGL V7700, ATI Radeon HD3850,
	ATI Radeon HD3690, AMD Firestream 9170, ATI Radeon HD 4550,
	ATI Radeon RV710, ATI Radeon RV710, ATI Radeon HD 4350,
	ATI Mobility Radeon 4300 Series, ATI Mobility Radeon 4500 Series,
	ATI Mobility Radeon 4500 Series, ATI FirePro RG220, ATI RV630,
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
	ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
	ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
	ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
	ATI FireGL V3600, ATI Radeon HD 2600 LE,
	ATI Mobility FireGL Graphics Processor, ATI Radeon RV710,
	ATI Radeon HD 3470, ATI Mobility Radeon HD 3430,
	ATI Mobility Radeon HD 3400 Series, ATI Radeon HD 3450,
	ATI Radeon HD 3450, ATI Radeon HD 3430, ATI Radeon HD 3450,
	ATI FirePro V3700, ATI FireMV 2450, ATI FireMV 2260, ATI FireMV 2260,
	ATI Radeon HD 3600 Series, ATI Radeon HD 3650 AGP,
	ATI Radeon HD 3600 PRO, ATI Radeon HD 3600 XT,
	ATI Radeon HD 3600 PRO, ATI Mobility Radeon HD 3650,
	ATI Mobility Radeon HD 3670, ATI Mobility FireGL V5700,
	ATI Mobility FireGL V5725, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3100 Graphics, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3100 Graphics, ATI Radeon HD 3300 Graphics,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3000 Graphics,
	ATI Radeon HD 4200, ATI Radeon 4100, ATI Mobility Radeon HD 4200,
	ATI Mobility Radeon 4100, ATI RS880
(II) Primary Device is: PCI 01@00:05:0
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[21] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[22] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[23] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[24] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[25] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[26] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[27] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[28] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[29] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) resource ranges after probing:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[21] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[22] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[23] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[24] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[25] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[26] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[27] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[28] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[29] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[30] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[31] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[32] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[33] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[34] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) Setting vga for screen 0.
(II) RADEON(0): TOTO SAYS 000000009fdf0000
(II) RADEON(0): MMIO registers at 0x000000009fdf0000: size 64KB
(II) RADEON(0): PCI bus 1 card 5 func 0
(**) RADEON(0): Depth 24, (--) framebuffer bpp 32
(II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
(==) RADEON(0): Default visual is TrueColor
(II) Loading sub module "vgahw"
(II) LoadModule: "vgahw"
(II) Loading /usr/lib64/xorg/modules//libvgahw.so
(II) Module vgahw: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 0.1.0
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON(0): vgaHWGetIOBase: hwp->IOBase is 0x03b0, hwp->PIOOffset is 0x0000
(==) RADEON(0): RGB weight 888
(II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
(--) RADEON(0): Chipset: "ATI Radeon HD 3200 Graphics" (ChipID = 0x9612)
(--) RADEON(0): Linear framebuffer at 0x00000000a0000000
(II) RADEON(0): PCI card detected
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Loading /usr/lib64/xorg/modules//libint10.so
(II) Module int10: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.0.0
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON(0): initializing int10
(II) RADEON(0): Primary V_BIOS segment is: 0xc000
(II) RADEON(0): ATOM BIOS detected
(II) RADEON(0): ATOM BIOS Rom: 
	SubsystemVendorID: 0x1025 SubsystemID: 0x029e
	IOBaseAddress: 0x9000
	Filename: BR36131.bin 
	BIOS Bootup Message: 
Acer_California RS780MN DDR2 200e/500m                                      

(II) RADEON(0): Framebuffer space used by Firmware (kb): 20
(II) RADEON(0): Start of VRAM area used by Firmware: 0x14ffb000
(II) RADEON(0): AtomBIOS requests 20kB of VRAM scratch space
(II) RADEON(0): AtomBIOS VRAM scratch base: 0x14ffb000
(II) RADEON(0): Cannot get VRAM scratch space. Allocating in main memory instead
(II) RADEON(0): Default Engine Clock: 380000
(II) RADEON(0): Default Memory Clock: 266000
(II) RADEON(0): Maximum Pixel ClockPLL Frequency Output: 1200000
(II) RADEON(0): Minimum Pixel ClockPLL Frequency Output: 0
(II) RADEON(0): Maximum Pixel ClockPLL Frequency Input: 13500
(II) RADEON(0): Minimum Pixel ClockPLL Frequency Input: 1000
(II) RADEON(0): Maximum Pixel Clock: 400000
(II) RADEON(0): Reference Clock: 14320
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 10, (OK)
drmOpenByBusid: Searching for BusID pci:0000:01:05.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 10, (OK)
drmOpenByBusid: drmOpenMinor returns 10
drmOpenByBusid: drmGetBusid reports pci:0000:01:05.0
(EE) RADEON(0): [dri] RADEONDRIGetVersion failed because of a version mismatch.
[dri] radeon kernel module version is 2.1.0 but version 1.17.0 or newer is needed.
[dri] Disabling DRI.
(II) RADEON(0): using shadow framebuffer
(II) Loading sub module "shadow"
(II) LoadModule: "shadow"
(II) Loading /usr/lib64/xorg/modules//libshadow.so
(II) Module shadow: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.1.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(II) RADEON(0): Detected total video RAM=344064K, accessible=262144K (PCI BAR=262144K)
(--) RADEON(0): Mapped VideoRAM: 262144 kByte (128 bit DDR SDRAM)
(II) RADEON(0): Color tiling disabled
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Module "ddc" already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Module "i2c" already built-in
(II) RADEON(0): ref_freq: 1432, min_out_pll: 64800, max_out_pll: 120000, min_in_pll: 100, max_in_pll: 1350, xclk: 40000, sclk: 380.000000, mclk: 266.000000
(II) RADEON(0): PLL parameters: rf=1432 rd=12 min=64800 max=120000; xclk=40000
(WW) RADEON(0): LVDS Info:
XRes: 1366, YRes: 768, DotClock: 65500
HBlank: 40, HOverPlus: 24, HSyncWidth: 16
VBlank: 8, VOverPlus: 2, VSyncWidth: 4
(II) RADEON(0): Output LVDS using monitor section Monitor[0]
(**) RADEON(0): Option "PreferredMode" "1366x768"
(II) RADEON(0): I2C bus "LVDS" initialized.
(II) RADEON(0): Output VGA-0 has no monitor section
(II) RADEON(0): I2C bus "VGA-0" initialized.
(II) RADEON(0): Port0:
  XRANDR name: LVDS
  Connector: LVDS
  LCD1: INTERNAL_KLDSCP_LVTMA
  DDC reg: 0x7e50
(II) RADEON(0): Port1:
  XRANDR name: VGA-0
  Connector: VGA
  CRT1: INTERNAL_KLDSCP_DAC1
  DDC reg: 0x7e40
(II) RADEON(0): I2C device "LVDS:E-EDID segment register" registered at address 0x60.
(II) RADEON(0): I2C device "LVDS:ddc2" registered at address 0xA0.
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
finished output detect: 0
(II) RADEON(0): I2C device "VGA-0:E-EDID segment register" registered at address 0x60.
(II) RADEON(0): I2C device "VGA-0:ddc2" registered at address 0xA0.
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
finished output detect: 1
finished all detect
before xf86InitialConfiguration
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
(II) RADEON(0): EDID vendor "AUO", prod id 8284
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
(II) RADEON(0): Output LVDS connected
(II) RADEON(0): Output VGA-0 disconnected
(II) RADEON(0): Using user preference for initial modes
(II) RADEON(0): Output LVDS using initial mode 1366x768
after xf86InitialConfiguration
(**) RADEON(0): Display dimensions: (264, 211) mm
(WW) RADEON(0): Probed monitor is 260x140 mm, using Displaysize 264x211 mm
(**) RADEON(0): DPI set to (131, 92)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib64/xorg/modules//libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(==) RADEON(0): Using gamma correction (1.0, 1.0, 1.0)
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Module "ramdac" already built-in
(!!) RADEON(0): For information on using the multimedia capabilities
	of this adapter, please see http://gatos.sf.net.
(!!) RADEON(0): MergedFB support has been removed and replaced with xrandr 1.2 support
(--) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[21] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[22] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[23] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[24] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[25] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[26] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[27] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[28] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[29] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[30] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[31] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[32] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[33] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[34] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) RADEON(0): RADEONScreenInit a0000000 0 0
Output DIG0 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): RADEONInitMemoryMap() : 
(II) RADEON(0):   mem_size         : 0x15000000
(II) RADEON(0):   MC_FB_LOCATION   : 0x00cf00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
(II) RADEON(0): Depth moves disabled by default
(II) RADEON(0): Memory manager initialized to (0,0) (3840,8191)
(II) RADEON(0): Reserved area from (0,1200) to (3840,1202)
(II) RADEON(0): Largest offscreen area available: 3840 x 6989
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00cf00c0 0x00cf00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
(==) RADEON(0): Backing store disabled
(WW) RADEON(0): Direct rendering disabled
(EE) RADEON(0): Acceleration initialization failed
(II) RADEON(0): Acceleration disabled
(**) Option "dpms"
(**) RADEON(0): DPMS enabled
(==) RADEON(0): Silken mouse enabled
(II) RADEON(0): Will use 32 kb for hardware cursor 0 at offset 0x0119c000
(II) RADEON(0): Will use 32 kb for hardware cursor 1 at offset 0x011a3000
(II) RADEON(0): Largest offscreen area available: 3840 x 6985
(II) RADEON(0): Textured video requires CP on R5xx/R6xx/R7xx/IGP
Output DIG0 transmitter setup success
Output CRT1 disable success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
Output DIG0 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Mode 1366x768 - 1406 776 10
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00cf00c0 0x00cf00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
freq: 65500000
best_freq: 65500741
best_feedback_div: 494
best_ref_div: 9
best_post_div: 12
(II) RADEON(0): crtc(0) Clock: mode 65500, PLL 65500
(II) RADEON(0): crtc(0) PLL  : refdiv 9, fbdiv 0x1EE(494), pdiv 12
Set CRTC 0 PLL success
Set CRTC Timing success
Set CRTC 0 Overscan success
Not using RMX
scaler 0 setup success
Set CRTC 0 Source success
crtc 0 YUV disable setup success
Output DIG0 transmitter setup success
Output DIG2 encoder setup success
Output DIG2 encoder setup success
Output DIG0 transmitter setup success
Output DIG0 transmitter setup success
Output DIG0 transmitter setup success
Enable CRTC memreq 0 success
Enable CRTC 0 success
Unblank CRTC 0 success
Output CRT1 disable success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
(WW) RADEON(0): Option "monitor-PANEL" is not used
(WW) RADEON(0): Option "PreferredMode" is not used
(--) RandR disabled
(II) Setting vga for screen 0.
(II) Initializing built-in extension Generic Event Extension
(II) Initializing built-in extension SHAPE
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension BIG-REQUESTS
(II) Initializing built-in extension SYNC
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-MISC
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
(II) AIGLX: Screen 0 is not DRI2 capable
(II) AIGLX: Screen 0 is not DRI capable
(II) AIGLX: Loaded and initialized /usr/lib64/dri/swrast_dri.so
(II) GLX: Initialized DRISWRAST GL provider for screen 0
(II) RADEON(0): Setting screen physical size to 264 x 211
(II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-B20D7FC79C7F597315E3E501AEF10E0D866E8E92.xkm
(II) config/hal: Adding input device AT Translated Set 2 keyboard
(II) LoadModule: "evdev"
(II) Loading /usr/lib64/xorg/modules//input/evdev_drv.so
(II) Module evdev: vendor="X.Org Foundation"
	compiled for 1.6.5, module version = 2.2.5
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 4.0
(**) AT Translated Set 2 keyboard: always reports core events
(**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
(II) AT Translated Set 2 keyboard: Found keys
(II) AT Translated Set 2 keyboard: Configuring as keyboard
(II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "evdev"
(**) Option "xkb_layout" "pl"
(II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-E38D9492E8CBFC7C92134A1F77FC259F0C745330.xkm
(II) config/hal: Adding input device ImPS/2 Generic Wheel Mouse
(**) ImPS/2 Generic Wheel Mouse: always reports core events
(**) ImPS/2 Generic Wheel Mouse: Device: "/dev/input/event6"
(II) ImPS/2 Generic Wheel Mouse: Found 3 mouse buttons
(II) ImPS/2 Generic Wheel Mouse: Found x and y relative axes
(II) ImPS/2 Generic Wheel Mouse: Found scroll wheel(s)
(II) ImPS/2 Generic Wheel Mouse: Configuring as mouse
(**) ImPS/2 Generic Wheel Mouse: YAxisMapping: buttons 4 and 5
(**) ImPS/2 Generic Wheel Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "ImPS/2 Generic Wheel Mouse" (type: MOUSE)
(**) ImPS/2 Generic Wheel Mouse: (accel) keeping acceleration scheme 1
(**) ImPS/2 Generic Wheel Mouse: (accel) filter chain progression: 2.00
(**) ImPS/2 Generic Wheel Mouse: (accel) filter stage 0: 20.00 ms
(**) ImPS/2 Generic Wheel Mouse: (accel) set acceleration profile 0
(II) ImPS/2 Generic Wheel Mouse: initialized for relative axes.
(II) config/hal: Adding input device Sleep Button
(**) Sleep Button: always reports core events
(**) Sleep Button: Device: "/dev/input/event1"
(II) Sleep Button: Found keys
(II) Sleep Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "evdev"
(**) Option "xkb_layout" "pl"
(II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-E38D9492E8CBFC7C92134A1F77FC259F0C745330.xkm
(II) config/hal: Adding input device Power Button
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event2"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "evdev"
(**) Option "xkb_layout" "pl"
(II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-E38D9492E8CBFC7C92134A1F77FC259F0C745330.xkm
(II) config/hal: Adding input device Video Bus
(**) Video Bus: always reports core events
(**) Video Bus: Device: "/dev/input/event5"
(II) Video Bus: Found keys
(II) Video Bus: Configuring as keyboard
(II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "evdev"
(**) Option "xkb_layout" "pl"
(II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-E38D9492E8CBFC7C92134A1F77FC259F0C745330.xkm
(II) config/hal: Adding input device Power Button
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event4"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "evdev"
(**) Option "xkb_layout" "pl"
(II) XKB: reuse xkmfile /var/lib/xkb/compiled/server-E38D9492E8CBFC7C92134A1F77FC259F0C745330.xkm
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
(II) RADEON(0): EDID vendor "AUO", prod id 8284
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
(II) RADEON(0): EDID vendor "AUO", prod id 8284
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
(II) RADEON(0): EDID vendor "AUO", prod id 8284
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
(II) RADEON(0): EDID vendor "AUO", prod id 8284
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
Output DIG0 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00cf00c0 0x00cf00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x0003ffff
(II) RADEON(0): avivo_restore !
Enable CRTC memreq 0 success
Enable CRTC 0 success
Unblank CRTC 0 success
(II) Open ACPI successful (/var/run/acpid.socket)
Output DIG0 transmitter setup success
Output CRT1 disable success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
Output DIG0 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Mode 1366x768 - 1406 776 10
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00cf00c0 0x00cf00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
freq: 65500000
best_freq: 65500741
best_feedback_div: 494
best_ref_div: 9
best_post_div: 12
(II) RADEON(0): crtc(0) Clock: mode 65500, PLL 65500
(II) RADEON(0): crtc(0) PLL  : refdiv 9, fbdiv 0x1EE(494), pdiv 12
Set CRTC 0 PLL success
Set CRTC Timing success
Set CRTC 0 Overscan success
Not using RMX
scaler 0 setup success
Set CRTC 0 Source success
crtc 0 YUV disable setup success
Output DIG0 transmitter setup success
Output DIG2 encoder setup success
Output DIG2 encoder setup success
Output DIG0 transmitter setup success
Output DIG0 transmitter setup success
Output DIG0 transmitter setup success
Enable CRTC memreq 0 success
Enable CRTC 0 success
Unblank CRTC 0 success
Output CRT1 disable success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
(II) RADEON(0): EDID vendor "AUO", prod id 8284
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
(II) AT Translated Set 2 keyboard: Device reopened after 1 attempts.
(II) ImPS/2 Generic Wheel Mouse: Device reopened after 1 attempts.
(II) Sleep Button: Device reopened after 1 attempts.
(II) Power Button: Device reopened after 1 attempts.
(II) Video Bus: Device reopened after 1 attempts.
(II) Power Button: Device reopened after 1 attempts.
Output DIG0 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00cf00c0 0x00cf00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x0003ffff
(II) RADEON(0): avivo_restore !
Enable CRTC memreq 0 success
Enable CRTC 0 success
Unblank CRTC 0 success
(II) Open ACPI successful (/var/run/acpid.socket)
Output DIG0 transmitter setup success
Output CRT1 disable success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
Output DIG0 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Mode 1366x768 - 1406 776 10
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00cf00c0 0x00cf00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
freq: 65500000
best_freq: 65500741
best_feedback_div: 494
best_ref_div: 9
best_post_div: 12
(II) RADEON(0): crtc(0) Clock: mode 65500, PLL 65500
(II) RADEON(0): crtc(0) PLL  : refdiv 9, fbdiv 0x1EE(494), pdiv 12
Set CRTC 0 PLL success
Set CRTC Timing success
Set CRTC 0 Overscan success
Not using RMX
scaler 0 setup success
Set CRTC 0 Source success
crtc 0 YUV disable setup success
Output DIG0 transmitter setup success
Output DIG2 encoder setup success
Output DIG2 encoder setup success
Output DIG0 transmitter setup success
Output DIG0 transmitter setup success
Output DIG0 transmitter setup success
Enable CRTC memreq 0 success
Enable CRTC 0 success
Unblank CRTC 0 success
Output CRT1 disable success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): EDID vendor "AUO", prod id 8284
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1366x768"x0.0   65.50  1366 1390 1406 1406  768 770 774 776 -hsync -vsync (46.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: AUO  Model: 205c  Serial#: 0
(II) RADEON(0): Year: 2008  Week: 1
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 26  vert.: 14
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.584 redY: 0.333   greenX: 0.338 greenY: 0.571
(II) RADEON(0): blueX: 0.158 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 65.5 MHz   Image Size:  256 x 144 mm
(II) RADEON(0): h_active: 1366  h_sync: 1390  h_sync_end 1406 h_blank_end 1406 h_border: 0
(II) RADEON(0): v_active: 768  v_sync: 770  v_sync_end 774 v_blanking: 776 v_border: 0
(WW) RADEON(0): Unknown vendor-specific block f
(II) RADEON(0):  AUO
(II) RADEON(0):  B116XW02 V0
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0006af5c2000000000
(II) RADEON(0): 	01120103801a0e780a99859555569228
(II) RADEON(0): 	22505400000001010101010101010101
(II) RADEON(0): 	01010101010196195628500008301810
(II) RADEON(0): 	24000090100000180000000f00000000
(II) RADEON(0): 	00000000000000000020000000fe0041
(II) RADEON(0): 	554f0a202020202020202020000000fe
(II) RADEON(0): 	004231313658573032205630200a00f8
(II) RADEON(0): EDID vendor "AUO", prod id 8284
Dac detection success
(II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
(II) AT Translated Set 2 keyboard: Device reopened after 1 attempts.
(II) ImPS/2 Generic Wheel Mouse: Device reopened after 1 attempts.
(II) Sleep Button: Device reopened after 1 attempts.
(II) Power Button: Device reopened after 1 attempts.
(II) Video Bus: Device reopened after 1 attempts.
(II) Power Button: Device reopened after 1 attempts.
