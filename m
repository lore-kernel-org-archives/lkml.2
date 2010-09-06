Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab0IFItN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:49:13 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:36917 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0IFItJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:49:09 -0400
Date: Mon, 6 Sep 2010 10:49:41 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Message-ID: <20100906084941.GC2356@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org>
 <20100709102935.60648095@virtuousgeek.org>
 <20100906071759.GB2356@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <20100906071759.GB2356@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: multipart/mixed; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

+ log

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log"
Content-Transfer-Encoding: quoted-printable

[   162.771]=20
This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.
[   162.771]=20
X.Org X Server 1.8.1.902 (1.8.2 RC 2)
Release Date: 2010-06-21
[   162.771] X Protocol Version 11, Revision 0
[   162.771] Build Operating System: Linux 2.6.34-ARCH x86_64=20
[   162.771] Current Operating System: Linux kr 2.6.34-ARCH #1 SMP PREEMPT =
Mon Jul 5 22:12:11 CEST 2010 x86_64
[   162.771] Kernel command line: root=3D/dev/disk/by-uuid/99dfc417-df30-49=
cf-8bb0-8b76fac3f232 ro
[   162.772] Build Date: 21 June 2010  12:01:49PM
[   162.772] =20
[   162.772] Current version of pixman: 0.18.2
[   162.772] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[   162.772] Markers: (--) probed, (**) from config file, (=3D=3D) default =
setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[   162.772] (=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Sat Aug 14 00:=
19:28 2010
[   162.802] (=3D=3D) Using config directory: "/etc/X11/xorg.conf.d"
[   162.815] (=3D=3D) No Layout section.  Using the first Screen section.
[   162.815] (=3D=3D) No screen section available. Using defaults.
[   162.815] (**) |-->Screen "Default Screen Section" (0)
[   162.815] (**) |   |-->Monitor "<default monitor>"
[   162.816] (=3D=3D) No monitor specified for screen "Default Screen Secti=
on".
	Using a default monitor configuration.
[   162.816] (=3D=3D) Automatically adding devices
[   162.816] (=3D=3D) Automatically enabling devices
[   162.878] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[   162.878] 	Entry deleted from font path.
[   162.941] (=3D=3D) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi/,
	/usr/share/fonts/75dpi/
[   162.941] (=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
[   162.941] (II) The server relies on udev to provide the list of input de=
vices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[   162.941] (II) Loader magic: 0x7ce880
[   162.941] (II) Module ABI versions:
[   162.941] 	X.Org ANSI C Emulation: 0.4
[   162.941] 	X.Org Video Driver: 7.0
[   162.941] 	X.Org XInput driver : 9.0
[   162.941] 	X.Org Server Extension : 3.0
[   162.953] (--) PCI:*(0:0:2:0) 8086:0046:17aa:215a Intel Corporation Core=
 Processor Integrated Graphics Controller rev 2, Mem @ 0xf2000000/4194304, =
0xd0000000/268435456, I/O @ 0x00001800/8
[   162.954] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or=
 directory)
[   162.954] (II) LoadModule: "extmod"
[   162.999] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[   163.008] (II) Module extmod: vendor=3D"X.Org Foundation"
[   163.008] 	compiled for 1.8.1.902, module version =3D 1.0.0
[   163.008] 	Module class: X.Org Server Extension
[   163.008] 	ABI class: X.Org Server Extension, version 3.0
[   163.008] (II) Loading extension MIT-SCREEN-SAVER
[   163.008] (II) Loading extension XFree86-VidModeExtension
[   163.008] (II) Loading extension XFree86-DGA
[   163.008] (II) Loading extension DPMS
[   163.008] (II) Loading extension XVideo
[   163.008] (II) Loading extension XVideo-MotionCompensation
[   163.008] (II) Loading extension X-Resource
[   163.008] (II) LoadModule: "dbe"
[   163.008] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[   163.018] (II) Module dbe: vendor=3D"X.Org Foundation"
[   163.018] 	compiled for 1.8.1.902, module version =3D 1.0.0
[   163.018] 	Module class: X.Org Server Extension
[   163.018] 	ABI class: X.Org Server Extension, version 3.0
[   163.018] (II) Loading extension DOUBLE-BUFFER
[   163.018] (II) LoadModule: "glx"
[   163.018] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[   163.024] (II) Module glx: vendor=3D"X.Org Foundation"
[   163.024] 	compiled for 1.8.1.902, module version =3D 1.0.0
[   163.024] 	ABI class: X.Org Server Extension, version 3.0
[   163.024] (=3D=3D) AIGLX enabled
[   163.024] (II) Loading extension GLX
[   163.025] (II) LoadModule: "record"
[   163.025] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[   163.026] (II) Module record: vendor=3D"X.Org Foundation"
[   163.026] 	compiled for 1.8.1.902, module version =3D 1.13.0
[   163.026] 	Module class: X.Org Server Extension
[   163.026] 	ABI class: X.Org Server Extension, version 3.0
[   163.026] (II) Loading extension RECORD
[   163.026] (II) LoadModule: "dri"
[   163.026] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[   163.061] (II) Module dri: vendor=3D"X.Org Foundation"
[   163.061] 	compiled for 1.8.1.902, module version =3D 1.0.0
[   163.061] 	ABI class: X.Org Server Extension, version 3.0
[   163.061] (II) Loading extension XFree86-DRI
[   163.061] (II) LoadModule: "dri2"
[   163.061] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[   163.063] (II) Module dri2: vendor=3D"X.Org Foundation"
[   163.063] 	compiled for 1.8.1.902, module version =3D 1.2.0
[   163.063] 	ABI class: X.Org Server Extension, version 3.0
[   163.063] (II) Loading extension DRI2
[   163.063] (=3D=3D) Matched intel as autoconfigured driver 0
[   163.063] (=3D=3D) Matched vesa as autoconfigured driver 1
[   163.063] (=3D=3D) Matched fbdev as autoconfigured driver 2
[   163.063] (=3D=3D) Assigned the driver to the xf86ConfigLayout
[   163.063] (II) LoadModule: "intel"
[   163.063] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[   163.102] (II) Module intel: vendor=3D"X.Org Foundation"
[   163.102] 	compiled for 1.8.1.902, module version =3D 2.12.0
[   163.102] 	Module class: X.Org Video Driver
[   163.102] 	ABI class: X.Org Video Driver, version 7.0
[   163.102] (II) LoadModule: "vesa"
[   163.102] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[   163.116] (II) Module vesa: vendor=3D"X.Org Foundation"
[   163.116] 	compiled for 1.8.0, module version =3D 2.3.0
[   163.116] 	Module class: X.Org Video Driver
[   163.116] 	ABI class: X.Org Video Driver, version 7.0
[   163.116] (II) LoadModule: "fbdev"
[   163.124] (WW) Warning, couldn't open module fbdev
[   163.124] (II) UnloadModule: "fbdev"
[   163.124] (EE) Failed to load module "fbdev" (module does not exist, 0)
[   163.124] (II) intel: Driver for Intel Integrated Graphics Chipsets: i81=
0,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, Clarkdale, Arrandale
[   163.124] (II) VESA: driver for VESA chipsets: vesa
[   163.124] (--) using VT number 7

[   163.127] (II) Primary Device is: PCI 00@00:02:0
[   163.127] (WW) Falling back to old probe method for vesa
[   163.129] drmOpenDevice: node name is /dev/dri/card0
[   163.129] drmOpenDevice: open result is 8, (OK)
[   163.129] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[   163.129] drmOpenDevice: node name is /dev/dri/card0
[   163.129] drmOpenDevice: open result is 8, (OK)
[   163.129] drmOpenByBusid: drmOpenMinor returns 8
[   163.129] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[   163.129] (II) intel(0): Creating default Display subsection in Screen s=
ection
	"Default Screen Section" for depth/fbbpp 24/32
[   163.129] (=3D=3D) intel(0): Depth 24, (--) framebuffer bpp 32
[   163.129] (=3D=3D) intel(0): RGB weight 888
[   163.129] (=3D=3D) intel(0): Default visual is TrueColor
[   163.129] (II) intel(0): Integrated Graphics Chipset: Intel(R) Arrandale
[   163.129] (--) intel(0): Chipset: "Arrandale"
[   163.129] (=3D=3D) intel(0): video overlay key set to 0x101fe
[   163.146] (II) intel(0): Output VGA1 has no monitor section
[   163.254] (II) intel(0): Output LVDS1 has no monitor section
[   163.254] (II) intel(0): found backlight control interface /sys/class/ba=
cklight/acpi_video0
[   163.469] (II) intel(0): Output HDMI1 has no monitor section
[   163.474] (II) intel(0): Output DP1 has no monitor section
[   163.491] (II) intel(0): EDID for output VGA1
[   163.599] (II) intel(0): EDID for output LVDS1
[   163.599] (II) intel(0): Manufacturer: LEN  Model: 4011  Serial#: 0
[   163.599] (II) intel(0): Year: 2009  Week: 1
[   163.599] (II) intel(0): EDID Version: 1.3
[   163.599] (II) intel(0): Digital Display Input
[   163.599] (II) intel(0): Max Image Size [cm]: horiz.: 26  vert.: 16
[   163.599] (II) intel(0): Gamma: 2.20
[   163.599] (II) intel(0): DPMS capabilities: StandBy Suspend Off
[   163.599] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:=
4=20
[   163.599] (II) intel(0): First detailed timing is preferred mode
[   163.599] (II) intel(0): redX: 0.560 redY: 0.350   greenX: 0.345 greenY:=
 0.560
[   163.599] (II) intel(0): blueX: 0.150 blueY: 0.105   whiteX: 0.313 white=
Y: 0.329
[   163.599] (II) intel(0): Manufacturer's mask: 0
[   163.599] (II) intel(0): Supported detailed timing:
[   163.599] (II) intel(0): clock: 69.3 MHz   Image Size:  261 x 163 mm
[   163.599] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1360 h=
_blank_end 1403 h_border: 0
[   163.599] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_bl=
anking: 821 v_border: 0
[   163.599] (II) intel(0): Supported detailed timing:
[   163.599] (II) intel(0): clock: 57.6 MHz   Image Size:  261 x 163 mm
[   163.599] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1360 h=
_blank_end 1403 h_border: 0
[   163.599] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_bl=
anking: 821 v_border: 0
[   163.599] (II) intel(0): Unknown vendor-specific block f
[   163.599] (II) intel(0):  B121EW09 V3
[   163.599] (II) intel(0): EDID (in hex):
[   163.599] (II) intel(0): 	00ffffffffffff0030ae114000000000
[   163.599] (II) intel(0): 	01130103801a1078ea65858f59588f26
[   163.599] (II) intel(0): 	1b505400000001010101010101010101
[   163.599] (II) intel(0): 	010101010101121b007b502015303020
[   163.599] (II) intel(0): 	360005a3100000187f16007b50201530
[   163.599] (II) intel(0): 	3020360005a3100000180000000f0081
[   163.599] (II) intel(0): 	0a3c810a3216090006af5633000000fe
[   163.599] (II) intel(0): 	004231323145573039205633200a009b
[   163.599] (II) intel(0): Not using default mode "320x240" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "400x300" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "400x300" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "512x384" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "640x480" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "640x512" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "800x600" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "896x672" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "928x696" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "960x720" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "700x525" (doublescan mo=
de not supported)
[   163.599] (II) intel(0): Not using default mode "1024x768" (doublescan m=
ode not supported)
[   163.599] (II) intel(0): Printing probed modes for output LVDS1
[   163.599] (II) intel(0): Modeline "1280x800"x60.2   69.30  1280 1328 136=
0 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   163.599] (II) intel(0): Modeline "1280x800"x50.0   57.59  1280 1328 136=
0 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   163.599] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 118=
4 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[   163.599] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 10=
56  600 601 605 628 +hsync +vsync (37.9 kHz)
[   163.599] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 10=
24  600 601 603 625 +hsync +vsync (35.2 kHz)
[   163.599] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 80=
0  480 490 492 525 -hsync -vsync (31.5 kHz)
[   163.815] (II) intel(0): EDID for output HDMI1
[   163.815] (II) intel(0): Manufacturer: ENC  Model: 1759  Serial#: 168430=
09
[   163.815] (II) intel(0): Year: 2005  Week: 53
[   163.815] (II) intel(0): EDID Version: 1.3
[   163.815] (II) intel(0): Digital Display Input
[   163.815] (II) intel(0): Max Image Size [cm]: horiz.: 41  vert.: 31
[   163.815] (II) intel(0): Gamma: 2.20
[   163.815] (II) intel(0): DPMS capabilities: StandBy Suspend Off
[   163.815] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:=
4=20
[   163.815] (II) intel(0): First detailed timing is preferred mode
[   163.815] (II) intel(0): redX: 0.644 redY: 0.337   greenX: 0.294 greenY:=
 0.604
[   163.815] (II) intel(0): blueX: 0.144 blueY: 0.093   whiteX: 0.313 white=
Y: 0.329
[   163.815] (II) intel(0): Supported established timings:
[   163.815] (II) intel(0): 720x400@70Hz
[   163.815] (II) intel(0): 640x480@60Hz
[   163.815] (II) intel(0): 800x600@60Hz
[   163.815] (II) intel(0): 1024x768@60Hz
[   163.815] (II) intel(0): Manufacturer's mask: 0
[   163.815] (II) intel(0): Supported standard timings:
[   163.815] (II) intel(0): #0: hsize: 1600  vsize 1200  refresh: 60  vid: =
16553
[   163.815] (II) intel(0): #1: hsize: 1280  vsize 1024  refresh: 60  vid: =
32897
[   163.815] (II) intel(0): Supported detailed timing:
[   163.815] (II) intel(0): clock: 162.0 MHz   Image Size:  408 x 306 mm
[   163.815] (II) intel(0): h_active: 1600  h_sync: 1664  h_sync_end 1856 h=
_blank_end 2160 h_border: 0
[   163.815] (II) intel(0): v_active: 1200  v_sync: 1201  v_sync_end 1204 v=
_blanking: 1250 v_border: 0
[   163.815] (II) intel(0): Serial No: 40156125
[   163.815] (II) intel(0): Ranges: V min: 59 V max: 61 Hz, H min: 31 H max=
: 76 kHz, PixClock max 170 MHz
[   163.815] (II) intel(0): Monitor name: L887
[   163.815] (II) intel(0): EDID (in hex):
[   163.815] (II) intel(0): 	00ffffffffffff0015c3591701010101
[   163.815] (II) intel(0): 	350f010380291f78ead6f5a4564b9a24
[   163.815] (II) intel(0): 	175054a10800a9408180010101010101
[   163.815] (II) intel(0): 	010101010101483f403062b0324040c0
[   163.815] (II) intel(0): 	130098321100001e000000ff00343031
[   163.815] (II) intel(0): 	35363132350a20202020000000fd003b
[   163.815] (II) intel(0): 	3d1f4c11000a202020202020000000fc
[   163.815] (II) intel(0): 	004c3838370a202020202020202000c4
[   163.815] (II) intel(0): Printing probed modes for output HDMI1
[   163.815] (II) intel(0): Modeline "1600x1200"x60.0  162.00  1600 1664 18=
56 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[   163.815] (II) intel(0): Modeline "1280x1024"x60.0  108.00  1280 1328 14=
40 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[   163.815] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 118=
4 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[   163.815] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 10=
56  600 601 605 628 +hsync +vsync (37.9 kHz)
[   163.815] (II) intel(0): Modeline "640x480"x60.0   25.20  640 656 752 80=
0  480 490 492 525 -hsync -vsync (31.5 kHz)
[   163.815] (II) intel(0): Modeline "720x400"x70.1   28.32  720 738 846 90=
0  400 412 414 449 -hsync +vsync (31.5 kHz)
[   163.820] (II) intel(0): EDID for output DP1
[   163.820] (II) intel(0): Output VGA1 disconnected
[   163.820] (II) intel(0): Output LVDS1 connected
[   163.820] (II) intel(0): Output HDMI1 connected
[   163.820] (II) intel(0): Output DP1 disconnected
[   163.820] (II) intel(0): Using fuzzy aspect match for initial modes
[   163.820] (II) intel(0): Output LVDS1 using initial mode 1024x768
[   163.820] (II) intel(0): Output HDMI1 using initial mode 1024x768
[   163.820] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless o=
therwise stated.
[   163.820] (II) intel(0): Pageflipping enabled in kernel, but disabled in=
 X
[   163.820] (II) intel(0): Don't panic: https://bugzilla.redhat.com/588421
[   163.820] (=3D=3D) intel(0): DPI set to (96, 96)
[   163.820] (II) Loading sub module "fb"
[   163.820] (II) LoadModule: "fb"
[   163.820] (II) Loading /usr/lib/xorg/modules/libfb.so
[   163.870] (II) Module fb: vendor=3D"X.Org Foundation"
[   163.870] 	compiled for 1.8.1.902, module version =3D 1.0.0
[   163.871] 	ABI class: X.Org ANSI C Emulation, version 0.4
[   163.871] (II) UnloadModule: "vesa"
[   163.871] (II) Unloading /usr/lib/xorg/modules/drivers/vesa_drv.so
[   163.871] (=3D=3D) Depth 24 pixmap format is 32 bpp
[   163.871] (II) intel(0): [DRI2] Setup complete
[   163.871] (II) intel(0): [DRI2]   DRI driver: i965
[   163.871] (**) intel(0): Tiling enabled
[   163.871] (**) intel(0): SwapBuffers wait enabled
[   163.871] (=3D=3D) intel(0): VideoRam: 262144 KB
[   163.871] (II) intel(0): Allocated new frame buffer 1024x768 stride 4096=
, tiled
[   163.882] (II) UXA(0): Driver registered support for the following opera=
tions:
[   163.882] (II)         solid
[   163.882] (II)         copy
[   163.882] (II)         composite (RENDER acceleration)
[   163.882] (II)         put_image
[   163.882] (II)         get_image
[   163.887] (=3D=3D) intel(0): Backing store disabled
[   163.887] (=3D=3D) intel(0): Silken mouse enabled
[   163.887] (II) intel(0): Initializing HW Cursor
[   164.448] (II) intel(0): RandR 1.2 enabled, ignore the following RandR d=
isabled message.
[   164.453] (=3D=3D) intel(0): DPMS enabled
[   164.453] (=3D=3D) intel(0): Intel XvMC decoder enabled
[   164.453] (II) intel(0): Set up textured video
[   164.453] (II) intel(0): [XvMC] xvmc_vld driver initialized.
[   164.453] (II) intel(0): direct rendering: DRI2 Enabled
[   164.453] (--) RandR disabled
[   164.453] (II) Initializing built-in extension Generic Event Extension
[   164.453] (II) Initializing built-in extension SHAPE
[   164.453] (II) Initializing built-in extension MIT-SHM
[   164.453] (II) Initializing built-in extension XInputExtension
[   164.453] (II) Initializing built-in extension XTEST
[   164.453] (II) Initializing built-in extension BIG-REQUESTS
[   164.453] (II) Initializing built-in extension SYNC
[   164.453] (II) Initializing built-in extension XKEYBOARD
[   164.453] (II) Initializing built-in extension XC-MISC
[   164.453] (II) Initializing built-in extension SECURITY
[   164.453] (II) Initializing built-in extension XINERAMA
[   164.453] (II) Initializing built-in extension XFIXES
[   164.453] (II) Initializing built-in extension RENDER
[   164.453] (II) Initializing built-in extension RANDR
[   164.453] (II) Initializing built-in extension COMPOSITE
[   164.453] (II) Initializing built-in extension DAMAGE
[   164.543] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[   164.544] (II) AIGLX: enabled GLX_INTEL_swap_event
[   164.544] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_con=
trol
[   164.544] (II) AIGLX: enabled GLX_SGI_make_current_read
[   164.544] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objec=
ts
[   164.544] (II) AIGLX: Loaded and initialized /usr/lib/xorg/modules/dri/i=
965_dri.so
[   164.544] (II) GLX: Initialized DRI2 GL provider for screen 0
[   164.544] (II) intel(0): Setting screen physical size to 270 x 203
[   165.066] (II) config/udev: Adding input device Power Button (/dev/input=
/event4)
[   165.066] (**) Power Button: Applying InputClass "evdev keyboard catchal=
l"
[   165.066] (II) LoadModule: "evdev"
[   165.066] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[   165.074] (II) Module evdev: vendor=3D"X.Org Foundation"
[   165.074] 	compiled for 1.8.0, module version =3D 2.4.0
[   165.074] 	Module class: X.Org XInput Driver
[   165.074] 	ABI class: X.Org XInput driver, version 9.0
[   165.074] (**) Power Button: always reports core events
[   165.074] (**) Power Button: Device: "/dev/input/event4"
[   165.100] (II) Power Button: Found keys
[   165.100] (II) Power Button: Configuring as keyboard
[   165.100] (II) XINPUT: Adding extended input device "Power Button" (type=
: KEYBOARD)
[   165.100] (**) Option "xkb_rules" "evdev"
[   165.100] (**) Option "xkb_model" "evdev"
[   165.100] (**) Option "xkb_layout" "us"
[   165.142] (II) config/udev: Adding input device Video Bus (/dev/input/ev=
ent7)
[   165.142] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[   165.142] (**) Video Bus: always reports core events
[   165.142] (**) Video Bus: Device: "/dev/input/event7"
[   165.163] (II) Video Bus: Found keys
[   165.163] (II) Video Bus: Configuring as keyboard
[   165.163] (II) XINPUT: Adding extended input device "Video Bus" (type: K=
EYBOARD)
[   165.163] (**) Option "xkb_rules" "evdev"
[   165.163] (**) Option "xkb_model" "evdev"
[   165.163] (**) Option "xkb_layout" "us"
[   165.164] (II) config/udev: Adding input device Lid Switch (/dev/input/e=
vent2)
[   165.164] (II) No input driver/identifier specified (ignoring)
[   165.164] (II) config/udev: Adding input device Sleep Button (/dev/input=
/event3)
[   165.164] (**) Sleep Button: Applying InputClass "evdev keyboard catchal=
l"
[   165.164] (**) Sleep Button: always reports core events
[   165.164] (**) Sleep Button: Device: "/dev/input/event3"
[   165.190] (II) Sleep Button: Found keys
[   165.190] (II) Sleep Button: Configuring as keyboard
[   165.190] (II) XINPUT: Adding extended input device "Sleep Button" (type=
: KEYBOARD)
[   165.190] (**) Option "xkb_rules" "evdev"
[   165.190] (**) Option "xkb_model" "evdev"
[   165.190] (**) Option "xkb_layout" "us"
[   165.191] (II) config/udev: Adding input device Integrated Camera (/dev/=
input/event8)
[   165.191] (**) Integrated Camera: Applying InputClass "evdev keyboard ca=
tchall"
[   165.191] (**) Integrated Camera: always reports core events
[   165.191] (**) Integrated Camera: Device: "/dev/input/event8"
[   165.216] (II) Integrated Camera: Found keys
[   165.216] (II) Integrated Camera: Configuring as keyboard
[   165.216] (II) XINPUT: Adding extended input device "Integrated Camera" =
(type: KEYBOARD)
[   165.216] (**) Option "xkb_rules" "evdev"
[   165.216] (**) Option "xkb_model" "evdev"
[   165.216] (**) Option "xkb_layout" "us"
[   165.219] (II) config/udev: Adding input device AT Translated Set 2 keyb=
oard (/dev/input/event0)
[   165.219] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev =
keyboard catchall"
[   165.219] (**) AT Translated Set 2 keyboard: always reports core events
[   165.219] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event0"
[   165.240] (II) AT Translated Set 2 keyboard: Found keys
[   165.240] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[   165.240] (II) XINPUT: Adding extended input device "AT Translated Set 2=
 keyboard" (type: KEYBOARD)
[   165.240] (**) Option "xkb_rules" "evdev"
[   165.240] (**) Option "xkb_model" "evdev"
[   165.240] (**) Option "xkb_layout" "us"
[   165.240] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event6)
[   165.240] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[   165.240] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[   165.240] (II) LoadModule: "synaptics"
[   165.240] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[   165.241] (II) Module synaptics: vendor=3D"X.Org Foundation"
[   165.241] 	compiled for 1.8.0.902, module version =3D 1.2.2
[   165.241] 	Module class: X.Org XInput Driver
[   165.241] 	ABI class: X.Org XInput driver, version 9.0
[   165.241] (II) Synaptics touchpad driver version 1.2.2
[   165.241] (**) Option "Device" "/dev/input/event6"
[   165.374] (II) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5472
[   165.374] (II) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4448
[   165.374] (II) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[   165.374] (II) SynPS/2 Synaptics TouchPad: finger width range 0 - 0
[   165.374] (II) SynPS/2 Synaptics TouchPad: buttons: left right
[   165.374] (**) Option "TapButton1" "1"
[   165.374] (**) Option "TapButton2" "2"
[   165.374] (**) Option "TapButton3" "3"
[   165.480] (--) SynPS/2 Synaptics TouchPad: touchpad found
[   165.480] (**) SynPS/2 Synaptics TouchPad: always reports core events
[   165.534] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[   165.534] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[   165.534] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 0
[   165.534] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[   165.534] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[   165.614] (--) SynPS/2 Synaptics TouchPad: touchpad found
[   165.614] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[   165.614] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[   165.614] (II) Synaptics touchpad driver version 1.2.2
[   167.140] SynPS/2 Synaptics TouchPad no synaptics event device found
[   167.140] (**) Option "Device" "/dev/input/mouse0"
[   167.167] (**) Option "TapButton1" "1"
[   167.167] (**) Option "TapButton2" "2"
[   167.167] (**) Option "TapButton3" "3"
[   167.187] Query no Synaptics: 6003C8
[   167.187] (--) SynPS/2 Synaptics TouchPad: no supported touchpad found
[   167.187] (EE) SynPS/2 Synaptics TouchPad Unable to query/initialize Syn=
aptics hardware.
[   167.230] (EE) PreInit failed for input device "SynPS/2 Synaptics TouchP=
ad"
[   167.230] (II) UnloadModule: "synaptics"
[   167.231] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event9)
[   167.231] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[   167.231] (**) TPPS/2 IBM TrackPoint: always reports core events
[   167.231] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event9"
[   167.257] (II) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[   167.257] (II) TPPS/2 IBM TrackPoint: Found relative axes
[   167.257] (II) TPPS/2 IBM TrackPoint: Found x and y relative axes
[   167.257] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[   167.257] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[   167.257] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[   167.257] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[   167.257] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[   167.257] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[   167.257] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[   167.257] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[   167.257] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[   167.257] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[   167.258] (II) No input driver/identifier specified (ignoring)
[   167.258] (II) config/udev: Adding input device PC Speaker (/dev/input/e=
vent1)
[   167.258] (II) No input driver/identifier specified (ignoring)
[   167.258] (II) config/udev: Adding input device ThinkPad Extra Buttons (=
/dev/input/event5)
[   167.258] (**) ThinkPad Extra Buttons: Applying InputClass "evdev keyboa=
rd catchall"
[   167.258] (**) ThinkPad Extra Buttons: always reports core events
[   167.258] (**) ThinkPad Extra Buttons: Device: "/dev/input/event5"
[   167.284] (II) ThinkPad Extra Buttons: Found keys
[   167.284] (II) ThinkPad Extra Buttons: Configuring as keyboard
[   167.284] (II) XINPUT: Adding extended input device "ThinkPad Extra Butt=
ons" (type: KEYBOARD)
[   167.284] (**) Option "xkb_rules" "evdev"
[   167.284] (**) Option "xkb_model" "evdev"
[   167.284] (**) Option "xkb_layout" "us"
[   181.435] (II) intel(0): EDID vendor "LEN", prod id 16401
[   181.435] (II) intel(0): Printing DDC gathered Modelines:
[   181.435] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   181.435] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   181.657] (II) intel(0): Allocated new frame buffer 1280x800 stride 5120=
, tiled
[   182.468] (II) intel(0): EDID vendor "LEN", prod id 16401
[   182.468] (II) intel(0): Printing DDC gathered Modelines:
[   182.468] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   182.468] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   182.690] (II) intel(0): Allocated new frame buffer 1600x2000 stride 665=
6, tiled
[   182.983] (II) intel(0): EDID vendor "LEN", prod id 16401
[   182.983] (II) intel(0): Printing DDC gathered Modelines:
[   182.983] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   182.983] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   183.332] (II) intel(0): EDID vendor "LEN", prod id 16401
[   183.332] (II) intel(0): Printing DDC gathered Modelines:
[   183.332] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   183.332] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   183.678] (II) intel(0): EDID vendor "LEN", prod id 16401
[   183.678] (II) intel(0): Printing DDC gathered Modelines:
[   183.678] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   183.678] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   184.026] (II) intel(0): EDID vendor "LEN", prod id 16401
[   184.026] (II) intel(0): Printing DDC gathered Modelines:
[   184.026] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   184.026] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   184.372] (II) intel(0): EDID vendor "LEN", prod id 16401
[   184.372] (II) intel(0): Printing DDC gathered Modelines:
[   184.372] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   184.372] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   184.717] (II) intel(0): EDID vendor "LEN", prod id 16401
[   184.717] (II) intel(0): Printing DDC gathered Modelines:
[   184.717] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   184.717] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   185.063] (II) intel(0): EDID vendor "LEN", prod id 16401
[   185.063] (II) intel(0): Printing DDC gathered Modelines:
[   185.063] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   185.063] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   185.413] (II) intel(0): EDID vendor "LEN", prod id 16401
[   185.413] (II) intel(0): Printing DDC gathered Modelines:
[   185.413] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   185.413] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[   185.759] (II) intel(0): EDID vendor "LEN", prod id 16401
[   185.759] (II) intel(0): Printing DDC gathered Modelines:
[   185.759] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[   185.759] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142808.819] (II) AIGLX: Suspending AIGLX clients for VT switch
[142813.329] (II) AIGLX: Resuming AIGLX clients after VT switch
[142813.506] (II) intel(0): EDID vendor "LEN", prod id 16401
[142813.506] (II) intel(0): Printing DDC gathered Modelines:
[142813.506] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142813.506] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142813.623] (--) SynPS/2 Synaptics TouchPad: touchpad found
[142851.339] (II) intel(0): EDID vendor "LEN", prod id 16401
[142851.339] (II) intel(0): Printing DDC gathered Modelines:
[142851.339] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142851.339] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142851.552] (II) intel(0): EDID vendor "LEN", prod id 16401
[142851.552] (II) intel(0): Printing DDC gathered Modelines:
[142851.552] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142851.552] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142851.890] (II) intel(0): Allocated new frame buffer 1280x800 stride 5120=
, tiled
[142852.234] (II) intel(0): EDID vendor "LEN", prod id 16401
[142852.234] (II) intel(0): Printing DDC gathered Modelines:
[142852.234] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142852.234] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142852.379] (II) intel(0): EDID vendor "LEN", prod id 16401
[142852.379] (II) intel(0): Printing DDC gathered Modelines:
[142852.379] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142852.379] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142852.556] (II) intel(0): EDID vendor "LEN", prod id 16401
[142852.556] (II) intel(0): Printing DDC gathered Modelines:
[142852.556] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142852.556] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142852.699] (II) intel(0): EDID vendor "LEN", prod id 16401
[142852.699] (II) intel(0): Printing DDC gathered Modelines:
[142852.699] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142852.699] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142852.843] (II) intel(0): EDID vendor "LEN", prod id 16401
[142852.843] (II) intel(0): Printing DDC gathered Modelines:
[142852.843] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142852.843] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142852.984] (II) intel(0): EDID vendor "LEN", prod id 16401
[142852.984] (II) intel(0): Printing DDC gathered Modelines:
[142852.984] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142852.984] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142853.124] (II) intel(0): EDID vendor "LEN", prod id 16401
[142853.124] (II) intel(0): Printing DDC gathered Modelines:
[142853.124] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142853.124] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142853.265] (II) intel(0): EDID vendor "LEN", prod id 16401
[142853.265] (II) intel(0): Printing DDC gathered Modelines:
[142853.265] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142853.265] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[142853.406] (II) intel(0): EDID vendor "LEN", prod id 16401
[142853.406] (II) intel(0): Printing DDC gathered Modelines:
[142853.406] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[142853.406] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[143408.819] (II) AIGLX: Suspending AIGLX clients for VT switch
[143413.357] (II) AIGLX: Resuming AIGLX clients after VT switch
[143413.526] (II) intel(0): EDID vendor "LEN", prod id 16401
[143413.526] (II) intel(0): Printing DDC gathered Modelines:
[143413.526] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[143413.526] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[143413.633] (--) SynPS/2 Synaptics TouchPad: touchpad found
[144224.309] (II) AIGLX: Suspending AIGLX clients for VT switch
[144228.917] (II) AIGLX: Resuming AIGLX clients after VT switch
[144229.064] (II) intel(0): EDID vendor "LEN", prod id 16401
[144229.064] (II) intel(0): Printing DDC gathered Modelines:
[144229.064] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[144229.064] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[144229.192] (--) SynPS/2 Synaptics TouchPad: touchpad found
[147014.462] (II) AIGLX: Suspending AIGLX clients for VT switch
[147019.030] (II) AIGLX: Resuming AIGLX clients after VT switch
[147019.266] (II) intel(0): EDID vendor "LEN", prod id 16401
[147019.266] (II) intel(0): Printing DDC gathered Modelines:
[147019.266] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[147019.266] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[147019.435] (--) SynPS/2 Synaptics TouchPad: touchpad found
[186162.601] (II) AIGLX: Suspending AIGLX clients for VT switch
[186167.248] (II) AIGLX: Resuming AIGLX clients after VT switch
[186167.404] (II) intel(0): EDID vendor "LEN", prod id 16401
[186167.404] (II) intel(0): Printing DDC gathered Modelines:
[186167.404] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[186167.404] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[186167.479] (--) SynPS/2 Synaptics TouchPad: touchpad found
[186544.002] (II) AIGLX: Suspending AIGLX clients for VT switch
[186548.582] (II) AIGLX: Resuming AIGLX clients after VT switch
[186548.734] (II) intel(0): EDID vendor "LEN", prod id 16401
[186548.734] (II) intel(0): Printing DDC gathered Modelines:
[186548.734] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[186548.734] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[186548.864] (--) SynPS/2 Synaptics TouchPad: touchpad found
[193994.131] (II) AIGLX: Suspending AIGLX clients for VT switch
[193998.799] (II) AIGLX: Resuming AIGLX clients after VT switch
[193998.954] (II) intel(0): EDID vendor "LEN", prod id 16401
[193998.954] (II) intel(0): Printing DDC gathered Modelines:
[193998.954] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[193998.954] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[193999.065] (--) SynPS/2 Synaptics TouchPad: touchpad found
[198001.779] (II) intel(0): EDID vendor "LEN", prod id 16401
[198001.779] (II) intel(0): Printing DDC gathered Modelines:
[198001.779] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198001.779] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198002.181] (II) intel(0): EDID vendor "LEN", prod id 16401
[198002.181] (II) intel(0): Printing DDC gathered Modelines:
[198002.181] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198002.181] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198002.541] (II) intel(0): Allocated new frame buffer 1600x2000 stride 665=
6, tiled
[198002.843] (II) intel(0): EDID vendor "LEN", prod id 16401
[198002.843] (II) intel(0): Printing DDC gathered Modelines:
[198002.843] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198002.856] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198003.202] (II) intel(0): EDID vendor "LEN", prod id 16401
[198003.203] (II) intel(0): Printing DDC gathered Modelines:
[198003.203] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198003.203] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198003.547] (II) intel(0): EDID vendor "LEN", prod id 16401
[198003.547] (II) intel(0): Printing DDC gathered Modelines:
[198003.547] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198003.547] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198003.891] (II) intel(0): EDID vendor "LEN", prod id 16401
[198003.891] (II) intel(0): Printing DDC gathered Modelines:
[198003.891] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198003.891] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198004.235] (II) intel(0): EDID vendor "LEN", prod id 16401
[198004.235] (II) intel(0): Printing DDC gathered Modelines:
[198004.235] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198004.235] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198004.576] (II) intel(0): EDID vendor "LEN", prod id 16401
[198004.576] (II) intel(0): Printing DDC gathered Modelines:
[198004.576] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198004.576] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198004.918] (II) intel(0): EDID vendor "LEN", prod id 16401
[198004.918] (II) intel(0): Printing DDC gathered Modelines:
[198004.918] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198004.918] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198005.262] (II) intel(0): EDID vendor "LEN", prod id 16401
[198005.262] (II) intel(0): Printing DDC gathered Modelines:
[198005.262] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198005.262] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[198005.607] (II) intel(0): EDID vendor "LEN", prod id 16401
[198005.607] (II) intel(0): Printing DDC gathered Modelines:
[198005.607] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[198005.607] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209379.285] (II) AIGLX: Suspending AIGLX clients for VT switch
[209383.948] (II) AIGLX: Resuming AIGLX clients after VT switch
[209384.118] (II) intel(0): EDID vendor "LEN", prod id 16401
[209384.118] (II) intel(0): Printing DDC gathered Modelines:
[209384.118] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209384.118] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209384.223] (--) SynPS/2 Synaptics TouchPad: touchpad found
[209391.542] (II) AIGLX: Suspending AIGLX clients for VT switch
[209392.940] (II) AIGLX: Resuming AIGLX clients after VT switch
[209393.108] (II) intel(0): EDID vendor "LEN", prod id 16401
[209393.108] (II) intel(0): Printing DDC gathered Modelines:
[209393.108] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209393.108] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209393.333] (--) SynPS/2 Synaptics TouchPad: touchpad found
[209405.532] (II) AIGLX: Suspending AIGLX clients for VT switch
[209448.953] (II) AIGLX: Resuming AIGLX clients after VT switch
[209449.121] (II) intel(0): EDID vendor "LEN", prod id 16401
[209449.121] (II) intel(0): Printing DDC gathered Modelines:
[209449.121] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209449.121] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209449.335] (--) SynPS/2 Synaptics TouchPad: touchpad found
[209500.248] (II) intel(0): EDID vendor "LEN", prod id 16401
[209500.248] (II) intel(0): Printing DDC gathered Modelines:
[209500.248] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209500.248] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209500.387] (II) intel(0): EDID vendor "LEN", prod id 16401
[209500.387] (II) intel(0): Printing DDC gathered Modelines:
[209500.387] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209500.387] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209500.730] (II) intel(0): Allocated new frame buffer 1280x800 stride 5120=
, tiled
[209501.113] (II) intel(0): EDID vendor "LEN", prod id 16401
[209501.113] (II) intel(0): Printing DDC gathered Modelines:
[209501.113] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209501.113] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209501.258] (II) intel(0): EDID vendor "LEN", prod id 16401
[209501.258] (II) intel(0): Printing DDC gathered Modelines:
[209501.258] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209501.258] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209501.431] (II) intel(0): EDID vendor "LEN", prod id 16401
[209501.431] (II) intel(0): Printing DDC gathered Modelines:
[209501.431] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209501.431] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209501.570] (II) intel(0): EDID vendor "LEN", prod id 16401
[209501.570] (II) intel(0): Printing DDC gathered Modelines:
[209501.570] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209501.570] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209501.709] (II) intel(0): EDID vendor "LEN", prod id 16401
[209501.709] (II) intel(0): Printing DDC gathered Modelines:
[209501.709] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209501.709] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209501.848] (II) intel(0): EDID vendor "LEN", prod id 16401
[209501.848] (II) intel(0): Printing DDC gathered Modelines:
[209501.848] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209501.848] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209501.987] (II) intel(0): EDID vendor "LEN", prod id 16401
[209501.987] (II) intel(0): Printing DDC gathered Modelines:
[209501.987] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209501.987] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209502.126] (II) intel(0): EDID vendor "LEN", prod id 16401
[209502.126] (II) intel(0): Printing DDC gathered Modelines:
[209502.126] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209502.126] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209502.265] (II) intel(0): EDID vendor "LEN", prod id 16401
[209502.265] (II) intel(0): Printing DDC gathered Modelines:
[209502.265] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209502.265] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209696.659] (II) AIGLX: Suspending AIGLX clients for VT switch
[209701.352] (II) AIGLX: Resuming AIGLX clients after VT switch
[209701.501] (II) intel(0): EDID vendor "LEN", prod id 16401
[209701.501] (II) intel(0): Printing DDC gathered Modelines:
[209701.501] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209701.501] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209701.603] (--) SynPS/2 Synaptics TouchPad: touchpad found
[209708.156] (II) AIGLX: Suspending AIGLX clients for VT switch
[209711.861] (II) AIGLX: Resuming AIGLX clients after VT switch
[209712.004] (II) intel(0): EDID vendor "LEN", prod id 16401
[209712.004] (II) intel(0): Printing DDC gathered Modelines:
[209712.004] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209712.004] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209712.232] (--) SynPS/2 Synaptics TouchPad: touchpad found
[209717.473] (II) AIGLX: Suspending AIGLX clients for VT switch
[209725.056] (II) AIGLX: Resuming AIGLX clients after VT switch
[209725.201] (II) intel(0): EDID vendor "LEN", prod id 16401
[209725.201] (II) intel(0): Printing DDC gathered Modelines:
[209725.201] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[209725.201] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[209725.442] (--) SynPS/2 Synaptics TouchPad: touchpad found
[211520.860] (II) AIGLX: Suspending AIGLX clients for VT switch
[211525.595] (II) AIGLX: Resuming AIGLX clients after VT switch
[211525.747] (II) intel(0): EDID vendor "LEN", prod id 16401
[211525.747] (II) intel(0): Printing DDC gathered Modelines:
[211525.747] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[211525.747] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[211525.843] (--) SynPS/2 Synaptics TouchPad: touchpad found
[211622.443] (II) AIGLX: Suspending AIGLX clients for VT switch
[211627.126] (II) AIGLX: Resuming AIGLX clients after VT switch
[211627.280] (II) intel(0): EDID vendor "LEN", prod id 16401
[211627.280] (II) intel(0): Printing DDC gathered Modelines:
[211627.280] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[211627.280] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[211627.376] (--) SynPS/2 Synaptics TouchPad: touchpad found
[247614.150] (II) AIGLX: Suspending AIGLX clients for VT switch
[247619.135] (II) AIGLX: Resuming AIGLX clients after VT switch
[247619.284] (II) intel(0): EDID vendor "LEN", prod id 16401
[247619.364] (II) intel(0): Printing DDC gathered Modelines:
[247619.364] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[247619.364] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[247619.532] (--) SynPS/2 Synaptics TouchPad: touchpad found
[248419.196] (II) intel(0): EDID vendor "LEN", prod id 16401
[248419.196] (II) intel(0): Printing DDC gathered Modelines:
[248419.196] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248419.196] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248419.590] (II) intel(0): EDID vendor "LEN", prod id 16401
[248419.590] (II) intel(0): Printing DDC gathered Modelines:
[248419.590] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248419.590] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248419.807] (II) intel(0): Allocated new frame buffer 1600x2000 stride 665=
6, tiled
[248420.142] (II) intel(0): EDID vendor "LEN", prod id 16401
[248420.142] (II) intel(0): Printing DDC gathered Modelines:
[248420.142] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248420.142] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248420.486] (II) intel(0): EDID vendor "LEN", prod id 16401
[248420.486] (II) intel(0): Printing DDC gathered Modelines:
[248420.486] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248420.486] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248420.830] (II) intel(0): EDID vendor "LEN", prod id 16401
[248420.830] (II) intel(0): Printing DDC gathered Modelines:
[248420.830] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248420.830] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248421.173] (II) intel(0): EDID vendor "LEN", prod id 16401
[248421.173] (II) intel(0): Printing DDC gathered Modelines:
[248421.173] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248421.173] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248421.516] (II) intel(0): EDID vendor "LEN", prod id 16401
[248421.516] (II) intel(0): Printing DDC gathered Modelines:
[248421.516] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248421.516] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248421.856] (II) intel(0): EDID vendor "LEN", prod id 16401
[248421.856] (II) intel(0): Printing DDC gathered Modelines:
[248421.856] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248421.856] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248422.198] (II) intel(0): EDID vendor "LEN", prod id 16401
[248422.198] (II) intel(0): Printing DDC gathered Modelines:
[248422.198] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248422.198] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248422.541] (II) intel(0): EDID vendor "LEN", prod id 16401
[248422.541] (II) intel(0): Printing DDC gathered Modelines:
[248422.541] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248422.541] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[248422.884] (II) intel(0): EDID vendor "LEN", prod id 16401
[248422.884] (II) intel(0): Printing DDC gathered Modelines:
[248422.884] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[248422.884] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[264454.485] (EE) Error loading keymap /tmp/server-0.xkm
[281977.105] (II) AIGLX: Suspending AIGLX clients for VT switch
[281982.400] (II) AIGLX: Resuming AIGLX clients after VT switch
[281982.718] (II) intel(0): EDID vendor "LEN", prod id 16401
[281982.736] (II) intel(0): Printing DDC gathered Modelines:
[281982.736] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[281982.736] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[281983.345] (--) SynPS/2 Synaptics TouchPad: touchpad found
[300372.563] (II) AIGLX: Suspending AIGLX clients for VT switch
[300377.186] (II) AIGLX: Resuming AIGLX clients after VT switch
[300377.472] (II) intel(0): EDID vendor "LEN", prod id 16401
[300377.472] (II) intel(0): Printing DDC gathered Modelines:
[300377.472] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[300377.472] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[300377.803] (--) SynPS/2 Synaptics TouchPad: touchpad found
[303017.144] (II) AIGLX: Suspending AIGLX clients for VT switch
[303021.804] (II) AIGLX: Resuming AIGLX clients after VT switch
[303022.007] (II) intel(0): EDID vendor "LEN", prod id 16401
[303022.007] (II) intel(0): Printing DDC gathered Modelines:
[303022.007] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[303022.007] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[303022.114] (--) SynPS/2 Synaptics TouchPad: touchpad found
[303037.583] (II) AIGLX: Suspending AIGLX clients for VT switch
[303041.701] (II) AIGLX: Resuming AIGLX clients after VT switch
[303041.868] (II) intel(0): EDID vendor "LEN", prod id 16401
[303041.868] (II) intel(0): Printing DDC gathered Modelines:
[303041.868] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[303041.868] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[303042.096] (--) SynPS/2 Synaptics TouchPad: touchpad found
[303974.474] (II) AIGLX: Suspending AIGLX clients for VT switch
[303979.104] (II) AIGLX: Resuming AIGLX clients after VT switch
[303979.371] (II) intel(0): EDID vendor "LEN", prod id 16401
[303979.371] (II) intel(0): Printing DDC gathered Modelines:
[303979.371] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[303979.371] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[303979.499] (--) SynPS/2 Synaptics TouchPad: touchpad found
[303979.719] (WW) intel(0): get vblank counter failed: Invalid argument
[303979.751] (WW) intel(0): get vblank counter failed: Invalid argument
[303979.751] (WW) intel(0): first get vblank counter failed: Invalid argume=
nt
[303980.587] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303983.273] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303983.595] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303983.843] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303983.843] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303984.096] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303984.096] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303984.096] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303984.097] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303984.097] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303984.346] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303984.346] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303984.596] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303984.596] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303984.597] (WW) intel(0): get vblank counter failed: Invalid argument
[303984.846] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303984.846] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303985.356] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.357] (WW) intel(0): get vblank counter failed: Invalid argument
[303985.357] (WW) intel(0): first get vblank counter failed: Invalid argume=
nt
[303985.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303985.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303985.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.857] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.857] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.857] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303985.857] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303986.129] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303986.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303987.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303987.396] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303987.649] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303987.899] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303987.899] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303988.149] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303988.149] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303988.649] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303988.649] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303988.899] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303988.899] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303989.149] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303989.149] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303989.399] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303989.399] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303989.649] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303989.649] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303989.899] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303989.899] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303990.149] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303990.149] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303990.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303990.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303990.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303990.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303990.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303990.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303991.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303991.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303991.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303991.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303991.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303991.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303991.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303992.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303992.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303992.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303992.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303992.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303992.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303992.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303993.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303993.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303993.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303993.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303993.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303993.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303993.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303994.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303994.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303994.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303994.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303994.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303994.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303995.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303995.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303995.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303995.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303995.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303995.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303995.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303996.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303996.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303996.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303996.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303996.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303996.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303996.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303996.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303997.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303997.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303997.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303997.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303997.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303997.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303997.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303997.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303998.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303998.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303998.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303998.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303998.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303998.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303998.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303999.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303999.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303999.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303999.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303999.653] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303999.653] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[303999.903] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[303999.903] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304000.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.154] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.157] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.158] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.159] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.160] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.161] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.162] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.163] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.676] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304000.676] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304000.927] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304000.927] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304001.176] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304001.176] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304001.426] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304001.426] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304001.676] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304001.676] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304001.926] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304001.926] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304002.176] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304002.176] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304002.426] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304002.426] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304002.676] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304002.676] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304002.930] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304002.930] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304003.930] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304003.931] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304004.179] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304004.180] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304004.429] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304004.429] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304004.679] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304004.679] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304004.929] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304004.929] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304005.179] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304005.180] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304005.429] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304005.429] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304005.679] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304005.680] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304005.929] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304005.929] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304006.179] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304006.180] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304006.429] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304006.429] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304006.679] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304007.929] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304008.929] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304008.929] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304009.179] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304009.180] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304009.429] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304009.679] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304009.679] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304009.679] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304009.679] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304009.929] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304009.930] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304010.179] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304010.179] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304010.429] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304010.429] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304010.679] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304010.679] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304010.929] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304010.929] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304010.929] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.179] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304011.179] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.429] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304011.429] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.683] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304011.683] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304011.933] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304012.206] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304012.206] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304012.884] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304012.884] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304012.884] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304012.884] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304013.133] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304013.383] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304013.633] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304013.883] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304013.883] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304014.133] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304014.133] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304014.383] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304014.633] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304014.633] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304014.883] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304015.133] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304015.133] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304015.383] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304015.383] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304015.633] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304015.633] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304015.883] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304015.883] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304016.133] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304016.133] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304016.383] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304016.383] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304016.633] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304016.633] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304016.883] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304016.883] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.133] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304017.133] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.383] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304017.383] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.383] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.387] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.387] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.387] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.387] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.387] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.387] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.387] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.388] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304017.636] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304017.886] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304018.136] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304018.136] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304018.386] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304018.636] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304018.886] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304019.136] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304019.136] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.136] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.137] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.138] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.139] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304019.869] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304019.869] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304020.150] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304020.150] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304020.426] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304020.427] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304020.713] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304020.963] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304021.213] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304021.463] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304021.713] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304021.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.963] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304021.963] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.963] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.964] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.964] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.964] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.964] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.964] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.965] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.966] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.967] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.967] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.967] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.967] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.968] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.968] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304021.968] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304022.233] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304022.233] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304022.940] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304023.216] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304023.217] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304024.203] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304024.203] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304024.453] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304024.703] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304024.703] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304024.953] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304024.953] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304025.203] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304025.203] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304025.453] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304025.453] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304025.703] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304025.703] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304025.953] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304025.953] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304026.203] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304026.453] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304026.453] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304026.703] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304026.703] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304026.953] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304026.953] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304027.203] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304027.203] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304027.453] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304027.453] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304027.703] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304027.703] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304027.953] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304028.453] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304028.453] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304028.753] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304028.753] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304029.003] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304029.003] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304029.253] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304029.253] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304029.556] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304029.556] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304029.806] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304029.807] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.056] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.057] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.058] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.059] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304030.060] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304031.039] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304031.039] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304031.316] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304031.593] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304031.593] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304031.593] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304031.593] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304031.593] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304031.593] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304031.593] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304032.589] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304032.590] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304033.066] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304033.316] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304033.566] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304033.816] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304034.316] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304034.566] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304034.816] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304035.066] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304035.316] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304035.566] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304035.816] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304036.066] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304036.316] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304036.566] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304036.816] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304037.066] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304037.316] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304037.566] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304037.816] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304037.816] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304038.066] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304038.316] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304038.317] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304038.566] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304038.566] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304038.846] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304039.096] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304039.096] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304039.346] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304039.596] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304039.596] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304039.846] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304039.846] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304040.096] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304040.096] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304040.349] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304040.349] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304040.600] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304040.853] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304040.853] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.103] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304041.103] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304041.356] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304041.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304041.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304041.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304042.106] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304042.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304042.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304042.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304043.106] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304043.106] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304043.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304043.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304043.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304043.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304043.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304044.106] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304044.107] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304044.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304044.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304044.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304044.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304045.106] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304045.106] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304045.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304045.356] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304045.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304045.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304045.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304045.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304046.106] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304046.106] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304046.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304046.357] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304046.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304046.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304046.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304046.856] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.106] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304047.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304047.356] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304047.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.606] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304047.856] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304048.106] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304048.356] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304048.606] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304048.863] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304048.863] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304049.673] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304050.550] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304050.800] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304051.050] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304051.300] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304051.550] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304051.800] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304052.050] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304052.306] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304052.556] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304052.806] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304053.056] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304053.306] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304053.556] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304053.806] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304054.056] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304054.310] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304054.810] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304055.060] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304055.310] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304055.560] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304055.810] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304056.060] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304056.310] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304056.560] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304056.810] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304057.060] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304057.311] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304057.560] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304057.810] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304058.060] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304058.310] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304058.560] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304058.810] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304059.060] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304059.310] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304059.560] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304059.810] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304060.060] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304060.310] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304060.560] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304060.810] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304061.060] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304061.310] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304061.560] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304061.843] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304062.450] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304062.700] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304062.950] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304063.200] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304063.450] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304063.700] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304063.950] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304064.200] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304064.453] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304064.703] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304064.953] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304065.203] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304065.453] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304065.703] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304065.953] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304066.203] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304066.456] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304066.706] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304066.956] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304067.206] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304067.456] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304067.706] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304067.706] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.706] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.706] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.706] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.706] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.706] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.707] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.708] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.708] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.708] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.708] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.708] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.709] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.710] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.711] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.712] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.713] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304067.714] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304068.313] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304068.563] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304068.813] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304069.063] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304069.313] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304069.563] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304069.813] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304070.063] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304070.313] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304070.563] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304070.813] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304071.063] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304071.313] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304071.563] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304071.813] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304072.063] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304072.313] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304072.563] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304072.813] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304073.063] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304073.313] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304073.563] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304074.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304074.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304074.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304074.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304075.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304075.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304075.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304075.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304077.333] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304077.333] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304078.346] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304079.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304079.397] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304079.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304079.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304080.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304080.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304080.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304080.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304081.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304081.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304081.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304081.646] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.646] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.646] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.647] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.647] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.647] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.647] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304081.647] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304083.006] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304083.006] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304083.007] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304083.007] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304083.007] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304083.007] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.023] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304084.273] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304084.273] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.523] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304084.523] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.776] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304084.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304084.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304085.026] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304085.276] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304085.276] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304085.526] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304085.776] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304086.026] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304086.276] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304086.526] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304086.776] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304087.026] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304087.276] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304087.526] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304087.776] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304087.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304087.776] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304087.777] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304087.777] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304087.777] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304087.777] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304087.777] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304087.777] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304088.287] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304088.536] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304088.786] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304089.036] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304089.286] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304089.536] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304089.786] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304089.786] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304089.786] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304090.036] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304090.286] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304090.536] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304090.786] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304091.036] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304091.286] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304091.536] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304091.786] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304092.036] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304092.286] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304092.536] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304092.786] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304093.036] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304093.286] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304093.536] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304093.786] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304094.036] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304094.036] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.036] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.037] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.038] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.038] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.039] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.039] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.039] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.289] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304094.289] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.539] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304094.539] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.789] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304094.789] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304094.790] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.039] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304095.039] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.040] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.041] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.041] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.041] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.041] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.041] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.041] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.041] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.289] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304095.289] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.290] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.290] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.291] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.292] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304095.543] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304095.796] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304096.046] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304096.296] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304096.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304096.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304096.297] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304096.546] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304096.547] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304096.547] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304096.796] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304096.796] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.046] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304097.046] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.296] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304097.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.297] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.297] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.546] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304097.546] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.547] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.796] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304097.796] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.796] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304097.797] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304098.046] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304098.046] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304098.046] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304098.047] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304098.296] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304098.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304098.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304098.296] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304098.297] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304099.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304099.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304099.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304099.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304099.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304099.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304100.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304100.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304100.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304100.646] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304100.647] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304100.647] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304104.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304104.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304104.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304104.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304104.396] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304104.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304104.646] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304104.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304104.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304105.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304105.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304105.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304105.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304109.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304109.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304109.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304109.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304109.396] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304109.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304109.646] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304109.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304109.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304110.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304110.146] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304110.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304110.396] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304110.396] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304110.396] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.939] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304112.939] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.940] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.943] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.944] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.945] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304112.946] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304113.209] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304114.143] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304114.143] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304114.144] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304114.144] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304114.393] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304114.643] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304114.893] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304115.143] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304115.393] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304115.643] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304116.143] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304116.393] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304116.643] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304116.893] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304116.893] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304116.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304116.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304116.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304116.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304116.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304117.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304117.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304117.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304117.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304117.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304117.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304117.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304117.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304117.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304118.147] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304118.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304118.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304118.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304119.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304119.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304119.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304119.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304120.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304120.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304120.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304120.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304121.147] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304121.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304121.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304121.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304122.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304122.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304122.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304122.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304123.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304123.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304124.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304124.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304124.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304124.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304125.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304125.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304125.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304125.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304126.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304126.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304126.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304126.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304127.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304127.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304127.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304127.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304128.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304128.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304128.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304128.897] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304129.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304129.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304129.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304129.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304130.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304130.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304130.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304130.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304131.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304131.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304131.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304131.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304132.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304132.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304132.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304132.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304133.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304133.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304133.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304133.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304134.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304134.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304134.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304134.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304135.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304135.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304135.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304135.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304136.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304136.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304136.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304136.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304137.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304137.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304137.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304137.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304138.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304138.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304138.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304138.897] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304139.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304139.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304139.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304139.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304140.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304140.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304140.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304140.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304141.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304141.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304141.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304141.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304142.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304142.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304142.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304142.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304143.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304143.396] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304143.646] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304143.896] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304144.146] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304144.400] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304144.650] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304144.900] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304145.153] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304145.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.153] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.403] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304145.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.403] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.404] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.404] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.404] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.405] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.405] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.405] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.405] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.405] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.406] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.407] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.408] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.409] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[304145.659] (WW) intel(0): i830_uxa_prepare_access: gtt bo map failed: Inp=
ut/output error
[304147.812] (II) Power Button: Close
[304148.097] (II) UnloadModule: "evdev"
[304148.206] (II) Video Bus: Close
[304148.206] (II) UnloadModule: "evdev"
[304148.232] (II) Sleep Button: Close
[304148.233] (II) UnloadModule: "evdev"
[304148.259] (II) Integrated Camera: Close
[304148.259] (II) UnloadModule: "evdev"
[304148.286] (II) AT Translated Set 2 keyboard: Close
[304148.286] (II) UnloadModule: "evdev"
[304148.392] (II) UnloadModule: "synaptics"
[304148.446] (II) TPPS/2 IBM TrackPoint: Close
[304148.446] (II) UnloadModule: "evdev"
[304148.472] (II) ThinkPad Extra Buttons: Close
[304148.557] (II) UnloadModule: "evdev"

--da4uJneut+ArUgXk--

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyEqyUACgkQ19zI5DGHffDaggCgqnDSVG+NRYRZg6RbG2wVHGJo
xTsAniHl3KH9FmpeTJANkmG443bHmECX
=sQnO
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
