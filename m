Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1IYOHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 10:07:15 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:40857 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1IYOHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 10:07:11 -0400
Date: Sun, 25 Sep 2011 10:07:07 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: radeon KMS (R100) on dell inspiron 5100 blank screen
Message-ID: <20110925140707.GA2932@animx.eu.org>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20110908015105.GA31062@animx.eu.org>
 <20110908020235.GA582@animx.eu.org>
 <CAPM=9tyTYAHGMihPskc6gTtPxdn4PXBuEU93TJnPDX8=9pvE=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <CAPM=9tyTYAHGMihPskc6gTtPxdn4PXBuEU93TJnPDX8=9pvE=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dave Airlie wrote:
> >> Here's the relevent dmesg:
> >>
> >> [drm] radeon defaulting to kernel modesetting.
> >> [drm] radeon kernel modesetting enabled.
> >> [drm] initializing kernel modesetting (RV200 0x1002:0x4C57).
> >> [drm] register mmio base: 0xFCFF0000
> >> [drm] register mmio size: 65536
> >> radeon 0000:01:00.0: Invalid ROM contents
> >> radeon 0000:01:00.0: Invalid ROM contents
> >> [drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM
> 
> ^^ this is  strange on an x86 machine, we should always be able to find a
> BIOS,
> 
> The only thing I can think off is the BIOS is corrupted somehow,
> 
> if you run nomodeset can you get an Xorg.0.log?

X works fine with KMS disabled.  Here is my /etc/modprobe.d/radeon-kms.conf
options radeon modeset=0

I have attached the Xorg.0.log file.  I do not have an xorg.conf file.

Do you think it would help if I reflash the computer's bios?  I checked
Dell's site when I saw the error in dmesg and I have the latest.

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log"
Content-Transfer-Encoding: quoted-printable

[   314.593] _XSERVTransSocketOpenCOTSServer: Unable to open socket for ine=
t6
[   314.593] _XSERVTransOpen: transport open failed for inet6/gonzales:0
[   314.593] _XSERVTransMakeAllCOTSServerListeners: failed to open listener=
 for inet6
[   314.594]=20
X.Org X Server 1.11.1
Release Date: 2011-09-24
[   314.594] X Protocol Version 11, Revision 0
[   314.594] Build Operating System: Linux 2.6.32-5-amd64 i686 Debian
[   314.594] Current Operating System: Linux gonzales 3.0.0 #1 PREEMPT Wed =
Sep 7 21:00:47 EDT 2011 i686
[   314.594] Kernel command line: BOOT_IMAGE=3D/vmlinuz-3 ro
[   314.594] Build Date: 24 September 2011  10:02:42AM
[   314.594] xorg-server 2:1.11.1-1 (Cyril Brulebois <kibi@debian.org>)=20
[   314.594] Current version of pixman: 0.22.2
[   314.594] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[   314.594] Markers: (--) probed, (**) from config file, (=3D=3D) default =
setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[   314.594] (=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Sun Sep 25 10:=
00:30 2011
[   314.594] (=3D=3D) Using system config directory "/usr/share/X11/xorg.co=
nf.d"
[   314.603] (=3D=3D) No Layout section.  Using the first Screen section.
[   314.603] (=3D=3D) No screen section available. Using defaults.
[   314.603] (**) |-->Screen "Default Screen Section" (0)
[   314.603] (**) |   |-->Monitor "<default monitor>"
[   314.603] (=3D=3D) No monitor specified for screen "Default Screen Secti=
on".
	Using a default monitor configuration.
[   314.603] (=3D=3D) Automatically adding devices
[   314.603] (=3D=3D) Automatically enabling devices
[   314.691] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not ex=
ist.
[   314.691] 	Entry deleted from font path.
[   314.833] (WW) The directory "/var/lib/defoma/x-ttcidfont-conf.d/dirs/Tr=
ueType" does not exist.
[   314.833] 	Entry deleted from font path.
[   314.833] (=3D=3D) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	built-ins
[   314.833] (=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
[   314.833] (II) The server relies on udev to provide the list of input de=
vices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[   314.833] (II) Loader magic: 0x822b800
[   314.833] (II) Module ABI versions:
[   314.833] 	X.Org ANSI C Emulation: 0.4
[   314.833] 	X.Org Video Driver: 11.0
[   314.833] 	X.Org XInput driver : 13.0
[   314.833] 	X.Org Server Extension : 6.0
[   314.834] (--) PCI:*(0:1:0:0) 1002:4c57:1028:0149 rev 0, Mem @ 0xe800000=
0/134217728, 0xfcff0000/65536, I/O @ 0x0000c000/256, BIOS @ 0x????????/1310=
72
[   314.834] (II) Open ACPI successful (/var/run/acpid.socket)
[   314.834] (II) LoadModule: "extmod"
[   314.835] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[   314.835] (II) Module extmod: vendor=3D"X.Org Foundation"
[   314.835] 	compiled for 1.11.1, module version =3D 1.0.0
[   314.835] 	Module class: X.Org Server Extension
[   314.835] 	ABI class: X.Org Server Extension, version 6.0
[   314.835] (II) Loading extension SELinux
[   314.835] (II) Loading extension MIT-SCREEN-SAVER
[   314.835] (II) Loading extension XFree86-VidModeExtension
[   314.835] (II) Loading extension XFree86-DGA
[   314.835] (II) Loading extension DPMS
[   314.835] (II) Loading extension XVideo
[   314.835] (II) Loading extension XVideo-MotionCompensation
[   314.835] (II) Loading extension X-Resource
[   314.835] (II) LoadModule: "dbe"
[   314.836] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[   314.836] (II) Module dbe: vendor=3D"X.Org Foundation"
[   314.836] 	compiled for 1.11.1, module version =3D 1.0.0
[   314.836] 	Module class: X.Org Server Extension
[   314.836] 	ABI class: X.Org Server Extension, version 6.0
[   314.836] (II) Loading extension DOUBLE-BUFFER
[   314.836] (II) LoadModule: "glx"
[   314.836] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[   314.836] (II) Module glx: vendor=3D"X.Org Foundation"
[   314.836] 	compiled for 1.11.1, module version =3D 1.0.0
[   314.836] 	ABI class: X.Org Server Extension, version 6.0
[   314.836] (=3D=3D) AIGLX enabled
[   314.836] (II) Loading extension GLX
[   314.836] (II) LoadModule: "record"
[   314.836] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[   314.836] (II) Module record: vendor=3D"X.Org Foundation"
[   314.836] 	compiled for 1.11.1, module version =3D 1.13.0
[   314.836] 	Module class: X.Org Server Extension
[   314.836] 	ABI class: X.Org Server Extension, version 6.0
[   314.836] (II) Loading extension RECORD
[   314.836] (II) LoadModule: "dri"
[   314.836] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[   314.845] (II) Module dri: vendor=3D"X.Org Foundation"
[   314.845] 	compiled for 1.11.1, module version =3D 1.0.0
[   314.845] 	ABI class: X.Org Server Extension, version 6.0
[   314.845] (II) Loading extension XFree86-DRI
[   314.845] (II) LoadModule: "dri2"
[   314.846] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[   314.846] (II) Module dri2: vendor=3D"X.Org Foundation"
[   314.846] 	compiled for 1.11.1, module version =3D 1.2.0
[   314.846] 	ABI class: X.Org Server Extension, version 6.0
[   314.846] (II) Loading extension DRI2
[   314.846] (=3D=3D) Matched ati as autoconfigured driver 0
[   314.846] (=3D=3D) Matched vesa as autoconfigured driver 1
[   314.846] (=3D=3D) Matched fbdev as autoconfigured driver 2
[   314.846] (=3D=3D) Assigned the driver to the xf86ConfigLayout
[   314.846] (II) LoadModule: "ati"
[   314.864] (II) Loading /usr/lib/xorg/modules/drivers/ati_drv.so
[   314.875] (II) Module ati: vendor=3D"X.Org Foundation"
[   314.875] 	compiled for 1.11.0, module version =3D 6.14.2
[   314.875] 	Module class: X.Org Video Driver
[   314.875] 	ABI class: X.Org Video Driver, version 11.0
[   314.875] (II) LoadModule: "radeon"
[   314.875] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[   314.965] (II) Module radeon: vendor=3D"X.Org Foundation"
[   314.965] 	compiled for 1.11.0, module version =3D 6.14.2
[   314.965] 	Module class: X.Org Video Driver
[   314.965] 	ABI class: X.Org Video Driver, version 11.0
[   314.969] (II) LoadModule: "vesa"
[   314.988] (WW) Warning, couldn't open module vesa
[   314.988] (II) UnloadModule: "vesa"
[   314.988] (II) Unloading vesa
[   314.988] (EE) Failed to load module "vesa" (module does not exist, 0)
[   314.988] (II) LoadModule: "fbdev"
[   314.988] (WW) Warning, couldn't open module fbdev
[   314.988] (II) UnloadModule: "fbdev"
[   314.988] (II) Unloading fbdev
[   314.988] (EE) Failed to load module "fbdev" (module does not exist, 0)
[   314.988] (II) RADEON: Driver for ATI Radeon chipsets:
	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI FireMV 2400 3155 (PCI),
	ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
	ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
	ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
	ATI Radeon 8500 AIW BB (AGP), ATI Radeon IGP320M (U1) 4336,
	ATI Radeon IGP330M/340M/350M (U2) 4337,
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
	ATI Mobility RADEON HD 4870, ATI Radeon 4800 Series,
	ATI Radeon 4800 Series, ATI FirePro M7750, ATI M98, ATI M98, ATI M98,
	ATI Mobility Radeon HD 4650, ATI Radeon RV730 (AGP),
	ATI Mobility Radeon HD 4670, ATI FirePro M5750,
	ATI Mobility Radeon HD 4670, ATI Radeon RV730 (AGP),
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
	ATI Radeon RV710, ATI Radeon RV710, ATI Radeon RV710,
	ATI Radeon HD 4350, ATI Mobility Radeon 4300 Series,
	ATI Mobility Radeon 4500 Series, ATI Mobility Radeon 4500 Series,
	ATI FirePro RG220, ATI Mobility Radeon 4330, ATI RV630,
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
	ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
	ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
	ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
	ATI FireGL V3600, ATI Radeon HD 2600 LE,
	ATI Mobility FireGL Graphics Processor, ATI Radeon HD 3470,
	ATI Mobility Radeon HD 3430, ATI Mobility Radeon HD 3400 Series,
	ATI Radeon HD 3450, ATI Radeon HD 3450, ATI Radeon HD 3430,
	ATI Radeon HD 3450, ATI FirePro V3700, ATI FireMV 2450,
	ATI FireMV 2260, ATI FireMV 2260, ATI Radeon HD 3600 Series,
	ATI Radeon HD 3650 AGP, ATI Radeon HD 3600 PRO,
	ATI Radeon HD 3600 XT, ATI Radeon HD 3600 PRO,
	ATI Mobility Radeon HD 3650, ATI Mobility Radeon HD 3670,
	ATI Mobility FireGL V5700, ATI Mobility FireGL V5725,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3300 Graphics, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3000 Graphics, ATI Radeon HD 4200, ATI Radeon 4100,
	ATI Mobility Radeon HD 4200, ATI Mobility Radeon 4100,
	ATI Radeon HD 4290, ATI Radeon HD 4250, AMD Radeon HD 6310 Graphics,
	AMD Radeon HD 6310 Graphics, AMD Radeon HD 6250 Graphics,
	AMD Radeon HD 6250 Graphics, AMD Radeon HD 6300 Series Graphics,
	AMD Radeon HD 6200 Series Graphics, CYPRESS,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, AMD Firestream 9370,
	AMD Firestream 9350, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5900 Series,
	ATI Radeon HD 5900 Series, ATI Mobility Radeon HD 5800 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 6700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 6700 Series,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon HD 5570,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5670,
	ATI Radeon HD 5570, ATI Radeon HD 5500 Series, REDWOOD,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon Graphics,
	ATI Mobility Radeon Graphics, CEDAR,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI FirePro 2270, CEDAR,
	ATI Radeon HD 5450, CEDAR, CAYMAN, CAYMAN, CAYMAN, CAYMAN, CAYMAN,
	CAYMAN, CAYMAN, CAYMAN, CAYMAN, CAYMAN, AMD Radeon HD 6900 Series,
	AMD Radeon HD 6900 Series, CAYMAN, CAYMAN, CAYMAN,
	AMD Radeon HD 6900M Series, Mobility Radeon HD 6000 Series, BARTS,
	BARTS, Mobility Radeon HD 6000 Series,
	Mobility Radeon HD 6000 Series, BARTS, BARTS, BARTS, BARTS,
	AMD Radeon HD 6800 Series, AMD Radeon HD 6800 Series,
	AMD Radeon HD 6700 Series, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS,
	TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, CAICOS, CAICOS,
	CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
	CAICOS
[   314.992] (++) using VT number 7

[   314.994] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[   314.994] (II) [KMS] drm report modesetting isn't supported.
[   314.994] (WW) VGA arbiter: cannot open kernel arbiter, no multi-card su=
pport
[   314.994] (II) RADEON(0): TOTO SAYS 00000000fcff0000
[   314.994] (II) RADEON(0): MMIO registers at 0x00000000fcff0000: size 64KB
[   314.994] (II) RADEON(0): PCI bus 1 card 0 func 0
[   314.994] (II) RADEON(0): Creating default Display subsection in Screen =
section
	"Default Screen Section" for depth/fbbpp 24/32
[   314.994] (=3D=3D) RADEON(0): Depth 24, (--) framebuffer bpp 32
[   314.995] (II) RADEON(0): Pixel depth =3D 24 bits stored in 4 bytes (32 =
bpp pixmaps)
[   314.995] (=3D=3D) RADEON(0): Default visual is TrueColor
[   314.995] (II) Loading sub module "vgahw"
[   314.995] (II) LoadModule: "vgahw"
[   314.995] (II) Loading /usr/lib/xorg/modules/libvgahw.so
[   314.996] (II) Module vgahw: vendor=3D"X.Org Foundation"
[   314.996] 	compiled for 1.11.1, module version =3D 0.1.0
[   314.996] 	ABI class: X.Org Video Driver, version 11.0
[   314.996] (II) RADEON(0): vgaHWGetIOBase: hwp->IOBase is 0x03d0, hwp->PI=
OOffset is 0x0000
[   314.996] (=3D=3D) RADEON(0): RGB weight 888
[   314.996] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[   314.996] (--) RADEON(0): Chipset: "ATI Radeon Mobility M7 LW (AGP)" (Ch=
ipID =3D 0x4c57)
[   314.996] (--) RADEON(0): Linear framebuffer at 0x00000000e8000000
[   314.996] (II) RADEON(0): AGP card detected
[   314.996] (II) Loading sub module "int10"
[   314.996] (II) LoadModule: "int10"
[   314.996] (II) Loading /usr/lib/xorg/modules/libint10.so
[   314.996] (II) Module int10: vendor=3D"X.Org Foundation"
[   314.996] 	compiled for 1.11.1, module version =3D 1.0.0
[   314.996] 	ABI class: X.Org Video Driver, version 11.0
[   314.996] (II) RADEON(0): initializing int10
[   314.997] (II) RADEON(0): Primary V_BIOS segment is: 0xc000
[   314.997] (II) RADEON(0): Legacy BIOS detected
[   315.009] drmOpenDevice: node name is /dev/dri/card0
[   315.009] drmOpenDevice: open result is 11, (OK)
[   315.009] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[   315.009] drmOpenDevice: node name is /dev/dri/card0
[   315.009] drmOpenDevice: open result is 11, (OK)
[   315.009] drmOpenByBusid: drmOpenMinor returns 11
[   315.009] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[   315.009] (II) RADEON(0): [dri] Found DRI library version 1.3.0 and kern=
el module version 1.33.0
[   315.010] (=3D=3D) RADEON(0): Page Flipping disabled
[   315.010] (II) RADEON(0): Will try to use DMA for Xv image transfers
[   315.010] (II) RADEON(0): Detected total video RAM=3D32768K, accessible=
=3D65536K (PCI BAR=3D131072K)
[   315.010] (--) RADEON(0): Mapped VideoRAM: 32768 kByte (64 bit DDR SDRAM)
[   315.010] (II) RADEON(0): Color tiling enabled by default
[   315.010] (II) Loading sub module "ddc"
[   315.010] (II) LoadModule: "ddc"
[   315.010] (II) Module "ddc" already built-in
[   315.010] (II) Loading sub module "i2c"
[   315.010] (II) LoadModule: "i2c"
[   315.010] (II) Module "i2c" already built-in
[   315.010] (II) RADEON(0): ref_freq: 2700, min_out_pll: 20000, max_out_pl=
l: 35000, min_in_pll: 40, max_in_pll: 3000, xclk: 18000, sclk: 230.000000, =
mclk: 180.000000
[   315.010] (II) RADEON(0): PLL parameters: rf=3D2700 rd=3D12 min=3D20000 =
max=3D35000; xclk=3D18000
[   315.010] (II) RADEON(0): Panel ID string: Y0813=04150PG
           =20
[   315.010] (II) RADEON(0): Panel Size from BIOS: 1400x1050
[   315.010] (II) RADEON(0): BIOS provided dividers will be used.
[   315.010] (WW) RADEON(0): LVDS Info:
XRes: 1400, YRes: 1050, DotClock: 108000
HBlank: 288, HOverPlus: 40, HSyncWidth: 112
VBlank: 16, VOverPlus: 1, VSyncWidth: 4
[   315.010] (II) RADEON(0): Output VGA-0 has no monitor section
[   315.010] (II) RADEON(0): I2C bus "VGA-0" initialized.
[   315.010] (II) RADEON(0): Output LVDS has no monitor section
[   315.010] (II) RADEON(0): Output S-video has no monitor section
[   315.010] (II) RADEON(0): Default TV standard: NTSC
[   315.010] (II) RADEON(0): TV standards supported by chip: NTSC PAL NTSC-=
J=20
[   315.010] (II) RADEON(0): Port0:
[   315.010]   XRANDR name: VGA-0
[   315.010]   Connector: VGA
[   315.010]   CRT1: INTERNAL_DAC1
[   315.010]   DDC reg: 0x60
[   315.010] (II) RADEON(0): Port1:
[   315.010]   XRANDR name: LVDS
[   315.010]   Connector: LVDS
[   315.010]   LCD1: INTERNAL_LVDS
[   315.010]   DDC reg: 0x0
[   315.010] (II) RADEON(0): Port2:
[   315.010]   XRANDR name: S-video
[   315.010]   Connector: S-video
[   315.010]   TV1: INTERNAL_DAC2
[   315.010]   DDC reg: 0x0
[   315.010] (II) RADEON(0): I2C device "VGA-0:ddc2" registered at address =
0xA0.
[   315.016] (II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
[   315.016] finished output detect: 0
[   315.016] (II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
[   315.016] finished output detect: 1
[   315.016] (II) RADEON(0): Output: S-video, Detected Monitor Type: 0
[   315.016] finished output detect: 2
[   315.016] finished all detect
[   315.021] (II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
[   315.021] (II) RADEON(0): EDID for output VGA-0
[   315.021] (II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
[   315.021] (II) RADEON(0): Added native panel mode: 1400x1050
[   315.021] (II) RADEON(0): Printing probed modes for output LVDS
[   315.021] (II) RADEON(0): Modeline "1400x1050"x60.0  108.00  1400 1440 1=
552 1688  1050 1051 1055 1066 (64.0 kHz)
[   315.021] (II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1=
496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
[   315.021] (II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 14=
88 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
[   315.021] (II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 14=
80 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
[   315.021] (II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 14=
80 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
[   315.021] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 14=
72 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[   315.021] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 13=
28 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[   315.022] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 11=
76 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[   315.022] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1=
024  600 603 607 624 -hsync +vsync (37.4 kHz)
[   315.022] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 8=
00  480 483 487 500 -hsync +vsync (29.7 kHz)
[   315.022] (II) RADEON(0): Output: S-video, Detected Monitor Type: 0
[   315.022] (II) RADEON(0): EDID for output S-video
[   315.022] (II) RADEON(0): Output VGA-0 disconnected
[   315.022] (II) RADEON(0): Output LVDS connected
[   315.022] (II) RADEON(0): Output S-video disconnected
[   315.022] (II) RADEON(0): Using exact sizes for initial modes
[   315.022] (II) RADEON(0): Output LVDS using initial mode 1400x1050
[   315.022] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless =
otherwise stated.
[   315.022] (=3D=3D) RADEON(0): DPI set to (96, 96)
[   315.022] (II) Loading sub module "fb"
[   315.022] (II) LoadModule: "fb"
[   315.022] (II) Loading /usr/lib/xorg/modules/libfb.so
[   315.022] (II) Module fb: vendor=3D"X.Org Foundation"
[   315.022] 	compiled for 1.11.1, module version =3D 1.0.0
[   315.022] 	ABI class: X.Org ANSI C Emulation, version 0.4
[   315.022] (II) Loading sub module "ramdac"
[   315.022] (II) LoadModule: "ramdac"
[   315.022] (II) Module "ramdac" already built-in
[   315.022] (=3D=3D) RADEON(0): Using XAA acceleration architecture
[   315.022] (II) Loading sub module "xaa"
[   315.022] (II) LoadModule: "xaa"
[   315.022] (II) Loading /usr/lib/xorg/modules/libxaa.so
[   315.023] (II) Module xaa: vendor=3D"X.Org Foundation"
[   315.023] 	compiled for 1.11.1, module version =3D 1.2.1
[   315.023] 	ABI class: X.Org Video Driver, version 11.0
[   315.023] (=3D=3D) RADEON(0): Assuming overlay scaler buffer width is 15=
36
[   315.023] (II) RADEON(0): No MM_TABLE found - assuming CARD is not TV-in=
 capable.
[   315.023] (!!) RADEON(0): MergedFB support has been removed and replaced=
 with xrandr 1.2 support
[   315.023] (--) Depth 24 pixmap format is 32 bpp
[   315.023] (II) RADEON(0): RADEONScreenInit e8000000 0 0
[   315.112] Entering TV Save
[   315.112] Save TV timing tables
[   315.112] saveTimingTables: reading timing tables
[   315.112] TV Save done
[   316.179] (II) RADEON(0): Dynamic Power Management Disabled
[   316.179] (=3D=3D) RADEON(0): Using 24 bit depth buffer
[   316.179] (II) RADEON(0): RADEONInitMemoryMap() :=20
[   316.179] (II) RADEON(0):   mem_size         : 0x04000000
[   316.179] (II) RADEON(0):   MC_FB_LOCATION   : 0xebffe800
[   316.179] (II) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
[   316.179] (II) RADEON(0): Depth moves disabled by default
[   316.179] (II) RADEON(0): Using 8 MB GART aperture
[   316.179] (II) RADEON(0): Using 1 MB for the ring buffer
[   316.179] (II) RADEON(0): Using 2 MB for vertex/indirect buffers
[   316.179] (II) RADEON(0): Using 5 MB for GART textures
[   316.179] (II) RADEON(0): Memory manager initialized to (0,0) (1408,5957)
[   316.179] (II) RADEON(0): Reserved area from (0,1400) to (1408,1410)
[   316.179] (II) RADEON(0): Largest offscreen area available: 1408 x 4547
[   316.179] (II) RADEON(0): Will use front buffer at offset 0x0
[   316.179] (II) RADEON(0): Will use back buffer at offset 0xf20000
[   316.179] (II) RADEON(0): Will use depth buffer at offset 0x16b0000
[   316.179] (II) RADEON(0): Will use 1792 kb for textures at offset 0x1e40=
000
[   316.179] drmOpenDevice: node name is /dev/dri/card0
[   316.179] drmOpenDevice: open result is 11, (OK)
[   316.180] drmOpenDevice: node name is /dev/dri/card0
[   316.180] drmOpenDevice: open result is 11, (OK)
[   316.180] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[   316.180] drmOpenDevice: node name is /dev/dri/card0
[   316.180] drmOpenDevice: open result is 11, (OK)
[   316.180] drmOpenByBusid: drmOpenMinor returns 11
[   316.180] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[   316.180] (II) [drm] DRM interface version 1.4
[   316.180] (II) [drm] DRM open master succeeded.
[   316.180] (II) RADEON(0): [drm] Using the DRM lock SAREA also for drawab=
les.
[   316.180] (II) RADEON(0): [drm] framebuffer handle =3D 0xe8000000
[   316.180] (II) RADEON(0): [drm] added 1 reserved context for kernel
[   316.180] (II) RADEON(0): X context handle =3D 0x1
[   316.180] (II) RADEON(0): [drm] installed DRM signal handler
[   316.180] (=3D=3D) RADEON(0): Using AGP 4x
[   316.180] (II) RADEON(0): [agp] Mode 0x1f000207 [AGP 0x8086/0x2560; Card=
 0x1002/0x4c57 0x1028/0x0149]
[   316.196] (II) RADEON(0): [agp] 8192 kB allocated with handle 0x00000001
[   316.197] (II) RADEON(0): [agp] ring handle =3D 0xe0000000
[   316.197] (II) RADEON(0): [agp] Ring mapped at 0xb71af000
[   316.197] (II) RADEON(0): [agp] ring read ptr handle =3D 0xe0101000
[   316.197] (II) RADEON(0): [agp] Ring read ptr mapped at 0xb71ae000
[   316.197] (II) RADEON(0): [agp] vertex/indirect buffers handle =3D 0xe01=
02000
[   316.197] (II) RADEON(0): [agp] Vertex/indirect buffers mapped at 0xb6eb=
3000
[   316.197] (II) RADEON(0): [agp] GART texture map handle =3D 0xe0302000
[   316.197] (II) RADEON(0): [agp] GART Texture map mapped at 0xb69d3000
[   316.197] (II) RADEON(0): [drm] register handle =3D 0x2f9fe000
[   316.197] (II) RADEON(0): [dri] Visual configs initialized
[   316.198] (II) RADEON(0): RADEONRestoreMemMapRegisters() :=20
[   316.198] (II) RADEON(0):   MC_FB_LOCATION   : 0xebffe800 0x1fff0000
[   316.198] (II) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
[   316.398] (=3D=3D) RADEON(0): Backing store disabled
[   316.398] (II) RADEON(0): [DRI] installation complete
[   316.485] (II) RADEON(0): [drm] Added 32 65536 byte vertex/indirect buff=
ers
[   316.485] (II) RADEON(0): [drm] Mapped 32 vertex/indirect buffers
[   316.485] (II) RADEON(0): [drm] dma control initialized, using IRQ 11
[   316.485] (II) RADEON(0): [drm] Initialized kernel GART heap manager, 51=
11808
[   316.485] (WW) RADEON(0): DRI init changed memory map, adjusting ...
[   316.485] (WW) RADEON(0):   MC_FB_LOCATION  was: 0xebffe800 is: 0xebffe8=
00
[   316.485] (WW) RADEON(0):   MC_AGP_LOCATION was: 0xffffffc0 is: 0xe07fe0=
00
[   316.485] (II) RADEON(0): RADEONRestoreMemMapRegisters() :=20
[   316.485] (II) RADEON(0):   MC_FB_LOCATION   : 0xebffe800 0xebffe800
[   316.485] (II) RADEON(0):   MC_AGP_LOCATION  : 0xe07fe000
[   316.585] (II) RADEON(0): Direct rendering enabled
[   316.585] (II) RADEON(0): Render acceleration disabled
[   316.586] (II) RADEON(0): Using XFree86 Acceleration Architecture (XAA)
[   316.586] 	Screen to screen bit blits
[   316.586] 	Solid filled rectangles
[   316.586] 	8x8 mono pattern filled rectangles
[   316.586] 	Indirect CPU to Screen color expansion
[   316.586] 	Solid Lines
[   316.586] 	Scanline Image Writes
[   316.586] 	Setting up tile and stipple cache:
[   316.586] 		32 128x128 slots
[   316.586] 		32 256x256 slots
[   316.586] 		13 512x512 slots
[   316.586] (II) RADEON(0): Acceleration enabled
[   316.586] (=3D=3D) RADEON(0): DPMS enabled
[   316.586] (=3D=3D) RADEON(0): Silken mouse enabled
[   316.586] (II) RADEON(0): Will use 32 kb for hardware cursor 0 at offset=
 0x00792c00
[   316.586] (II) RADEON(0): Will use 32 kb for hardware cursor 1 at offset=
 0x00796e00
[   316.586] (II) RADEON(0): Largest offscreen area available: 1408 x 4541
[   316.586] (II) RADEON(0): Detected Radeon Mobility M7, disabling multime=
dia i2c
[   316.586] (II) Loading sub module "theatre_detect"
[   316.586] (II) LoadModule: "theatre_detect"
[   316.586] (II) Loading /usr/lib/xorg/modules/multimedia/theatre_detect_d=
rv.so
[   316.600] (II) Module theatre_detect: vendor=3D"X.Org Foundation"
[   316.600] 	compiled for 1.11.0, module version =3D 1.0.0
[   316.600] 	ABI class: X.Org Video Driver, version 11.0
[   316.600] (II) RADEON(0): no multimedia table present, disabling Rage Th=
eatre.
[   316.600] (II) RADEON(0): Set up overlay video
[   316.600] (II) RADEON(0): Set up textured video
[   316.634] disable primary dac
[   317.635] disable TV
[   318.635] init memmap
[   318.635] init common
[   318.635] init crtc1
[   318.635] init pll1
[   318.635] restore memmap
[   318.635] (II) RADEON(0): RADEONRestoreMemMapRegisters() :=20
[   318.635] (II) RADEON(0):   MC_FB_LOCATION   : 0xebffe800 0xebffe800
[   318.635] (II) RADEON(0):   MC_AGP_LOCATION  : 0xe07fe000
[   318.735] restore common
[   318.835] restore crtc1
[   318.835] restore pll1
[   318.835] set RMX
[   318.835] set LVDS
[   318.835] enable LVDS
[   319.836] disable primary dac
[   319.840] disable TV
[   319.840] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR =
disabled message.
[   319.841] (--) RandR disabled
[   319.841] (II) Initializing built-in extension Generic Event Extension
[   319.841] (II) Initializing built-in extension SHAPE
[   319.841] (II) Initializing built-in extension MIT-SHM
[   319.841] (II) Initializing built-in extension XInputExtension
[   319.841] (II) Initializing built-in extension XTEST
[   319.841] (II) Initializing built-in extension BIG-REQUESTS
[   319.841] (II) Initializing built-in extension SYNC
[   319.841] (II) Initializing built-in extension XKEYBOARD
[   319.841] (II) Initializing built-in extension XC-MISC
[   319.841] (II) Initializing built-in extension SECURITY
[   319.841] (II) Initializing built-in extension XINERAMA
[   319.841] (II) Initializing built-in extension XFIXES
[   319.841] (II) Initializing built-in extension RENDER
[   319.841] (II) Initializing built-in extension RANDR
[   319.841] (II) Initializing built-in extension COMPOSITE
[   319.841] (II) Initializing built-in extension DAMAGE
[   319.841] (II) SELinux: Disabled on system
[   319.857] (II) AIGLX: Screen 0 is not DRI2 capable
[   319.857] drmOpenDevice: node name is /dev/dri/card0
[   319.857] drmOpenDevice: open result is 12, (OK)
[   319.857] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[   319.857] drmOpenDevice: node name is /dev/dri/card0
[   319.857] drmOpenDevice: open result is 12, (OK)
[   319.857] drmOpenByBusid: drmOpenMinor returns 12
[   319.857] drmOpenByBusid: Interface 1.4 failed, trying 1.1
[   319.857] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[   320.078] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[   320.078] (II) AIGLX: enabled GLX_SGI_make_current_read
[   320.078] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_con=
trol
[   320.078] (II) AIGLX: enabled GLX_texture_from_pixmap with driver support
[   320.078] (II) AIGLX: Loaded and initialized radeon
[   320.078] (II) GLX: Initialized DRI GL provider for screen 0
[   320.079] (II) RADEON(0): Setting screen physical size to 370 x 277
[   320.546] (II) config/udev: Adding input device Power Button (/dev/input=
/event1)
[   320.546] (**) Power Button: Applying InputClass "evdev keyboard catchal=
l"
[   320.546] (II) LoadModule: "evdev"
[   320.546] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   320.564] (II) Module evdev: vendor=3D"X.Org Foundation"
[   320.564] 	compiled for 1.11.0, module version =3D 2.6.0
[   320.564] 	Module class: X.Org XInput Driver
[   320.564] 	ABI class: X.Org XInput driver, version 13.0
[   320.564] (II) Using input driver 'evdev' for 'Power Button'
[   320.564] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   320.564] (**) Power Button: always reports core events
[   320.564] (**) Power Button: Device: "/dev/input/event1"
[   320.564] (--) Power Button: Found keys
[   320.564] (II) Power Button: Configuring as keyboard
[   320.564] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/devic=
e:00/PNP0C0C:00/input/input1/event1"
[   320.564] (II) XINPUT: Adding extended input device "Power Button" (type=
: KEYBOARD, id 6)
[   320.564] (**) Option "xkb_rules" "evdev"
[   320.564] (**) Option "xkb_model" "pc104"
[   320.564] (**) Option "xkb_layout" "us"
[   320.564] (**) Option "xkb_options" "compose:menu,terminate:ctrl_alt_bks=
p"
[   320.606] (II) config/udev: Adding input device Lid Switch (/dev/input/e=
vent0)
[   320.606] (II) No input driver/identifier specified (ignoring)
[   320.607] (II) config/udev: Adding input device Sleep Button (/dev/input=
/event2)
[   320.607] (**) Sleep Button: Applying InputClass "evdev keyboard catchal=
l"
[   320.607] (II) Using input driver 'evdev' for 'Sleep Button'
[   320.607] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   320.607] (**) Sleep Button: always reports core events
[   320.607] (**) Sleep Button: Device: "/dev/input/event2"
[   320.607] (--) Sleep Button: Found keys
[   320.607] (II) Sleep Button: Configuring as keyboard
[   320.607] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/devic=
e:00/PNP0C0E:00/input/input2/event2"
[   320.607] (II) XINPUT: Adding extended input device "Sleep Button" (type=
: KEYBOARD, id 7)
[   320.607] (**) Option "xkb_rules" "evdev"
[   320.607] (**) Option "xkb_model" "pc104"
[   320.607] (**) Option "xkb_layout" "us"
[   320.607] (**) Option "xkb_options" "compose:menu,terminate:ctrl_alt_bks=
p"
[   320.608] (II) config/udev: Adding input device AT Translated Set 2 keyb=
oard (/dev/input/event3)
[   320.608] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev =
keyboard catchall"
[   320.608] (II) Using input driver 'evdev' for 'AT Translated Set 2 keybo=
ard'
[   320.608] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   320.608] (**) AT Translated Set 2 keyboard: always reports core events
[   320.608] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event3"
[   320.608] (--) AT Translated Set 2 keyboard: Found keys
[   320.608] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[   320.608] (**) Option "config_info" "udev:/sys/devices/platform/i8042/se=
rio0/input/input3/event3"
[   320.608] (II) XINPUT: Adding extended input device "AT Translated Set 2=
 keyboard" (type: KEYBOARD, id 8)
[   320.608] (**) Option "xkb_rules" "evdev"
[   320.608] (**) Option "xkb_model" "pc104"
[   320.608] (**) Option "xkb_layout" "us"
[   320.608] (**) Option "xkb_options" "compose:menu,terminate:ctrl_alt_bks=
p"
[   320.609] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[   320.609] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[   320.609] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[   320.609] (II) LoadModule: "synaptics"
[   320.609] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[   320.619] (II) Module synaptics: vendor=3D"X.Org Foundation"
[   320.619] 	compiled for 1.11.0, module version =3D 1.4.1
[   320.619] 	Module class: X.Org XInput Driver
[   320.619] 	ABI class: X.Org XInput driver, version 13.0
[   320.619] (II) Using input driver 'synaptics' for 'SynPS/2 Synaptics Tou=
chPad'
[   320.619] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[   320.619] (**) SynPS/2 Synaptics TouchPad: always reports core events
[   320.619] (**) Option "Device" "/dev/input/event4"
[   320.632] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5472
[   320.632] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4448
[   320.632] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[   320.632] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[   320.632] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[   320.648] (--) SynPS/2 Synaptics TouchPad: touchpad found
[   320.648] (**) SynPS/2 Synaptics TouchPad: always reports core events
[   320.664] (**) Option "config_info" "udev:/sys/devices/platform/i8042/se=
rio1/input/input4/event4"
[   320.664] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD, id 9)
[   320.664] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[   320.664] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[   320.664] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.040
[   320.664] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[   320.664] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[   320.664] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[   320.664] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[   320.664] (--) SynPS/2 Synaptics TouchPad: touchpad found
[   320.665] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[   320.665] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[   320.665] (II) Using input driver 'synaptics' for 'SynPS/2 Synaptics Tou=
chPad'
[   320.665] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[   320.665] (**) SynPS/2 Synaptics TouchPad: always reports core events
[   320.665] (**) Option "Device" "/dev/input/mouse0"
[   320.665] (--) SynPS/2 Synaptics TouchPad: invalid x-axis range.  defaul=
ting to 1615 - 5685
[   320.665] (--) SynPS/2 Synaptics TouchPad: invalid y-axis range.  defaul=
ting to 1729 - 4171
[   320.665] (--) SynPS/2 Synaptics TouchPad: invalid pressure range.  defa=
ulting to 0 - 256
[   320.665] (--) SynPS/2 Synaptics TouchPad: invalid finger width range.  =
defaulting to 0 - 16
[   320.685] (EE) Query no Synaptics: 6003C8
[   320.685] (--) SynPS/2 Synaptics TouchPad: no supported touchpad found
[   320.685] (EE) SynPS/2 Synaptics TouchPad Unable to query/initialize Syn=
aptics hardware.
[   320.700] (EE) PreInit returned 11 for "SynPS/2 Synaptics TouchPad"
[   320.700] (II) UnloadModule: "synaptics"
[   320.700] (II) Unloading synaptics
[   320.700] (II) config/udev: Adding input device PC Speaker (/dev/input/e=
vent5)
[   320.700] (II) No input driver/identifier specified (ignoring)
[   326.016] (II) AIGLX: Suspending AIGLX clients for VT switch
[   327.016] (II) RADEON(0): RADEONRestoreMemMapRegisters() :=20
[   327.016] (II) RADEON(0):   MC_FB_LOCATION   : 0x1fff0000 0xebffe800
[   327.016] (II) RADEON(0):   MC_AGP_LOCATION  : 0x27ff2000
[   327.321] finished PLL2
[   327.321] Entering Restore TV
[   327.321] Restore TV PLL
[   327.323] Restore TVHV
[   327.323] Restore TV Restarts
[   327.323] Restore Timing Tables
[   327.323] Restore TV standard
[   327.323] Leaving Restore TV

--ZGiS0Q5IWpPtfppv--
