Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0I1L6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 07:58:39 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:60020 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0I1L6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 07:58:36 -0400
Date: Tue, 28 Sep 2010 13:59:52 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        peterz@infradead.org, flo@xssn.at, lenb@kernel.org,
        jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: 2.6.36-rc3-00464-g84e1d83 resume issue (was: [tip:sched/urgent]
 x86, tsc: Fix a preemption leak in restore_sched_clock_state())
Message-ID: <20100928115952.GD2822@ethz.ch>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	Jeff Chua <jeff.chua.linux@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
	peterz@infradead.org, flo@xssn.at, lenb@kernel.org,
	jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
	tglx@linutronix.de, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
References: <1284150773.402.122.camel@laptop>
 <tip-55496c896b8a695140045099d4e0175cf09d4eae@git.kernel.org>
 <20100913074233.GA2674@schottelius.org>
 <20100913084619.GC23741@elte.hu>
 <AANLkTikN5AxqmdHhkkrE9SmhaMxkFjRXnOSguyeJDtXM@mail.gmail.com>
 <20100915080326.GB2666@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <20100915080326.GB2666@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.36-rc3-00464-g84e1d83 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: multipart/mixed; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again,

after

 10:06:52 up 3 days, 21:01,  3 users,  load average: 1.81, 1.68, 1.65

the screen in xorg is black after resume, about 20 suspend & resume
cycles.

Good news: Both xorg and the kernel detected the problem (logs attached).

Rebooting to 2.6.36-rc4-00076-g9c03f16 now.

Cheers,

Nico



--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log.2.6.36-rc3-00464-g84e1d83"
Content-Transfer-Encoding: quoted-printable

[    32.332]=20
This is a pre-release version of the X server from The X.Org Foundation.
It is not supported in any way.
Bugs may be filed in the bugzilla at http://bugs.freedesktop.org/.
Select the "xorg" product for bugs you find in this release.
Before reporting bugs in pre-release versions please check the
latest version in the X.Org Foundation git repository.
See http://wiki.x.org/wiki/GitPage for git access instructions.
[    32.333]=20
X.Org X Server 1.8.1.902 (1.8.2 RC 2)
Release Date: 2010-06-21
[    32.334] X Protocol Version 11, Revision 0
[    32.334] Build Operating System: Linux 2.6.34-ARCH x86_64=20
[    32.334] Current Operating System: Linux kr 2.6.36-rc3-00464-g84e1d83 #=
40 SMP PREEMPT Sun Sep 12 11:34:26 CEST 2010 x86_64
[    32.335] Kernel command line:=20
[    32.335] Build Date: 21 June 2010  12:01:49PM
[    32.335] =20
[    32.335] Current version of pixman: 0.18.4
[    32.335] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    32.336] Markers: (--) probed, (**) from config file, (=3D=3D) default =
setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    32.337] (=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Sun Sep 12 13:=
05:37 2010
[    32.364] (=3D=3D) Using config directory: "/etc/X11/xorg.conf.d"
[    32.377] (=3D=3D) No Layout section.  Using the first Screen section.
[    32.377] (=3D=3D) No screen section available. Using defaults.
[    32.377] (**) |-->Screen "Default Screen Section" (0)
[    32.377] (**) |   |-->Monitor "<default monitor>"
[    32.377] (=3D=3D) No monitor specified for screen "Default Screen Secti=
on".
	Using a default monitor configuration.
[    32.377] (=3D=3D) Automatically adding devices
[    32.377] (=3D=3D) Automatically enabling devices
[    32.447] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[    32.447] 	Entry deleted from font path.
[    32.503] (=3D=3D) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/,
	/usr/share/fonts/100dpi/,
	/usr/share/fonts/75dpi/
[    32.503] (=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
[    32.503] (II) The server relies on udev to provide the list of input de=
vices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    32.503] (II) Loader magic: 0x7ce880
[    32.503] (II) Module ABI versions:
[    32.503] 	X.Org ANSI C Emulation: 0.4
[    32.503] 	X.Org Video Driver: 7.0
[    32.503] 	X.Org XInput driver : 9.0
[    32.503] 	X.Org Server Extension : 3.0
[    32.514] (--) PCI:*(0:0:2:0) 8086:0046:17aa:215a Intel Corporation Core=
 Processor Integrated Graphics Controller rev 2, Mem @ 0xf2000000/4194304, =
0xd0000000/268435456, I/O @ 0x00001800/8
[    32.515] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or=
 directory)
[    32.515] (II) LoadModule: "extmod"
[    32.553] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    32.561] (II) Module extmod: vendor=3D"X.Org Foundation"
[    32.561] 	compiled for 1.8.1.902, module version =3D 1.0.0
[    32.561] 	Module class: X.Org Server Extension
[    32.561] 	ABI class: X.Org Server Extension, version 3.0
[    32.561] (II) Loading extension MIT-SCREEN-SAVER
[    32.561] (II) Loading extension XFree86-VidModeExtension
[    32.561] (II) Loading extension XFree86-DGA
[    32.561] (II) Loading extension DPMS
[    32.561] (II) Loading extension XVideo
[    32.561] (II) Loading extension XVideo-MotionCompensation
[    32.561] (II) Loading extension X-Resource
[    32.561] (II) LoadModule: "dbe"
[    32.561] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    32.571] (II) Module dbe: vendor=3D"X.Org Foundation"
[    32.571] 	compiled for 1.8.1.902, module version =3D 1.0.0
[    32.571] 	Module class: X.Org Server Extension
[    32.571] 	ABI class: X.Org Server Extension, version 3.0
[    32.571] (II) Loading extension DOUBLE-BUFFER
[    32.571] (II) LoadModule: "glx"
[    32.571] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    32.577] (II) Module glx: vendor=3D"X.Org Foundation"
[    32.577] 	compiled for 1.8.1.902, module version =3D 1.0.0
[    32.577] 	ABI class: X.Org Server Extension, version 3.0
[    32.577] (=3D=3D) AIGLX enabled
[    32.577] (II) Loading extension GLX
[    32.578] (II) LoadModule: "record"
[    32.578] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    32.579] (II) Module record: vendor=3D"X.Org Foundation"
[    32.579] 	compiled for 1.8.1.902, module version =3D 1.13.0
[    32.579] 	Module class: X.Org Server Extension
[    32.579] 	ABI class: X.Org Server Extension, version 3.0
[    32.579] (II) Loading extension RECORD
[    32.579] (II) LoadModule: "dri"
[    32.579] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    32.601] (II) Module dri: vendor=3D"X.Org Foundation"
[    32.601] 	compiled for 1.8.1.902, module version =3D 1.0.0
[    32.601] 	ABI class: X.Org Server Extension, version 3.0
[    32.601] (II) Loading extension XFree86-DRI
[    32.601] (II) LoadModule: "dri2"
[    32.601] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    32.602] (II) Module dri2: vendor=3D"X.Org Foundation"
[    32.602] 	compiled for 1.8.1.902, module version =3D 1.2.0
[    32.602] 	ABI class: X.Org Server Extension, version 3.0
[    32.602] (II) Loading extension DRI2
[    32.602] (=3D=3D) Matched intel as autoconfigured driver 0
[    32.602] (=3D=3D) Matched vesa as autoconfigured driver 1
[    32.602] (=3D=3D) Matched fbdev as autoconfigured driver 2
[    32.602] (=3D=3D) Assigned the driver to the xf86ConfigLayout
[    32.602] (II) LoadModule: "intel"
[    32.603] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    32.646] (II) Module intel: vendor=3D"X.Org Foundation"
[    32.646] 	compiled for 1.8.1.902, module version =3D 2.12.0
[    32.646] 	Module class: X.Org Video Driver
[    32.646] 	ABI class: X.Org Video Driver, version 7.0
[    32.646] (II) LoadModule: "vesa"
[    32.647] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    32.652] (II) Module vesa: vendor=3D"X.Org Foundation"
[    32.652] 	compiled for 1.8.0, module version =3D 2.3.0
[    32.652] 	Module class: X.Org Video Driver
[    32.652] 	ABI class: X.Org Video Driver, version 7.0
[    32.652] (II) LoadModule: "fbdev"
[    32.676] (WW) Warning, couldn't open module fbdev
[    32.676] (II) UnloadModule: "fbdev"
[    32.676] (EE) Failed to load module "fbdev" (module does not exist, 0)
[    32.677] (II) intel: Driver for Intel Integrated Graphics Chipsets: i81=
0,
	i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, Clarkdale, Arrandale
[    32.677] (II) VESA: driver for VESA chipsets: vesa
[    32.677] (--) using VT number 7

[    32.682] (II) Primary Device is: PCI 00@00:02:0
[    32.682] (WW) Falling back to old probe method for vesa
[    33.467] drmOpenDevice: node name is /dev/dri/card0
[    33.467] drmOpenDevice: open result is 8, (OK)
[    33.572] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    33.572] drmOpenDevice: node name is /dev/dri/card0
[    33.572] drmOpenDevice: open result is 8, (OK)
[    33.572] drmOpenByBusid: drmOpenMinor returns 8
[    33.572] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    33.572] (II) intel(0): Creating default Display subsection in Screen s=
ection
	"Default Screen Section" for depth/fbbpp 24/32
[    33.572] (=3D=3D) intel(0): Depth 24, (--) framebuffer bpp 32
[    33.572] (=3D=3D) intel(0): RGB weight 888
[    33.572] (=3D=3D) intel(0): Default visual is TrueColor
[    33.572] (II) intel(0): Integrated Graphics Chipset: Intel(R) Arrandale
[    33.572] (--) intel(0): Chipset: "Arrandale"
[    33.572] (=3D=3D) intel(0): video overlay key set to 0x101fe
[    33.698] (II) intel(0): Output LVDS1 has no monitor section
[    33.698] (II) intel(0): found backlight control interface /sys/class/ba=
cklight/acpi_video0
[    33.748] (II) intel(0): Output VGA1 has no monitor section
[    33.786] (II) intel(0): Output HDMI1 has no monitor section
[    33.787] (II) intel(0): Output DP1 has no monitor section
[    33.913] (II) intel(0): EDID for output LVDS1
[    33.913] (II) intel(0): Manufacturer: LEN  Model: 4011  Serial#: 0
[    33.913] (II) intel(0): Year: 2009  Week: 1
[    33.913] (II) intel(0): EDID Version: 1.3
[    33.913] (II) intel(0): Digital Display Input
[    33.913] (II) intel(0): Max Image Size [cm]: horiz.: 26  vert.: 16
[    33.913] (II) intel(0): Gamma: 2.20
[    33.913] (II) intel(0): DPMS capabilities: StandBy Suspend Off
[    33.913] (II) intel(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:=
4=20
[    33.913] (II) intel(0): First detailed timing is preferred mode
[    33.913] (II) intel(0): redX: 0.560 redY: 0.350   greenX: 0.345 greenY:=
 0.560
[    33.913] (II) intel(0): blueX: 0.150 blueY: 0.105   whiteX: 0.313 white=
Y: 0.329
[    33.913] (II) intel(0): Manufacturer's mask: 0
[    33.913] (II) intel(0): Supported detailed timing:
[    33.913] (II) intel(0): clock: 69.3 MHz   Image Size:  261 x 163 mm
[    33.913] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1360 h=
_blank_end 1403 h_border: 0
[    33.913] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_bl=
anking: 821 v_border: 0
[    33.913] (II) intel(0): Supported detailed timing:
[    33.913] (II) intel(0): clock: 57.6 MHz   Image Size:  261 x 163 mm
[    33.913] (II) intel(0): h_active: 1280  h_sync: 1328  h_sync_end 1360 h=
_blank_end 1403 h_border: 0
[    33.913] (II) intel(0): v_active: 800  v_sync: 803  v_sync_end 809 v_bl=
anking: 821 v_border: 0
[    33.913] (II) intel(0): Unknown vendor-specific block f
[    33.913] (II) intel(0):  B121EW09 V3
[    33.913] (II) intel(0): EDID (in hex):
[    33.913] (II) intel(0): 	00ffffffffffff0030ae114000000000
[    33.913] (II) intel(0): 	01130103801a1078ea65858f59588f26
[    33.913] (II) intel(0): 	1b505400000001010101010101010101
[    33.913] (II) intel(0): 	010101010101121b007b502015303020
[    33.913] (II) intel(0): 	360005a3100000187f16007b50201530
[    33.913] (II) intel(0): 	3020360005a3100000180000000f0081
[    33.913] (II) intel(0): 	0a3c810a3216090006af5633000000fe
[    33.913] (II) intel(0): 	004231323145573039205633200a009b
[    33.913] (II) intel(0): EDID vendor "LEN", prod id 16401
[    33.913] (II) intel(0): Printing DDC gathered Modelines:
[    33.913] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[    33.913] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[    33.913] (II) intel(0): Not using default mode "320x240" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "400x300" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "400x300" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "512x384" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "640x480" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "640x512" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "800x600" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "896x672" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "928x696" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "960x720" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "700x525" (doublescan mo=
de not supported)
[    33.913] (II) intel(0): Not using default mode "1024x768" (doublescan m=
ode not supported)
[    33.913] (II) intel(0): Printing probed modes for output LVDS1
[    33.913] (II) intel(0): Modeline "1280x800"x60.2   69.30  1280 1328 136=
0 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[    33.913] (II) intel(0): Modeline "1280x800"x50.0   57.59  1280 1328 136=
0 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[    33.913] (II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 118=
4 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    33.913] (II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 10=
56  600 601 605 628 +hsync +vsync (37.9 kHz)
[    33.913] (II) intel(0): Modeline "800x600"x56.2   36.00  800 824 896 10=
24  600 601 603 625 +hsync +vsync (35.2 kHz)
[    33.913] (II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 80=
0  480 490 492 525 -hsync -vsync (31.5 kHz)
[    33.948] (II) intel(0): EDID for output VGA1
[    33.957] (II) intel(0): EDID for output HDMI1
[    34.002] (II) intel(0): EDID for output DP1
[    34.002] (II) intel(0): Output LVDS1 connected
[    34.002] (II) intel(0): Output VGA1 disconnected
[    34.002] (II) intel(0): Output HDMI1 disconnected
[    34.002] (II) intel(0): Output DP1 disconnected
[    34.002] (II) intel(0): Using exact sizes for initial modes
[    34.002] (II) intel(0): Output LVDS1 using initial mode 1280x800
[    34.002] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless o=
therwise stated.
[    34.002] (II) intel(0): Pageflipping enabled in kernel, but disabled in=
 X
[    34.002] (II) intel(0): Don't panic: https://bugzilla.redhat.com/588421
[    34.002] (**) intel(0): Display dimensions: (260, 160) mm
[    34.002] (**) intel(0): DPI set to (125, 127)
[    34.002] (II) Loading sub module "fb"
[    34.003] (II) LoadModule: "fb"
[    34.003] (II) Loading /usr/lib/xorg/modules/libfb.so
[    34.051] (II) Module fb: vendor=3D"X.Org Foundation"
[    34.051] 	compiled for 1.8.1.902, module version =3D 1.0.0
[    34.051] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    34.051] (II) UnloadModule: "vesa"
[    34.051] (II) Unloading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    34.051] (=3D=3D) Depth 24 pixmap format is 32 bpp
[    34.051] (II) intel(0): [DRI2] Setup complete
[    34.051] (II) intel(0): [DRI2]   DRI driver: i965
[    34.051] (**) intel(0): Tiling enabled
[    34.051] (**) intel(0): SwapBuffers wait enabled
[    34.051] (=3D=3D) intel(0): VideoRam: 262144 KB
[    34.051] (II) intel(0): Allocated new frame buffer 1280x800 stride 5120=
, tiled
[    34.069] (II) UXA(0): Driver registered support for the following opera=
tions:
[    34.069] (II)         solid
[    34.069] (II)         copy
[    34.069] (II)         composite (RENDER acceleration)
[    34.069] (II)         put_image
[    34.069] (II)         get_image
[    34.076] (=3D=3D) intel(0): Backing store disabled
[    34.076] (=3D=3D) intel(0): Silken mouse enabled
[    34.077] (II) intel(0): Initializing HW Cursor
[    34.139] (II) intel(0): RandR 1.2 enabled, ignore the following RandR d=
isabled message.
[    34.141] (=3D=3D) intel(0): DPMS enabled
[    34.141] (=3D=3D) intel(0): Intel XvMC decoder enabled
[    34.141] (II) intel(0): Set up textured video
[    34.141] (II) intel(0): [XvMC] xvmc_vld driver initialized.
[    34.141] (II) intel(0): direct rendering: DRI2 Enabled
[    34.141] (--) RandR disabled
[    34.141] (II) Initializing built-in extension Generic Event Extension
[    34.141] (II) Initializing built-in extension SHAPE
[    34.141] (II) Initializing built-in extension MIT-SHM
[    34.141] (II) Initializing built-in extension XInputExtension
[    34.141] (II) Initializing built-in extension XTEST
[    34.141] (II) Initializing built-in extension BIG-REQUESTS
[    34.141] (II) Initializing built-in extension SYNC
[    34.141] (II) Initializing built-in extension XKEYBOARD
[    34.141] (II) Initializing built-in extension XC-MISC
[    34.141] (II) Initializing built-in extension SECURITY
[    34.141] (II) Initializing built-in extension XINERAMA
[    34.141] (II) Initializing built-in extension XFIXES
[    34.141] (II) Initializing built-in extension RENDER
[    34.141] (II) Initializing built-in extension RANDR
[    34.141] (II) Initializing built-in extension COMPOSITE
[    34.141] (II) Initializing built-in extension DAMAGE
[    34.196] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    34.196] (II) AIGLX: enabled GLX_INTEL_swap_event
[    34.196] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_con=
trol
[    34.196] (II) AIGLX: enabled GLX_SGI_make_current_read
[    34.196] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objec=
ts
[    34.196] (II) AIGLX: Loaded and initialized /usr/lib/xorg/modules/dri/i=
965_dri.so
[    34.196] (II) GLX: Initialized DRI2 GL provider for screen 0
[    34.196] (II) intel(0): Setting screen physical size to 338 x 211
[    34.683] (II) config/udev: Adding input device Power Button (/dev/input=
/event2)
[    34.683] (**) Power Button: Applying InputClass "evdev keyboard catchal=
l"
[    34.683] (II) LoadModule: "evdev"
[    34.683] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    34.692] (II) Module evdev: vendor=3D"X.Org Foundation"
[    34.692] 	compiled for 1.8.1.902, module version =3D 2.4.0
[    34.692] 	Module class: X.Org XInput Driver
[    34.692] 	ABI class: X.Org XInput driver, version 9.0
[    34.692] (**) Power Button: always reports core events
[    34.692] (**) Power Button: Device: "/dev/input/event2"
[    34.699] (II) Power Button: Found keys
[    34.699] (II) Power Button: Configuring as keyboard
[    34.699] (II) XINPUT: Adding extended input device "Power Button" (type=
: KEYBOARD)
[    34.699] (**) Option "xkb_rules" "evdev"
[    34.699] (**) Option "xkb_model" "evdev"
[    34.699] (**) Option "xkb_layout" "us"
[    34.733] (II) config/udev: Adding input device Video Bus (/dev/input/ev=
ent10)
[    34.733] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    34.733] (**) Video Bus: always reports core events
[    34.733] (**) Video Bus: Device: "/dev/input/event10"
[    34.739] (II) Video Bus: Found keys
[    34.739] (II) Video Bus: Configuring as keyboard
[    34.739] (II) XINPUT: Adding extended input device "Video Bus" (type: K=
EYBOARD)
[    34.739] (**) Option "xkb_rules" "evdev"
[    34.739] (**) Option "xkb_model" "evdev"
[    34.739] (**) Option "xkb_layout" "us"
[    34.740] (II) config/udev: Adding input device Lid Switch (/dev/input/e=
vent0)
[    34.740] (II) No input driver/identifier specified (ignoring)
[    34.741] (II) config/udev: Adding input device Sleep Button (/dev/input=
/event1)
[    34.741] (**) Sleep Button: Applying InputClass "evdev keyboard catchal=
l"
[    34.741] (**) Sleep Button: always reports core events
[    34.741] (**) Sleep Button: Device: "/dev/input/event1"
[    34.751] (II) Sleep Button: Found keys
[    34.751] (II) Sleep Button: Configuring as keyboard
[    34.751] (II) XINPUT: Adding extended input device "Sleep Button" (type=
: KEYBOARD)
[    34.751] (**) Option "xkb_rules" "evdev"
[    34.751] (**) Option "xkb_model" "evdev"
[    34.751] (**) Option "xkb_layout" "us"
[    34.753] (II) config/udev: Adding input device Integrated Camera (/dev/=
input/event8)
[    34.753] (**) Integrated Camera: Applying InputClass "evdev keyboard ca=
tchall"
[    34.753] (**) Integrated Camera: always reports core events
[    34.753] (**) Integrated Camera: Device: "/dev/input/event8"
[    34.763] (II) Integrated Camera: Found keys
[    34.763] (II) Integrated Camera: Configuring as keyboard
[    34.763] (II) XINPUT: Adding extended input device "Integrated Camera" =
(type: KEYBOARD)
[    34.763] (**) Option "xkb_rules" "evdev"
[    34.763] (**) Option "xkb_model" "evdev"
[    34.763] (**) Option "xkb_layout" "us"
[    34.763] (II) config/udev: Adding input device HDA Digital PCBeep (/dev=
/input/event7)
[    34.763] (II) No input driver/identifier specified (ignoring)
[    34.767] (II) config/udev: Adding input device AT Translated Set 2 keyb=
oard (/dev/input/event3)
[    34.767] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev =
keyboard catchall"
[    34.767] (**) AT Translated Set 2 keyboard: always reports core events
[    34.767] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event3"
[    34.775] (II) AT Translated Set 2 keyboard: Found keys
[    34.775] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    34.775] (II) XINPUT: Adding extended input device "AT Translated Set 2=
 keyboard" (type: KEYBOARD)
[    34.775] (**) Option "xkb_rules" "evdev"
[    34.775] (**) Option "xkb_model" "evdev"
[    34.775] (**) Option "xkb_layout" "us"
[    34.775] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event4)
[    34.775] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[    34.775] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[    34.775] (II) LoadModule: "synaptics"
[    34.775] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[    34.785] (II) Module synaptics: vendor=3D"X.Org Foundation"
[    34.785] 	compiled for 1.8.0.902, module version =3D 1.2.2
[    34.785] 	Module class: X.Org XInput Driver
[    34.785] 	ABI class: X.Org XInput driver, version 9.0
[    34.785] (II) Synaptics touchpad driver version 1.2.2
[    34.785] (**) Option "Device" "/dev/input/event4"
[    34.823] (II) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5888
[    34.823] (II) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4810
[    34.823] (II) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[    34.823] (II) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[    34.823] (II) SynPS/2 Synaptics TouchPad: buttons: left right
[    34.823] (**) Option "TapButton1" "1"
[    34.823] (**) Option "TapButton2" "2"
[    34.823] (**) Option "TapButton3" "3"
[    34.855] (--) SynPS/2 Synaptics TouchPad: touchpad found
[    34.855] (**) SynPS/2 Synaptics TouchPad: always reports core events
[    34.871] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[    34.871] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[    34.871] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 0
[    34.871] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[    34.871] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[    34.895] (--) SynPS/2 Synaptics TouchPad: touchpad found
[    34.895] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[    34.895] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[    34.895] (II) Synaptics touchpad driver version 1.2.2
[    35.407] SynPS/2 Synaptics TouchPad no synaptics event device found
[    35.407] (**) Option "Device" "/dev/input/mouse0"
[    35.415] (**) Option "TapButton1" "1"
[    35.415] (**) Option "TapButton2" "2"
[    35.415] (**) Option "TapButton3" "3"
[    35.435] Query no Synaptics: 6003C8
[    35.435] (--) SynPS/2 Synaptics TouchPad: no supported touchpad found
[    35.435] (EE) SynPS/2 Synaptics TouchPad Unable to query/initialize Syn=
aptics hardware.
[    35.448] (EE) PreInit failed for input device "SynPS/2 Synaptics TouchP=
ad"
[    35.448] (II) UnloadModule: "synaptics"
[    35.448] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event9)
[    35.448] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[    35.448] (**) TPPS/2 IBM TrackPoint: always reports core events
[    35.448] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event9"
[    35.456] (II) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[    35.456] (II) TPPS/2 IBM TrackPoint: Found relative axes
[    35.456] (II) TPPS/2 IBM TrackPoint: Found x and y relative axes
[    35.456] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[    35.456] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[    35.456] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[    35.456] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[    35.456] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[    35.456] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[    35.456] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[    35.456] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[    35.456] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[    35.456] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[    35.456] (II) No input driver/identifier specified (ignoring)
[    35.456] (II) config/udev: Adding input device PC Speaker (/dev/input/e=
vent5)
[    35.456] (II) No input driver/identifier specified (ignoring)
[    35.457] (II) config/udev: Adding input device ThinkPad Extra Buttons (=
/dev/input/event6)
[    35.457] (**) ThinkPad Extra Buttons: Applying InputClass "evdev keyboa=
rd catchall"
[    35.457] (**) ThinkPad Extra Buttons: always reports core events
[    35.457] (**) ThinkPad Extra Buttons: Device: "/dev/input/event6"
[    35.464] (II) ThinkPad Extra Buttons: Found keys
[    35.464] (II) ThinkPad Extra Buttons: Configuring as keyboard
[    35.464] (II) XINPUT: Adding extended input device "ThinkPad Extra Butt=
ons" (type: KEYBOARD)
[    35.464] (**) Option "xkb_rules" "evdev"
[    35.464] (**) Option "xkb_model" "evdev"
[    35.464] (**) Option "xkb_layout" "us"
[ 12058.381] (II) AIGLX: Suspending AIGLX clients for VT switch
[ 12062.506] (II) AIGLX: Resuming AIGLX clients after VT switch
[ 12062.683] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 12062.683] (II) intel(0): Printing DDC gathered Modelines:
[ 12062.683] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 12062.683] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 12062.827] (--) SynPS/2 Synaptics TouchPad: touchpad found
[ 69504.600] (II) AIGLX: Suspending AIGLX clients for VT switch
[ 69506.165] (II) AIGLX: Resuming AIGLX clients after VT switch
[ 69506.446] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 69506.447] (II) intel(0): Printing DDC gathered Modelines:
[ 69506.447] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 69506.447] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 69506.987] (--) SynPS/2 Synaptics TouchPad: touchpad found
[ 72632.908] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72632.908] (II) intel(0): Printing DDC gathered Modelines:
[ 72632.908] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72632.908] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72633.617] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72633.617] (II) intel(0): Printing DDC gathered Modelines:
[ 72633.617] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72633.617] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72634.339] (II) intel(0): Allocated new frame buffer 1600x2000 stride 665=
6, tiled
[ 72634.843] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72634.843] (II) intel(0): Printing DDC gathered Modelines:
[ 72634.843] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72634.843] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72635.674] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72635.674] (II) intel(0): Printing DDC gathered Modelines:
[ 72635.674] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72635.674] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72636.507] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72636.507] (II) intel(0): Printing DDC gathered Modelines:
[ 72636.507] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72636.507] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72637.340] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72637.340] (II) intel(0): Printing DDC gathered Modelines:
[ 72637.340] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72637.340] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72638.172] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72638.172] (II) intel(0): Printing DDC gathered Modelines:
[ 72638.172] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72638.218] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72639.051] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72639.051] (II) intel(0): Printing DDC gathered Modelines:
[ 72639.051] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72639.051] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72640.004] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72640.004] (II) intel(0): Printing DDC gathered Modelines:
[ 72640.004] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72640.004] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72640.838] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72640.838] (II) intel(0): Printing DDC gathered Modelines:
[ 72640.838] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72640.838] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 72641.671] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 72641.671] (II) intel(0): Printing DDC gathered Modelines:
[ 72641.671] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 72641.671] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76412.181] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76412.181] (II) intel(0): Printing DDC gathered Modelines:
[ 76412.181] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76412.181] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76412.420] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76412.420] (II) intel(0): Printing DDC gathered Modelines:
[ 76412.420] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76412.420] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76412.866] (II) intel(0): Allocated new frame buffer 1280x800 stride 5120=
, tiled
[ 76413.199] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76413.199] (II) intel(0): Printing DDC gathered Modelines:
[ 76413.199] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76413.199] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76413.495] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76413.495] (II) intel(0): Printing DDC gathered Modelines:
[ 76413.495] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76413.495] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76413.709] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76413.709] (II) intel(0): Printing DDC gathered Modelines:
[ 76413.709] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76413.709] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76413.959] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76413.959] (II) intel(0): Printing DDC gathered Modelines:
[ 76413.959] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76413.959] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76414.189] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76414.189] (II) intel(0): Printing DDC gathered Modelines:
[ 76414.189] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76414.189] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76414.403] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76414.403] (II) intel(0): Printing DDC gathered Modelines:
[ 76414.403] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76414.403] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76414.633] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76414.633] (II) intel(0): Printing DDC gathered Modelines:
[ 76414.633] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76414.633] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76414.847] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76414.847] (II) intel(0): Printing DDC gathered Modelines:
[ 76414.847] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76414.847] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 76415.061] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 76415.061] (II) intel(0): Printing DDC gathered Modelines:
[ 76415.061] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 76415.061] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 78028.975] (II) AIGLX: Suspending AIGLX clients for VT switch
[ 78033.711] (II) AIGLX: Resuming AIGLX clients after VT switch
[ 78033.888] (II) intel(0): EDID vendor "LEN", prod id 16401
[ 78033.888] (II) intel(0): Printing DDC gathered Modelines:
[ 78033.888] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[ 78033.888] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[ 78034.022] (--) SynPS/2 Synaptics TouchPad: touchpad found
[155815.956] (II) intel(0): EDID vendor "LEN", prod id 16401
[155815.956] (II) intel(0): Printing DDC gathered Modelines:
[155815.956] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[155815.956] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[217104.325] (II) AIGLX: Suspending AIGLX clients for VT switch
[217109.186] (II) AIGLX: Resuming AIGLX clients after VT switch
[217109.363] (II) intel(0): EDID vendor "LEN", prod id 16401
[217109.363] (II) intel(0): Printing DDC gathered Modelines:
[217109.363] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[217109.363] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[217109.504] (--) SynPS/2 Synaptics TouchPad: touchpad found
[217578.417] (II) AIGLX: Suspending AIGLX clients for VT switch
[217582.668] (II) AIGLX: Resuming AIGLX clients after VT switch
[217582.845] (II) intel(0): EDID vendor "LEN", prod id 16401
[217582.845] (II) intel(0): Printing DDC gathered Modelines:
[217582.845] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[217582.845] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[217582.963] (--) SynPS/2 Synaptics TouchPad: touchpad found
[218546.487] (II) intel(0): EDID vendor "LEN", prod id 16401
[218546.487] (II) intel(0): Printing DDC gathered Modelines:
[218546.487] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218546.487] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218547.511] (II) intel(0): EDID vendor "LEN", prod id 16401
[218547.511] (II) intel(0): Printing DDC gathered Modelines:
[218547.511] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218547.511] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218548.116] (II) intel(0): Allocated new frame buffer 1600x2000 stride 665=
6, tiled
[218548.635] (II) intel(0): EDID vendor "LEN", prod id 16401
[218548.636] (II) intel(0): Printing DDC gathered Modelines:
[218548.636] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218548.636] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218549.475] (II) intel(0): EDID vendor "LEN", prod id 16401
[218549.475] (II) intel(0): Printing DDC gathered Modelines:
[218549.475] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218549.475] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218550.306] (II) intel(0): EDID vendor "LEN", prod id 16401
[218550.307] (II) intel(0): Printing DDC gathered Modelines:
[218550.307] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218550.307] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218551.145] (II) intel(0): EDID vendor "LEN", prod id 16401
[218551.145] (II) intel(0): Printing DDC gathered Modelines:
[218551.145] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218551.145] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218552.101] (II) intel(0): EDID vendor "LEN", prod id 16401
[218552.101] (II) intel(0): Printing DDC gathered Modelines:
[218552.101] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218552.101] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218553.003] (II) intel(0): EDID vendor "LEN", prod id 16401
[218553.003] (II) intel(0): Printing DDC gathered Modelines:
[218553.003] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218553.003] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218553.836] (II) intel(0): EDID vendor "LEN", prod id 16401
[218553.836] (II) intel(0): Printing DDC gathered Modelines:
[218553.836] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218553.836] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218554.793] (II) intel(0): EDID vendor "LEN", prod id 16401
[218554.793] (II) intel(0): Printing DDC gathered Modelines:
[218554.793] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218554.793] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[218555.625] (II) intel(0): EDID vendor "LEN", prod id 16401
[218555.625] (II) intel(0): Printing DDC gathered Modelines:
[218555.625] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[218555.625] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[304780.840] (II) AIGLX: Suspending AIGLX clients for VT switch
[304786.039] (II) AIGLX: Resuming AIGLX clients after VT switch
[304786.344] (II) intel(0): EDID vendor "LEN", prod id 16401
[304786.344] (II) intel(0): Printing DDC gathered Modelines:
[304786.344] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[304786.344] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[304786.468] (--) SynPS/2 Synaptics TouchPad: touchpad found
[305789.293] (WW) intel(0): get vblank counter failed: Invalid argument
[305790.330] (II) AIGLX: Suspending AIGLX clients for VT switch
[305795.333] (II) AIGLX: Resuming AIGLX clients after VT switch
[305795.648] (II) intel(0): EDID vendor "LEN", prod id 16401
[305795.648] (II) intel(0): Printing DDC gathered Modelines:
[305795.648] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[305795.648] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[305795.766] (--) SynPS/2 Synaptics TouchPad: touchpad found
[305795.782] (WW) intel(0): get vblank counter failed: Invalid argument
[305795.782] (WW) intel(0): first get vblank counter failed: Invalid argume=
nt
[305796.165] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.468] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.544] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.620] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.695] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.771] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.846] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.922] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305796.998] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.074] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.074] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.150] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.226] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.301] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.496] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.592] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.688] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.785] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.881] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305797.976] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305798.072] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305799.073] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305799.149] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305799.225] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305799.303] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305799.380] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305800.806] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305800.882] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305800.958] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305801.034] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305801.110] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305801.186] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305801.261] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.151] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.226] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.328] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.424] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.520] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.617] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.693] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.768] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.843] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.918] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305802.993] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305803.069] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305803.145] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305803.220] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305803.295] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305803.370] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305803.973] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305804.048] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305804.142] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305804.294] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305804.520] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305804.749] (II) AIGLX: Suspending AIGLX clients for VT switch
[305808.204] (II) AIGLX: Resuming AIGLX clients after VT switch
[305808.517] (II) intel(0): EDID vendor "LEN", prod id 16401
[305808.517] (II) intel(0): Printing DDC gathered Modelines:
[305808.517] (II) intel(0): Modeline "1280x800"x0.0   69.30  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (49.4 kHz)
[305808.517] (II) intel(0): Modeline "1280x800"x0.0   57.59  1280 1328 1360=
 1403  800 803 809 821 -hsync -vsync (41.0 kHz)
[305808.670] (--) SynPS/2 Synaptics TouchPad: touchpad found
[305809.214] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.365] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.442] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.442] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.442] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.442] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.443] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.746] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.821] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305809.896] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.
[305810.071] (II) AIGLX: Suspending AIGLX clients for VT switch
[305815.694] (EE) intel(0): Failed to submit batch buffer, expect rendering=
 corruption or even a frozen display: Input/output error.

--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.2.6.36-rc3-00464-g84e1d83"
Content-Transfer-Encoding: quoted-printable

[257511.103290] add_index: xtInsert failed!
[257511.103391] add_index: xtInsert failed!
[257514.224243] add_index: xtInsert failed!
[257514.224442] add_index: xtInsert failed!
[257514.224846] add_index: xtInsert failed!
[257529.163303] add_index: xtInsert failed!
[257529.163430] add_index: xtInsert failed!
[257570.722311] add_index: xtInsert failed!
[257570.722474] add_index: xtInsert failed!
[257570.722761] add_index: xtInsert failed!
[257577.061886] usb 1-1.5.1: USB disconnect, address 44
[257577.061899] PM: Removing info for No Bus:ep_81
[257577.061923] PM: Removing info for No Bus:ep_02
[257577.061939] PM: Removing info for usb:1-1.5.1:1.0
[257577.061968] PM: Removing info for No Bus:23:0:0:0
[257577.062077] PM: Removing info for No Bus:23:0:0:0
[257577.062091] PM: Removing info for No Bus:sg3
[257577.062144] PM: Removing info for scsi:23:0:0:0
[257577.062163] PM: Removing info for No Bus:23:0:0:0
[257577.062206] PM: Removing info for No Bus:sdc1
[257577.066394] PM: Removing info for No Bus:8:32
[257577.066457] PM: Removing info for No Bus:sdc
[257577.066553] PM: Removing info for scsi:target23:0:0
[257577.066590] PM: Removing info for No Bus:host23
[257577.066614] PM: Removing info for scsi:host23
[257577.066671] PM: Removing info for No Bus:ep_00
[257577.066685] PM: Removing info for usb:1-1.5.1
[269724.779138] e1000e: eth0 NIC Link is Down
[269728.882605] ata2.00: disabled
[269728.882672] PM: Removing info for acpi:LNXIOBAY:05
[269728.882736] PM: Removing info for acpi:device:37
[269728.882772] PM: Removing info for acpi:IBM0079:05
[269728.882787] ACPI: \_SB_.GDCK - undocking
[269728.882944] ata2.00: detaching (SCSI 1:0:0:0)
[269728.882952] PM: Removing info for No Bus:1:0:0:0
[269728.884599] PM: Removing info for No Bus:1:0:0:0
[269728.884702] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4080800 action 0=
xe frozen
[269728.884708] ata2: irq_stat 0x000000c0, connection status changed
[269728.884716] ata2: SError: { HostInt 10B8B DevExch }
[269728.884733] ata2: hard resetting link
[269728.885412] PM: Removing info for No Bus:sg1
[269728.887029] PM: Removing info for scsi:1:0:0:0
[269728.891137] PM: Removing info for No Bus:11:0
[269728.891200] PM: Removing info for No Bus:sr0
[269728.896738] usb 1-1.5: clear tt 3 (9183) error -71
[269728.902871] usb 1-1.5: USB disconnect, address 22
[269728.902876] usb 1-1.5.2: USB disconnect, address 23
[269728.902888] PM: Removing info for No Bus:ep_81
[269728.902912] PM: Removing info for No Bus:ep_02
[269728.902926] PM: Removing info for usb:1-1.5.2:1.0
[269728.902954] PM: Removing info for No Bus:12:0:0:0
[269728.903093] PM: Removing info for No Bus:12:0:0:0
[269728.903110] PM: Removing info for No Bus:sg2
[269728.903201] PM: Removing info for scsi:12:0:0:0
[269728.903239] PM: Removing info for No Bus:12:0:0:0
[269728.904334] usb 1-1.5.3: pl2303_read_int_callback - usb_submit_urb fail=
ed with result -19
[269728.910131] PM: Removing info for No Bus:8:16
[269728.910211] PM: Removing info for No Bus:sdb
[269728.910315] PM: Removing info for scsi:target12:0:0
[269728.910343] PM: Removing info for No Bus:host12
[269728.910368] PM: Removing info for scsi:host12
[269728.910453] PM: Removing info for No Bus:ep_00
[269728.910466] PM: Removing info for usb:1-1.5.2
[269728.910582] usb 1-1.5.3: USB disconnect, address 24
[269728.910591] PM: Removing info for No Bus:ep_81
[269728.910602] PM: Removing info for No Bus:ep_02
[269728.910610] PM: Removing info for No Bus:ep_83
[269728.910620] PM: Removing info for usb:1-1.5.3:1.0
[269728.910651] PM: Removing info for usb-serial:ttyUSB0
[269728.910731] PM: Removing info for No Bus:ttyUSB0
[269728.910816] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyU=
SB0
[269728.910825] pl2303 1-1.5.3:1.0: device disconnected
[269728.910842] PM: Removing info for No Bus:ep_00
[269728.910855] PM: Removing info for usb:1-1.5.3
[269728.910960] PM: Removing info for No Bus:ep_81
[269728.910974] PM: Removing info for usb:1-1.5:1.0
[269728.911005] PM: Removing info for No Bus:ep_00
[269728.911015] PM: Removing info for usb:1-1.5
[269729.605884] ata2: SATA link down (SStatus 0 SControl 300)
[269729.605899] ata2: EH complete
[269729.606039] PM: Removing info for scsi:target1:0:0
[269732.446653] thinkpad_acpi: EC reports that Thermal Table has changed
[269732.450427] ACPI: \_SB_.GDCK - undocking
[277719.508454] thinkpad_acpi: EC reports that Thermal Table has changed
[277719.884407] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0=
xe frozen
[277719.884412] ata2: irq_stat 0x000000c0, connection status changed
[277719.884418] ata2: SError: { CommWake DevExch }
[277719.884432] ata2: hard resetting link
[277720.107525] ACPI: \_SB_.GDCK - docking
[277720.110038] PM: Adding info for acpi:LNXIOBAY:06
[277720.110186] PM: Adding info for acpi:device:38
[277720.110903] PM: Adding info for acpi:IBM0079:06
[277720.680431] usb 1-1.5: new high speed USB device using ehci_hcd and add=
ress 45
[277720.765573] PM: Adding info for usb:1-1.5
[277720.765809] PM: Adding info for usb:1-1.5:1.0
[277720.765842] hub 1-1.5:1.0: USB hub found
[277720.766250] hub 1-1.5:1.0: 4 ports detected
[277720.766413] PM: Adding info for No Bus:ep_81
[277720.767308] PM: Adding info for No Bus:ep_00
[277721.039754] usb 1-1.5.3: new full speed USB device using ehci_hcd and a=
ddress 46
[277721.116401] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[277721.121721] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[277721.122540] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[277721.125270] PM: Adding info for usb:1-1.5.3
[277721.125533] PM: Adding info for usb:1-1.5.3:1.0
[277721.125567] pl2303 1-1.5.3:1.0: pl2303 converter detected
[277721.126195] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
[277721.128941] PM: Adding info for usb-serial:ttyUSB0
[277721.129127] PM: Adding info for No Bus:ttyUSB0
[277721.129150] usb 1-1.5.3: pl2303 converter now attached to ttyUSB0
[277721.129184] PM: Adding info for No Bus:ep_81
[277721.129209] PM: Adding info for No Bus:ep_02
[277721.129225] PM: Adding info for No Bus:ep_83
[277721.129246] PM: Adding info for No Bus:ep_00
[277721.132857] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[277721.133745] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[277721.137378] ata2.00: configured for UDMA/133
[277721.250383] ata2: EH complete
[277721.253527] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  H=
X12 PQ: 0 ANSI: 5
[277721.253559] PM: Adding info for scsi:target1:0:0
[277721.253615] PM: Adding info for scsi:1:0:0:0
[277721.602970] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2=
 cdda tray
[277721.603026] PM: Adding info for No Bus:sr0
[277721.603130] PM: Adding info for No Bus:11:0
[277721.603162] sr 1:0:0:0: Attached scsi CD-ROM sr0
[277721.603189] PM: Adding info for No Bus:1:0:0:0
[277721.603322] PM: Adding info for No Bus:sg1
[277721.603372] sr 1:0:0:0: Attached scsi generic sg1 type 5
[277721.603463] PM: Adding info for No Bus:1:0:0:0
[277726.573638] usb 1-1.5.2: new high speed USB device using ehci_hcd and a=
ddress 47
[277726.660689] PM: Adding info for usb:1-1.5.2
[277726.660890] PM: Adding info for usb:1-1.5.2:1.0
[277726.661075] usb-storage 1-1.5.2:1.0: Quirks match for vid 1058 pid 0704=
: 8000
[277726.661121] scsi24 : usb-storage 1-1.5.2:1.0
[277726.661145] PM: Adding info for scsi:host24
[277726.661221] PM: Adding info for No Bus:host24
[277726.661377] PM: Adding info for No Bus:ep_81
[277726.661402] PM: Adding info for No Bus:ep_02
[277726.661427] PM: Adding info for No Bus:ep_00
[277727.660821] scsi 24:0:0:0: Direct-Access     WD       5000BMV External =
1.75 PQ: 0 ANSI: 4
[277727.660842] PM: Adding info for scsi:target24:0:0
[277727.660878] PM: Adding info for scsi:24:0:0:0
[277727.660909] PM: Adding info for No Bus:24:0:0:0
[277727.660947] PM: Adding info for No Bus:24:0:0:0
[277727.661057] PM: Adding info for No Bus:sg2
[277727.661100] sd 24:0:0:0: Attached scsi generic sg2 type 0
[277727.661134] PM: Adding info for No Bus:24:0:0:0
[277727.662723] sd 24:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 =
GB/465 GiB)
[277727.663867] sd 24:0:0:0: [sdb] Write Protect is off
[277727.663876] sd 24:0:0:0: [sdb] Mode Sense: 23 00 00 00
[277727.663882] sd 24:0:0:0: [sdb] Assuming drive cache: write through
[277727.663943] PM: Adding info for No Bus:sdb
[277727.666396] sd 24:0:0:0: [sdb] Assuming drive cache: write through
[277727.699616]  sdb: unknown partition table
[277727.699750] PM: Adding info for No Bus:8:16
[277727.700955] sd 24:0:0:0: [sdb] Assuming drive cache: write through
[277727.700962] sd 24:0:0:0: [sdb] Attached SCSI disk
[277735.334443] sr 1:0:0:0: [sr0]  Result: hostbyte=3D0x00 driverbyte=3D0x08
[277735.334450] sr 1:0:0:0: [sr0]  Sense Key : 0x5 [current]=20
[277735.334457] ILI
[277735.334459] sr 1:0:0:0: [sr0]  ASC=3D0x64 ASCQ=3D0x0
[277735.334465] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 =
00 02 00
[277735.334477] end_request: I/O error, dev sr0, sector 0
[277735.334482] Buffer I/O error on device sr0, logical block 0
[277735.334487] Buffer I/O error on device sr0, logical block 1
[277735.337586] sr 1:0:0:0: [sr0]  Result: hostbyte=3D0x00 driverbyte=3D0x08
[277735.337592] sr 1:0:0:0: [sr0]  Sense Key : 0x5 [current]=20
[277735.337597] ILI
[277735.337600] sr 1:0:0:0: [sr0]  ASC=3D0x64 ASCQ=3D0x0
[277735.337605] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 =
00 02 00
[277735.337617] end_request: I/O error, dev sr0, sector 0
[277735.337621] Buffer I/O error on device sr0, logical block 0
[277735.337626] Buffer I/O error on device sr0, logical block 1
[277735.340679] sr 1:0:0:0: [sr0]  Result: hostbyte=3D0x00 driverbyte=3D0x08
[277735.340685] sr 1:0:0:0: [sr0]  Sense Key : 0x5 [current]=20
[277735.340690] ILI
[277735.340693] sr 1:0:0:0: [sr0]  ASC=3D0x64 ASCQ=3D0x0
[277735.340698] sr 1:0:0:0: [sr0] CDB: cdb[0]=3D0x28: 28 00 00 00 00 00 00 =
00 02 00
[277735.340709] end_request: I/O error, dev sr0, sector 0
[277735.340714] Buffer I/O error on device sr0, logical block 0
[277735.340718] Buffer I/O error on device sr0, logical block 1
[280246.946398] add_index: xtInsert failed!
[280246.946405] add_index: xtInsert failed!
[280246.946442] add_index: xtInsert failed!
[280246.946445] add_index: xtInsert failed!
[280249.284963] add_index: xtInsert failed!
[280249.284971] add_index: xtInsert failed!
[280249.285026] add_index: xtInsert failed!
[280249.285030] add_index: xtInsert failed!
[280250.508687] add_index: xtInsert failed!
[280250.508694] add_index: xtInsert failed!
[280250.508774] add_index: xtInsert failed!
[280250.508778] add_index: xtInsert failed!
[281219.124662] wlan0: deauthenticated from 00:05:4e:4d:82:6d (Reason: 2)
[281219.138141] cfg80211: Calling CRDA to update world regulatory domain
[281247.118872] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[281247.121115] wlan0: authenticated
[281247.126130] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[281247.325531] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[281247.327829] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[281247.327835] wlan0: associated
[298934.223968] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[298934.240904] cfg80211: Calling CRDA to update world regulatory domain
[298937.550306] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[298937.749543] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[298937.949174] wlan0: authenticate with 00:05:4e:4d:82:6d (try 3)
[298938.009573] wlan0: authenticated
[298938.019432] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[298938.218620] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[298938.418255] wlan0: associate with 00:05:4e:4d:82:6d (try 3)
[298938.493570] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[298938.493575] wlan0: associated
[300732.933932] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[300732.948125] cfg80211: Calling CRDA to update world regulatory domain
[300736.258396] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[300736.261024] wlan0: authenticated
[300736.264292] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[300736.463455] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[300736.470636] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[300736.470642] wlan0: associated
[301946.713796] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[301946.727996] cfg80211: Calling CRDA to update world regulatory domain
[301958.207679] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[301958.407383] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[301958.410013] wlan0: authenticated
[301958.417306] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[301958.423293] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[301958.423301] wlan0: associated
[301972.666274] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[301972.680606] cfg80211: Calling CRDA to update world regulatory domain
[301976.013202] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[301976.212828] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[301976.215466] wlan0: authenticated
[301976.225220] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[301976.231929] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[301976.231936] wlan0: associated
[301990.633486] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[301990.647486] cfg80211: Calling CRDA to update world regulatory domain
[301993.933455] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[301994.133054] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[301994.135922] wlan0: authenticated
[301994.139285] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[301994.338673] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[301994.538307] wlan0: associate with 00:05:4e:4d:82:6d (try 3)
[301994.737932] wlan0: association with 00:05:4e:4d:82:6d timed out
[302007.102399] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302007.105041] wlan0: authenticated
[302007.108724] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[302007.307942] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[302007.311173] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[302007.311178] wlan0: associated
[302017.576164] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[302017.590190] cfg80211: Calling CRDA to update world regulatory domain
[302020.942961] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302020.948539] wlan0: authenticated
[302020.952245] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[302021.151630] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[302021.154023] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[302021.154029] wlan0: associated
[302035.551271] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[302035.563375] cfg80211: Calling CRDA to update world regulatory domain
[302047.067842] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302047.266855] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[302047.466517] wlan0: authenticate with 00:05:4e:4d:82:6d (try 3)
[302047.666171] wlan0: authentication with 00:05:4e:4d:82:6d timed out
[302060.260413] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302060.262992] wlan0: authenticated
[302060.266502] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[302060.465700] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[302060.472091] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[302060.472097] wlan0: associated
[302081.467285] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[302081.488296] cfg80211: Calling CRDA to update world regulatory domain
[302093.008343] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302093.207807] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[302093.407449] wlan0: authenticate with 00:05:4e:4d:82:6d (try 3)
[302093.607096] wlan0: authentication with 00:05:4e:4d:82:6d timed out
[302106.246502] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302106.250251] wlan0: authenticated
[302106.265180] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[302106.464575] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[302106.484243] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[302106.484248] wlan0: associated
[302260.140427] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[302260.158812] cfg80211: Calling CRDA to update world regulatory domain
[302271.685443] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302271.688004] wlan0: authenticated
[302271.691180] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[302271.889917] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[302271.893077] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[302271.893086] wlan0: associated
[302578.558062] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[302578.573398] cfg80211: Calling CRDA to update world regulatory domain
[302581.879955] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[302582.079589] wlan0: authenticate with 00:05:4e:4d:82:6d (try 2)
[302582.082165] wlan0: authenticated
[302582.083562] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[302582.086912] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[302582.086920] wlan0: associated
[304073.822992] No probe response from AP 00:05:4e:4d:82:6d after 500ms, di=
sconnecting.
[304073.837237] cfg80211: Calling CRDA to update world regulatory domain
[304077.125458] wlan0: authenticate with 00:05:4e:4d:82:6d (try 1)
[304077.164761] wlan0: authenticated
[304077.173529] wlan0: associate with 00:05:4e:4d:82:6d (try 1)
[304077.372484] wlan0: associate with 00:05:4e:4d:82:6d (try 2)
[304077.374724] wlan0: RX AssocResp from 00:05:4e:4d:82:6d (capab=3D0x1 sta=
tus=3D0 aid=3D1)
[304077.374729] wlan0: associated
[304221.572219] ata2.00: disabled
[304221.572279] PM: Removing info for acpi:LNXIOBAY:06
[304221.572334] PM: Removing info for acpi:device:38
[304221.572387] PM: Removing info for acpi:IBM0079:06
[304221.572414] ACPI: \_SB_.GDCK - undocking
[304221.572655] ata2.00: detaching (SCSI 1:0:0:0)
[304221.572667] PM: Removing info for No Bus:1:0:0:0
[304221.572870] PM: Removing info for No Bus:1:0:0:0
[304221.572887] PM: Removing info for No Bus:sg1
[304221.572960] PM: Removing info for scsi:1:0:0:0
[304221.573956] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4080800 action 0=
xe frozen
[304221.573963] ata2: irq_stat 0x000000c0, connection status changed
[304221.573971] ata2: SError: { HostInt 10B8B DevExch }
[304221.573989] ata2: hard resetting link
[304221.577128] PM: Removing info for No Bus:11:0
[304221.577321] PM: Removing info for No Bus:sr0
[304221.768897] usb 1-1.5: USB disconnect, address 45
[304221.768903] usb 1-1.5.2: USB disconnect, address 47
[304221.768914] PM: Removing info for No Bus:ep_81
[304221.768940] PM: Removing info for No Bus:ep_02
[304221.768954] PM: Removing info for usb:1-1.5.2:1.0
[304221.768984] PM: Removing info for No Bus:24:0:0:0
[304221.769112] PM: Removing info for No Bus:24:0:0:0
[304221.769130] PM: Removing info for No Bus:sg2
[304221.769215] PM: Removing info for scsi:24:0:0:0
[304221.769255] PM: Removing info for No Bus:24:0:0:0
[304221.773371] PM: Removing info for No Bus:8:16
[304221.773432] PM: Removing info for No Bus:sdb
[304221.773529] PM: Removing info for scsi:target24:0:0
[304221.773561] PM: Removing info for No Bus:host24
[304221.773600] PM: Removing info for scsi:host24
[304221.773707] PM: Removing info for No Bus:ep_00
[304221.773735] PM: Removing info for usb:1-1.5.2
[304221.773861] usb 1-1.5.3: USB disconnect, address 46
[304221.773873] PM: Removing info for No Bus:ep_81
[304221.773896] PM: Removing info for No Bus:ep_02
[304221.773912] PM: Removing info for No Bus:ep_83
[304221.773926] PM: Removing info for usb:1-1.5.3:1.0
[304221.773956] PM: Removing info for usb-serial:ttyUSB0
[304221.774034] PM: Removing info for No Bus:ttyUSB0
[304221.774140] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyU=
SB0
[304221.774159] pl2303 1-1.5.3:1.0: device disconnected
[304221.774182] PM: Removing info for No Bus:ep_00
[304221.774199] PM: Removing info for usb:1-1.5.3
[304221.774383] PM: Removing info for No Bus:ep_81
[304221.774404] PM: Removing info for usb:1-1.5:1.0
[304221.774462] PM: Removing info for No Bus:ep_00
[304221.774481] PM: Removing info for usb:1-1.5
[304222.295449] ata2: SATA link down (SStatus 0 SControl 300)
[304222.295466] ata2: EH complete
[304222.295554] PM: Removing info for scsi:target1:0:0
[304224.324097] usb 1-1.4: USB disconnect, address 21
[304224.324129] btusb_intr_complete: hci0 urb ffff88008a758cc0 failed to re=
submit (19)
[304224.324323] btusb_bulk_complete: hci0 urb ffff88008a758180 failed to re=
submit (19)
[304224.324330] btusb_bulk_complete: hci0 urb ffff88008a758d80 failed to re=
submit (19)
[304224.324868] PM: Removing info for No Bus:ep_81
[304224.324884] PM: Removing info for No Bus:ep_82
[304224.324890] PM: Removing info for No Bus:ep_02
[304224.324899] PM: Removing info for usb:1-1.4:1.0
[304224.324932] btusb_send_frame: hci0 urb ffff88008b2bc840 submission fail=
ed
[304224.574287] PM: Removing info for No Bus:rfkill6
[304224.574358] PM: Removing info for No Bus:hci0
[304224.574495] PM: Removing info for No Bus:ep_83
[304224.574511] PM: Removing info for No Bus:ep_03
[304224.574518] PM: Removing info for usb:1-1.4:1.1
[304224.574535] PM: Removing info for No Bus:ep_84
[304224.574543] PM: Removing info for No Bus:ep_04
[304224.574551] PM: Removing info for usb:1-1.4:1.2
[304224.574566] PM: Removing info for usb:1-1.4:1.3
[304224.574581] PM: Removing info for No Bus:ep_00
[304224.574591] PM: Removing info for usb:1-1.4
[304225.049894] PM: Syncing filesystems ... done.
[304225.074795] PM: Preparing system for mem sleep
[304226.338268] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[304226.349055] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[304226.360017] PM: Entering mem sleep
[304226.360165] Suspending console(s) (use no_console_suspend to debug)
[304226.360191] platform dock.0: preparing suspend
[304226.360193] platform dock.1: preparing suspend
[304226.360195] platform dock.2: preparing suspend
[304226.360198] pci 0000:ff:00.0: preparing suspend
[304226.360199] pci 0000:ff:00.1: preparing suspend
[304226.360201] pci 0000:ff:02.0: preparing suspend
[304226.360203] pci 0000:ff:02.1: preparing suspend
[304226.360204] pci 0000:ff:02.2: preparing suspend
[304226.360206] pci 0000:ff:02.3: preparing suspend
[304226.360209] agpgart-intel 0000:00:00.0: preparing suspend
[304226.360211] i915 0000:00:02.0: preparing suspend
[304226.360213] pci 0000:00:16.0: preparing suspend
[304226.360215] serial 0000:00:16.3: preparing suspend
[304226.360217] e1000e 0000:00:19.0: preparing suspend, may wakeup
[304226.360219] ehci_hcd 0000:00:1a.0: preparing suspend
[304226.360221] HDA Intel 0000:00:1b.0: preparing suspend
[304226.360223] pci 0000:00:1c.0: preparing suspend
[304226.360224] pci 0000:00:1c.3: preparing suspend
[304226.360226] pci 0000:00:1c.4: preparing suspend
[304226.360228] ehci_hcd 0000:00:1d.0: preparing suspend
[304226.360230] pci 0000:00:1e.0: preparing suspend
[304226.360231] pci 0000:00:1f.0: preparing suspend
[304226.360233] ahci 0000:00:1f.2: preparing suspend
[304226.360235] i801_smbus 0000:00:1f.3: preparing suspend
[304226.360237] intel ips 0000:00:1f.6: preparing suspend
[304226.360240] iwlagn 0000:02:00.0: preparing suspend
[304226.360255] pcspkr pcspkr: preparing suspend
[304226.360256] platform microcode: preparing suspend
[304226.360331] i8042 i8042: preparing suspend
[304226.360340] usb usb1: preparing type suspend, may wakeup
[304226.360343] serial8250 serial8250: preparing suspend
[304226.360345] usb usb2: preparing type suspend, may wakeup
[304226.360350] platform regulatory.0: preparing suspend
[304226.360353] thinkpad_acpi thinkpad_acpi: preparing suspend
[304226.360355] thinkpad_hwmon thinkpad_hwmon: preparing suspend
[304226.360363] usb 1-1: preparing type suspend
[304226.360365] usb 2-1: preparing type suspend
[304226.360368] usb 1-1.3: preparing type suspend
[304226.360370] usb 1-1.6: preparing type suspend
[304226.360398] input input10: type suspend
[304226.360402] backlight acpi_video0: legacy class suspend
[304226.360404] i2c i2c-4: suspend
[304226.360407] drm card0-DisplayPort-1: legacy class suspend
[304226.360409] drm card0-HDMI Type A-1: legacy class suspend
[304226.360411] i2c i2c-3: suspend
[304226.360412] drm card0-VGA-1: legacy class suspend
[304226.360414] i2c i2c-2: suspend
[304226.360416] drm card0-LVDS-1: legacy class suspend
[304226.360417] i2c i2c-1: suspend
[304226.360419] drm card0: legacy class suspend
[304226.360422] drm controlD64: legacy class suspend
[304226.360463] input input9: type suspend
[304226.360465] input input8: type suspend
[304226.360483] rfkill rfkill1: legacy class suspend
[304226.360485] usb 1-1.6: type suspend
[304226.360487] ieee80211 phy0: legacy class suspend
[304226.360494] usb 1-1.3: type suspend
[304226.360504] usb 2-1: type suspend
[304226.365690] usb 1-1: type suspend
[304226.365693] input input7: type suspend
[304226.365696] input input6: type suspend
[304226.365700] leds tpacpi::thinkvantage: legacy class suspend
[304226.365703] leds tpacpi::unknown_led3: legacy class suspend
[304226.365705] leds tpacpi::unknown_led2: legacy class suspend
[304226.365707] leds tpacpi::dock_status2: legacy class suspend
[304226.365710] leds tpacpi::dock_status1: legacy class suspend
[304226.365712] leds tpacpi::standby: legacy class suspend
[304226.365715] leds tpacpi::unknown_led: legacy class suspend
[304226.365717] leds tpacpi::dock_batt: legacy class suspend
[304226.365719] leds tpacpi::bay_active: legacy class suspend
[304226.365722] leds tpacpi::dock_active: legacy class suspend
[304226.365724] leds tpacpi:green:batt: legacy class suspend
[304226.365726] leds tpacpi:orange:batt: legacy class suspend
[304226.365729] leds tpacpi::power: legacy class suspend
[304226.365731] leds tpacpi::thinklight: legacy class suspend
[304226.365734] rfkill rfkill0: legacy class suspend
[304226.365737] thinkpad_hwmon thinkpad_hwmon: suspend
[304226.365740] thinkpad_acpi thinkpad_acpi: suspend
[304226.365744] i2c i2c-0: suspend
[304226.365748] platform regulatory.0: suspend
[304226.365759] serial8250 serial8250: suspend
[304226.365760] usb usb2: type suspend, may wakeup
[304226.365764] input input5: type suspend
[304226.365767] psmouse serio2: suspend
[304226.365947] usb usb1: type suspend, may wakeup
[304226.549394] input input4: type suspend
[304226.549413] input input3: type suspend
[304226.549423] psmouse serio1: suspend
[304226.549428] sd 0:0:0:0: suspend
[304226.549437] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[304226.590090] sd 0:0:0:0: [sda] Stopping disk
[304226.603724] atkbd serio0: suspend
[304226.604297] i8042 i8042: suspend
[304226.605386] scsi host5: suspend
[304226.605390] scsi host4: suspend
[304226.605394] scsi host3: suspend
[304226.605397] scsi host2: suspend
[304226.605400] scsi host1: suspend
[304226.605451] input input2: type suspend
[304226.605453] input input1: type suspend
[304226.605455] input input0: type suspend
[304226.605458] platform microcode: suspend
[304226.605460] pcspkr pcspkr: suspend
[304226.605489] system 00:0c: legacy suspend
[304226.605491] ACPI handle has no context!
[304226.605495] tpm_tis 00:0b: legacy suspend
[304226.797246] i8042 aux 00:0a: legacy suspend
[304226.797254] i8042 kbd 00:09: legacy suspend
[304226.797261] rtc_cmos 00:08: legacy suspend, may wakeup
[304226.797269] pnp 00:07: legacy suspend
[304226.797272] pnp 00:06: legacy suspend
[304226.797275] pnp 00:05: legacy suspend
[304226.797278] pnp 00:04: legacy suspend
[304226.797281] system 00:03: legacy suspend
[304226.797287] pnp 00:02: legacy suspend
[304226.797290] pnp 00:01: legacy suspend
[304226.797293] system 00:00: legacy suspend
[304226.797331] platform dock.2: suspend
[304226.797334] platform dock.1: suspend
[304226.797337] platform dock.0: suspend
[304226.797340] button LNXPWRBN:00: legacy suspend
[304226.797344] thermal LNXTHERM:01: legacy suspend
[304226.797347] acpi LNXTHERM:00: legacy suspend
[304226.797351] wmi PNP0C14:00: legacy suspend
[304226.797354] acpi PNP0C02:01: legacy suspend
[304226.797357] acpi device:32: legacy suspend
[304226.797360] acpi device:31: legacy suspend
[304226.797363] acpi device:2f: legacy suspend
[304226.797366] acpi device:2e: legacy suspend
[304226.797369] acpi device:2d: legacy suspend
[304226.797372] acpi device:2c: legacy suspend
[304226.797376] acpi device:2b: legacy suspend
[304226.797379] acpi device:2a: legacy suspend
[304226.797382] acpi device:29: legacy suspend
[304226.797388] acpi device:28: legacy suspend
[304226.797390] acpi device:27: legacy suspend
[304226.797391] acpi device:26: legacy suspend
[304226.797393] acpi device:25: legacy suspend
[304226.797396] iwlagn 0000:02:00.0: suspend
[304226.797398] acpi device:24: legacy suspend
[304226.797400] acpi device:23: legacy suspend
[304226.797401] acpi device:22: legacy suspend
[304226.797403] acpi device:21: legacy suspend
[304226.797405] acpi device:20: legacy suspend
[304226.797407] acpi device:1f: legacy suspend
[304226.797408] acpi device:1e: legacy suspend
[304226.797410] acpi device:1d: legacy suspend
[304226.797412] acpi device:1c: legacy suspend
[304226.797413] acpi device:1b: legacy suspend
[304226.797415] acpi device:1a: legacy suspend
[304226.797416] acpi device:19: legacy suspend
[304226.797418] acpi device:18: legacy suspend
[304226.797420] acpi device:17: legacy suspend
[304226.797421] acpi device:16: legacy suspend
[304226.797423] acpi device:15: legacy suspend
[304226.797425] acpi device:14: legacy suspend
[304226.797426] acpi device:13: legacy suspend
[304226.797428] acpi device:12: legacy suspend
[304226.797429] acpi device:11: legacy suspend
[304226.797431] acpi device:10: legacy suspend
[304226.797433] acpi device:0f: legacy suspend
[304226.797434] acpi device:0e: legacy suspend
[304226.797436] acpi device:0d: legacy suspend
[304226.797438] acpi device:0c: legacy suspend
[304226.797440] acpi device:0b: legacy suspend
[304226.797443] acpi LNXVIDEO:01: legacy suspend
[304226.797446] acpi device:0a: legacy suspend
[304226.797448] thinkpad_hotkey IBM0068:00: legacy suspend
[304226.797451] ac ACPI0003:00: legacy suspend
[304226.797453] battery PNP0C0A:00: legacy suspend
[304226.797456] power LNXPOWER:00: legacy suspend
[304226.797458] ec PNP0C09:00: legacy suspend
[304226.797460] acpi SMO1200:00: legacy suspend
[304226.797461] acpi LEN0018:00: legacy suspend
[304226.797463] acpi PNP0303:00: legacy suspend
[304226.797465] acpi PNP0B00:00: legacy suspend
[304226.797466] acpi PNP0C04:00: legacy suspend
[304226.797468] acpi PNP0800:00: legacy suspend
[304226.797470] acpi PNP0200:00: legacy suspend
[304226.797471] acpi PNP0103:00: legacy suspend
[304226.797473] acpi PNP0100:00: legacy suspend
[304226.797475] acpi PNP0000:00: legacy suspend
[304226.797479] intel ips 0000:00:1f.6: suspend
[304226.797482] acpi PNP0C02:00: legacy suspend
[304226.797485] acpi device:09: legacy suspend
[304226.797487] acpi device:08: legacy suspend
[304226.797489] acpi device:07: legacy suspend
[304226.797491] acpi device:06: legacy suspend
[304226.797493] acpi device:05: legacy suspend
[304226.797494] acpi device:04: legacy suspend
[304226.797496] acpi device:03: legacy suspend
[304226.797498] acpi device:02: legacy suspend
[304226.797500] acpi device:01: legacy suspend
[304226.797504] video LNXVIDEO:00: legacy suspend
[304226.797507] i801_smbus 0000:00:1f.3: suspend
[304226.797510] pci_root PNP0A08:00: legacy suspend
[304226.797512] acpi device:00: legacy suspend
[304226.797514] pci_root PNP0A03:00: legacy suspend
[304226.797516] button PNP0C0E:00: legacy suspend
[304226.797518] button PNP0C0D:00: legacy suspend
[304226.797520] acpi PNP0C01:00: legacy suspend
[304226.797522] pci_link PNP0C0F:07: legacy suspend
[304226.797524] pci_link PNP0C0F:06: legacy suspend
[304226.797526] pci_link PNP0C0F:05: legacy suspend
[304226.797528] pci_link PNP0C0F:04: legacy suspend
[304226.797530] pci_link PNP0C0F:03: legacy suspend
[304226.797531] pci_link PNP0C0F:02: legacy suspend
[304226.797533] pci_link PNP0C0F:01: legacy suspend
[304226.797535] pci_link PNP0C0F:00: legacy suspend
[304226.797539] acpi LNXSYBUS:00: legacy suspend
[304226.797541] pci 0000:00:1f.0: suspend
[304226.797543] processor LNXCPU:07: legacy suspend
[304226.797545] pci 0000:00:1e.0: suspend
[304226.797570] ehci_hcd 0000:00:1d.0: suspend
[304226.797572] processor LNXCPU:06: legacy suspend
[304226.797595] processor LNXCPU:05: legacy suspend
[304226.797598] processor LNXCPU:04: legacy suspend
[304226.797622] processor LNXCPU:03: legacy suspend
[304226.797624] processor LNXCPU:02: legacy suspend
[304226.797627] processor LNXCPU:01: legacy suspend
[304226.797629] processor LNXCPU:00: legacy suspend
[304226.797633] acpi LNXSYSTM:00: legacy suspend
[304226.797677] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[304226.797775] pci 0000:00:1c.3: suspend
[304226.797777] pci 0000:00:1c.0: suspend
[304226.797783] HDA Intel 0000:00:1b.0: suspend
[304226.797816] ehci_hcd 0000:00:1a.0: suspend
[304226.797837] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[304226.797842] e1000e 0000:00:19.0: suspend, may wakeup
[304226.797884] serial 0000:00:16.3: suspend
[304226.797911] pci 0000:00:16.0: suspend
[304226.797919] i915 0000:00:02.0: suspend
[304226.797935] agpgart-intel 0000:00:00.0: suspend
[304226.797954] pci 0000:ff:02.3: suspend
[304226.797956] ACPI handle has no context!
[304226.797959] pci 0000:ff:02.2: suspend
[304226.797961] pci 0000:ff:02.1: suspend
[304226.797965] pci 0000:ff:02.0: suspend
[304226.797969] pci 0000:ff:00.1: suspend
[304226.797972] pci 0000:ff:00.0: suspend
[304226.808232] pci 0000:00:1c.4: suspend
[304226.813180] i915 0000:00:02.0: power state changed by ACPI to D3
[304226.899392] HDA Intel 0000:00:1b.0: PCI INT B disabled
[304226.960496] scsi target0:0:0: suspend
[304226.960513] scsi host0: suspend
[304226.960557] ahci 0000:00:1f.2: suspend
[304226.992130] e1000e 0000:00:19.0: PME# enabled
[304226.992137] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[304227.014978] PM: suspend of devices complete after 655.777 msecs
[304227.015021] input input10: LATE type suspend
[304227.015024] i2c i2c-4: LATE suspend
[304227.015026] i2c i2c-3: LATE suspend
[304227.015029] i2c i2c-2: LATE suspend
[304227.015031] i2c i2c-1: LATE suspend
[304227.015038] input input9: LATE type suspend
[304227.015040] input input8: LATE type suspend
[304227.015043] usb 1-1.6: LATE type suspend
[304227.015045] usb 1-1.3: LATE type suspend
[304227.015049] usb 2-1: LATE type suspend
[304227.015051] usb 1-1: LATE type suspend
[304227.015054] input input7: LATE type suspend
[304227.015056] input input6: LATE type suspend
[304227.015059] thinkpad_hwmon thinkpad_hwmon: LATE suspend
[304227.015062] thinkpad_acpi thinkpad_acpi: LATE suspend
[304227.015065] i2c i2c-0: LATE suspend
[304227.015068] platform regulatory.0: LATE suspend
[304227.015071] usb usb2: LATE type suspend, may wakeup
[304227.015074] serial8250 serial8250: LATE suspend
[304227.015076] usb usb1: LATE type suspend, may wakeup
[304227.015079] input input5: LATE type suspend
[304227.015082] psmouse serio2: LATE suspend
[304227.015084] input input4: LATE type suspend
[304227.015087] sd 0:0:0:0: LATE suspend
[304227.015090] scsi target0:0:0: LATE suspend
[304227.015092] input input3: LATE type suspend
[304227.015095] psmouse serio1: LATE suspend
[304227.015097] atkbd serio0: LATE suspend
[304227.015099] i8042 i8042: LATE suspend
[304227.015102] scsi host5: LATE suspend
[304227.015104] scsi host4: LATE suspend
[304227.015106] scsi host3: LATE suspend
[304227.015108] scsi host2: LATE suspend
[304227.015111] scsi host1: LATE suspend
[304227.015113] scsi host0: LATE suspend
[304227.015128] input input2: LATE type suspend
[304227.015133] input input1: LATE type suspend
[304227.015134] input input0: LATE type suspend
[304227.015136] platform microcode: LATE suspend
[304227.015137] pcspkr pcspkr: LATE suspend
[304227.015140] iwlagn 0000:02:00.0: LATE suspend
[304227.015143] intel ips 0000:00:1f.6: LATE suspend
[304227.015174] i801_smbus 0000:00:1f.3: LATE suspend
[304227.015175] ahci 0000:00:1f.2: LATE suspend
[304227.015176] pci 0000:00:1f.0: LATE suspend
[304227.015204] pci 0000:00:1e.0: LATE suspend
[304227.015231] ehci_hcd 0000:00:1d.0: LATE suspend
[304227.027792] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[304227.027800] pci 0000:00:1c.4: LATE suspend
[304227.027859] pci 0000:00:1c.3: LATE suspend
[304227.027916] pci 0000:00:1c.0: LATE suspend
[304227.027961] HDA Intel 0000:00:1b.0: LATE suspend
[304227.027962] ehci_hcd 0000:00:1a.0: LATE suspend
[304227.045790] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[304227.045797] e1000e 0000:00:19.0: LATE suspend, may wakeup
[304227.045801] serial 0000:00:16.3: LATE suspend
[304227.045803] pci 0000:00:16.0: LATE suspend
[304227.045844] i915 0000:00:02.0: LATE suspend
[304227.045846] agpgart-intel 0000:00:00.0: LATE suspend
[304227.045860] pci 0000:ff:02.3: LATE suspend
[304227.045871] pci 0000:ff:02.2: LATE suspend
[304227.045881] pci 0000:ff:02.1: LATE suspend
[304227.045892] pci 0000:ff:02.0: LATE suspend
[304227.045902] pci 0000:ff:00.1: LATE suspend
[304227.045912] pci 0000:ff:00.0: LATE suspend
[304227.045926] platform dock.2: LATE suspend
[304227.045927] platform dock.1: LATE suspend
[304227.045928] platform dock.0: LATE suspend
[304227.045932] PM: late suspend of devices complete after 31.007 msecs
[304227.046073] ACPI: Preparing to enter system sleep state S3
[304227.093682] PM: Saving platform NVS memory
[304227.226130] Disabling non-boot CPUs ...
[304227.239832] CPU 1 is now offline
[304227.259461] CPU 2 is now offline
[304227.270383] CPU 3 is now offline
[304227.270385] SMP alternatives: switching to UP code
[304227.273848] Extended CMOS year: 2000
[304227.274144] Back to C!
[304227.274147] PM: Restoring platform NVS memory
[304227.411523] Extended CMOS year: 2000
[304227.411558] Enabling non-boot CPUs ...
[304227.411969] SMP alternatives: switching to SMP code
[304227.415049] Booting Node 0 Processor 1 APIC 0x1
[304227.521907] CPU1 is up
[304227.521995] Booting Node 0 Processor 2 APIC 0x4
[304227.628708] CPU2 is up
[304227.628810] Booting Node 0 Processor 3 APIC 0x5
[304227.735743] CPU3 is up
[304227.736719] ACPI: Waking up from system sleep state S3
[304227.820577] thinkpad_acpi: EC reports that Thermal Table has changed
[304227.833331] platform dock.0: EARLY resume
[304227.833336] platform dock.1: EARLY resume
[304227.833338] platform dock.2: EARLY resume
[304227.833342] pci 0000:ff:00.0: EARLY resume
[304227.833358] pci 0000:ff:00.1: EARLY resume
[304227.833371] pci 0000:ff:02.0: EARLY resume
[304227.833382] pci 0000:ff:02.1: EARLY resume
[304227.833389] pci 0000:ff:02.2: EARLY resume
[304227.833397] pci 0000:ff:02.3: EARLY resume
[304227.833405] agpgart-intel 0000:00:00.0: EARLY resume
[304227.833417] i915 0000:00:02.0: EARLY resume
[304227.833429] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[304227.833440] pci 0000:00:16.0: EARLY resume
[304227.833481] serial 0000:00:16.3: EARLY resume
[304227.833522] e1000e 0000:00:19.0: EARLY resume
[304227.833569] ehci_hcd 0000:00:1a.0: EARLY resume
[304227.833585] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[304227.833603] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[304227.833611] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[304227.852190] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[304227.854206] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[304227.854214] HDA Intel 0000:00:1b.0: EARLY resume
[304227.854276] pci 0000:00:1c.0: EARLY resume
[304227.854335] pci 0000:00:1c.3: EARLY resume
[304227.854387] pci 0000:00:1c.4: EARLY resume
[304227.854407] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[304227.854420] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[304227.854425] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[304227.854430] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[304227.854439] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[304227.854446] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[304227.854464] ehci_hcd 0000:00:1d.0: EARLY resume
[304227.854481] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[304227.854499] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[304227.854507] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[304227.856197] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[304227.858195] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[304227.858202] pci 0000:00:1e.0: EARLY resume
[304227.858248] pci 0000:00:1f.0: EARLY resume
[304227.858293] ahci 0000:00:1f.2: EARLY resume
[304227.858328] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[304227.858359] i801_smbus 0000:00:1f.3: EARLY resume
[304227.858386] intel ips 0000:00:1f.6: EARLY resume
[304227.858400] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[304227.858422] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[304227.858436] iwlagn 0000:02:00.0: EARLY resume
[304227.858506] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[304227.858569] pcspkr pcspkr: EARLY resume
[304227.858571] platform microcode: EARLY resume
[304227.858573] input input0: EARLY type resume
[304227.858575] input input1: EARLY type resume
[304227.858577] input input2: EARLY type resume
[304227.858617] scsi host0: EARLY resume
[304227.858619] scsi host1: EARLY resume
[304227.858620] scsi host2: EARLY resume
[304227.858622] scsi host3: EARLY resume
[304227.858623] scsi host4: EARLY resume
[304227.858625] scsi host5: EARLY resume
[304227.858627] i8042 i8042: EARLY resume
[304227.858629] atkbd serio0: EARLY resume
[304227.858630] psmouse serio1: EARLY resume
[304227.858633] input input3: EARLY type resume
[304227.858635] scsi target0:0:0: EARLY resume
[304227.858637] sd 0:0:0:0: EARLY resume
[304227.858639] input input4: EARLY type resume
[304227.858641] psmouse serio2: EARLY resume
[304227.858643] input input5: EARLY type resume
[304227.858645] usb usb1: EARLY type resume
[304227.858648] serial8250 serial8250: EARLY resume
[304227.858650] usb usb2: EARLY type resume
[304227.858653] platform regulatory.0: EARLY resume
[304227.858656] i2c i2c-0: EARLY resume
[304227.858658] thinkpad_acpi thinkpad_acpi: EARLY resume
[304227.858660] thinkpad_hwmon thinkpad_hwmon: EARLY resume
[304227.858664] input input6: EARLY type resume
[304227.858666] input input7: EARLY type resume
[304227.858668] usb 1-1: EARLY type resume
[304227.858670] usb 2-1: EARLY type resume
[304227.858673] usb 1-1.3: EARLY type resume
[304227.858675] usb 1-1.6: EARLY type resume
[304227.858677] input input8: EARLY type resume
[304227.858679] input input9: EARLY type resume
[304227.858691] i2c i2c-1: EARLY resume
[304227.858693] i2c i2c-2: EARLY resume
[304227.858694] i2c i2c-3: EARLY resume
[304227.858696] i2c i2c-4: EARLY resume
[304227.858698] input input10: EARLY type resume
[304227.858701] PM: early resume of devices complete after 25.431 msecs
[304227.858828] pci 0000:ff:00.0: resume
[304227.858833] pci 0000:ff:00.1: resume
[304227.858836] pci 0000:ff:02.0: resume
[304227.858839] pci 0000:ff:02.1: resume
[304227.858841] pci 0000:ff:02.2: resume
[304227.858843] pci 0000:ff:02.3: resume
[304227.858845] acpi LNXSYSTM:00: legacy resume
[304227.858848] agpgart-intel 0000:00:00.0: resume
[304227.858850] i915 0000:00:02.0: resume
[304227.858852] processor LNXCPU:00: legacy resume
[304227.858856] processor LNXCPU:01: legacy resume
[304227.858859] processor LNXCPU:02: legacy resume
[304227.858861] processor LNXCPU:03: legacy resume
[304227.858863] processor LNXCPU:04: legacy resume
[304227.858866] processor LNXCPU:05: legacy resume
[304227.858868] processor LNXCPU:06: legacy resume
[304227.858870] i915 0000:00:02.0: power state changed by ACPI to D0
[304227.858873] processor LNXCPU:07: legacy resume
[304227.858875] acpi LNXSYBUS:00: legacy resume
[304227.858878] pci_link PNP0C0F:00: legacy resume
[304227.858881] pci_link PNP0C0F:01: legacy resume
[304227.858883] i915 0000:00:02.0: power state changed by ACPI to D0
[304227.858885] pci_link PNP0C0F:02: legacy resume
[304227.858888] pci_link PNP0C0F:03: legacy resume
[304227.858890] i915 0000:00:02.0: setting latency timer to 64
[304227.858892] pci_link PNP0C0F:04: legacy resume
[304227.858894] pci_link PNP0C0F:05: legacy resume
[304227.858896] pci_link PNP0C0F:06: legacy resume
[304227.858898] pci_link PNP0C0F:07: legacy resume
[304227.858900] acpi PNP0C01:00: legacy resume
[304227.858902] button PNP0C0D:00: legacy resume
[304227.858945] pci 0000:00:16.0: resume
[304227.858948] serial 0000:00:16.3: resume
[304227.858955] e1000e 0000:00:19.0: resume
[304227.858963] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[304227.858971] e1000e 0000:00:19.0: PME# disabled
[304227.859087] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[304227.859150] ehci_hcd 0000:00:1a.0: resume
[304227.859180] HDA Intel 0000:00:1b.0: resume
[304227.859191] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[304227.859198] HDA Intel 0000:00:1b.0: setting latency timer to 64
[304227.859236] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[304227.859273] pci 0000:00:1c.0: resume
[304227.859279] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[304227.859285] pci 0000:00:1c.0: setting latency timer to 64
[304227.859289] pci 0000:00:1c.3: resume
[304227.859295] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[304227.859300] pci 0000:00:1c.3: setting latency timer to 64
[304227.859305] pci 0000:00:1c.4: resume
[304227.859311] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[304227.859316] pci 0000:00:1c.4: setting latency timer to 64
[304227.859321] ehci_hcd 0000:00:1d.0: resume
[304227.859347] pci 0000:00:1e.0: resume
[304227.859355] pci 0000:00:1e.0: setting latency timer to 64
[304227.859360] pci 0000:00:1f.0: resume
[304227.859367] i801_smbus 0000:00:1f.3: resume
[304227.859373] intel ips 0000:00:1f.6: resume
[304227.859375] iwlagn 0000:02:00.0: resume
[304227.859383] ahci 0000:00:1f.2: resume
[304227.859397] ahci 0000:00:1f.2: setting latency timer to 64
[304227.859573] scsi host1: resume
[304227.859575] scsi host0: resume
[304227.859577] scsi host2: resume
[304227.859580] scsi host3: resume
[304227.859585] scsi host4: resume
[304227.859588] scsi host5: resume
[304227.859600] scsi target0:0:0: resume
[304227.859603] sd 0:0:0:0: resume
[304227.859608] sd 0:0:0:0: [sda] Starting disk
[304227.859774] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[304227.859816] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[304227.859972] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[304227.859980] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[304227.859987] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[304227.860026] usb usb2: type resume
[304227.860173] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[304227.860181] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> =
IRQ 23
[304227.860187] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[304227.860219] usb usb1: type resume
[304227.860348] button PNP0C0E:00: legacy resume
[304227.860351] pci_root PNP0A03:00: legacy resume
[304227.860353] acpi device:00: legacy resume
[304227.860355] pci_root PNP0A08:00: legacy resume
[304227.860358] video LNXVIDEO:00: legacy resume
[304227.860360] acpi device:01: legacy resume
[304227.860362] acpi device:02: legacy resume
[304227.860365] acpi device:03: legacy resume
[304227.860367] acpi device:04: legacy resume
[304227.860369] acpi device:05: legacy resume
[304227.860371] acpi device:06: legacy resume
[304227.860373] acpi device:07: legacy resume
[304227.860375] acpi device:08: legacy resume
[304227.860377] acpi device:09: legacy resume
[304227.860379] acpi PNP0C02:00: legacy resume
[304227.860381] acpi PNP0000:00: legacy resume
[304227.860383] acpi PNP0100:00: legacy resume
[304227.860385] acpi PNP0103:00: legacy resume
[304227.860387] acpi PNP0200:00: legacy resume
[304227.860389] acpi PNP0800:00: legacy resume
[304227.860391] acpi PNP0C04:00: legacy resume
[304227.860393] acpi PNP0B00:00: legacy resume
[304227.860395] acpi PNP0303:00: legacy resume
[304227.860397] acpi LEN0018:00: legacy resume
[304227.860399] acpi SMO1200:00: legacy resume
[304227.860402] ec PNP0C09:00: legacy resume
[304227.860404] power LNXPOWER:00: legacy resume
[304227.860563] battery PNP0C0A:00: legacy resume
[304227.876440] ac ACPI0003:00: legacy resume
[304227.876598] thinkpad_hotkey IBM0068:00: legacy resume
[304227.876601] acpi device:0a: legacy resume
[304227.876603] acpi LNXVIDEO:01: legacy resume
[304227.876605] acpi device:0b: legacy resume
[304227.876606] acpi device:0c: legacy resume
[304227.876608] acpi device:0d: legacy resume
[304227.876610] acpi device:0e: legacy resume
[304227.876612] acpi device:0f: legacy resume
[304227.876613] acpi device:10: legacy resume
[304227.876615] acpi device:11: legacy resume
[304227.876617] acpi device:12: legacy resume
[304227.876619] acpi device:13: legacy resume
[304227.876620] acpi device:14: legacy resume
[304227.876622] acpi device:15: legacy resume
[304227.876624] acpi device:16: legacy resume
[304227.876626] acpi device:17: legacy resume
[304227.876628] acpi device:18: legacy resume
[304227.876629] acpi device:19: legacy resume
[304227.876631] acpi device:1a: legacy resume
[304227.876633] acpi device:1b: legacy resume
[304227.876635] acpi device:1c: legacy resume
[304227.876636] acpi device:1d: legacy resume
[304227.876638] acpi device:1e: legacy resume
[304227.876640] acpi device:1f: legacy resume
[304227.876642] acpi device:20: legacy resume
[304227.876643] acpi device:21: legacy resume
[304227.876645] acpi device:22: legacy resume
[304227.876647] acpi device:23: legacy resume
[304227.876649] acpi device:24: legacy resume
[304227.876651] acpi device:25: legacy resume
[304227.876652] acpi device:26: legacy resume
[304227.876654] acpi device:27: legacy resume
[304227.876656] acpi device:28: legacy resume
[304227.876658] acpi device:29: legacy resume
[304227.876659] acpi device:2a: legacy resume
[304227.876661] acpi device:2b: legacy resume
[304227.876663] acpi device:2c: legacy resume
[304227.876665] acpi device:2d: legacy resume
[304227.876666] acpi device:2e: legacy resume
[304227.876668] acpi device:2f: legacy resume
[304227.876670] acpi device:31: legacy resume
[304227.876672] acpi device:32: legacy resume
[304227.876674] acpi PNP0C02:01: legacy resume
[304227.876676] wmi PNP0C14:00: legacy resume
[304227.876678] acpi LNXTHERM:00: legacy resume
[304227.876680] thermal LNXTHERM:01: legacy resume
[304227.877131] button LNXPWRBN:00: legacy resume
[304227.877134] platform dock.0: resume
[304227.877136] platform dock.1: resume
[304227.877138] platform dock.2: resume
[304227.877143] system 00:00: legacy resume
[304227.877147] pnp 00:01: legacy resume
[304227.877148] pnp 00:02: legacy resume
[304227.877150] system 00:03: legacy resume
[304227.877153] pnp 00:04: legacy resume
[304227.877154] pnp 00:05: legacy resume
[304227.877156] pnp 00:06: legacy resume
[304227.877158] pnp 00:07: legacy resume
[304227.877160] rtc_cmos 00:08: legacy resume
[304227.877163] i8042 kbd 00:09: legacy resume
[304227.877166] i8042 aux 00:0a: legacy resume
[304227.877168] tpm_tis 00:0b: legacy resume
[304227.900071] usb 2-1: type resume
[304227.901067] usb 1-1: type resume
[304227.910057] system 00:0c: legacy resume
[304227.910074] pcspkr pcspkr: resume
[304227.910076] platform microcode: resume
[304227.910078] input input0: type resume
[304227.910081] input input1: type resume
[304227.910098] input input2: type resume
[304227.910197] i8042 i8042: resume
[304227.911081] atkbd serio0: resume
[304227.911086] psmouse serio1: resume
[304227.911089] input input3: type resume
[304228.001908] usb 1-1.3: type resume
[304228.001911] usb 1-1.6: type resume
[304228.074975] usb 1-1.3: reset full speed USB device using ehci_hcd and a=
ddress 3
[304228.165614] ata2: SATA link down (SStatus 0 SControl 300)
[304228.167610] ata5: SATA link down (SStatus 0 SControl 300)
[304228.169601] ata6: SATA link down (SStatus 0 SControl 300)
[304228.232623] usb 1-1.6: reset high speed USB device using ehci_hcd and a=
ddress 5
[304230.355643] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[304230.357964] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[304230.357971] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[304230.357977] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[304230.362701] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[304230.362708] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[304230.362714] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[304230.364773] ata1.00: configured for UDMA/100
[304230.369385] ata1.00: configured for UDMA/100
[304230.369391] ata1: EH complete
[304230.395417] input input4: type resume
[304230.395430] psmouse serio2: resume
[304230.395440] input input5: type resume
[304230.395467] serial8250 serial8250: resume
[304230.395525] platform regulatory.0: resume
[304230.395536] i2c i2c-0: resume
[304230.395545] thinkpad_acpi thinkpad_acpi: resume
[304230.397399] thinkpad_hwmon thinkpad_hwmon: resume
[304230.397403] rfkill rfkill0: legacy class resume
[304230.397406] leds tpacpi::thinklight: legacy class resume
[304230.397408] leds tpacpi::power: legacy class resume
[304230.397411] leds tpacpi:orange:batt: legacy class resume
[304230.397413] leds tpacpi:green:batt: legacy class resume
[304230.397415] leds tpacpi::dock_active: legacy class resume
[304230.397417] leds tpacpi::bay_active: legacy class resume
[304230.397419] leds tpacpi::dock_batt: legacy class resume
[304230.397421] leds tpacpi::unknown_led: legacy class resume
[304230.397424] leds tpacpi::standby: legacy class resume
[304230.397426] leds tpacpi::dock_status1: legacy class resume
[304230.397428] leds tpacpi::dock_status2: legacy class resume
[304230.397430] leds tpacpi::unknown_led2: legacy class resume
[304230.397432] leds tpacpi::unknown_led3: legacy class resume
[304230.397434] leds tpacpi::thinkvantage: legacy class resume
[304230.397436] input input6: type resume
[304230.397446] input input7: type resume
[304230.397454] ieee80211 phy0: legacy class resume
[304230.487651] rfkill rfkill1: legacy class resume
[304230.487677] input input8: type resume
[304230.487686] input input9: type resume
[304230.487726] drm controlD64: legacy class resume
[304230.487729] drm card0: legacy class resume
[304230.487732] i2c i2c-1: resume
[304230.487734] drm card0-LVDS-1: legacy class resume
[304230.487737] i2c i2c-2: resume
[304230.487739] drm card0-VGA-1: legacy class resume
[304230.487741] i2c i2c-3: resume
[304230.487744] drm card0-HDMI Type A-1: legacy class resume
[304230.487747] drm card0-DisplayPort-1: legacy class resume
[304230.487749] i2c i2c-4: resume
[304230.487752] backlight acpi_video0: legacy class resume
[304230.487756] input input10: type resume
[304230.487765] PM: resume of devices complete after 2633.798 msecs
[304230.487783] usb 1-1.6: completing type resume
[304230.487786] usb 1-1.3: completing type resume
[304230.487788] usb 2-1: completing type resume
[304230.487792] usb 1-1: completing type resume
[304230.487797] thinkpad_hwmon thinkpad_hwmon: completing resume
[304230.487800] thinkpad_acpi thinkpad_acpi: completing resume
[304230.487803] platform regulatory.0: completing resume
[304230.487807] usb usb2: completing type resume
[304230.487810] serial8250 serial8250: completing resume
[304230.487813] usb usb1: completing type resume
[304230.487822] i8042 i8042: completing resume
[304230.487932] platform microcode: completing resume
[304230.487934] pcspkr pcspkr: completing resume
[304230.487956] iwlagn 0000:02:00.0: completing resume
[304230.487960] intel ips 0000:00:1f.6: completing resume
[304230.487963] i801_smbus 0000:00:1f.3: completing resume
[304230.487965] ahci 0000:00:1f.2: completing resume
[304230.487968] pci 0000:00:1f.0: completing resume
[304230.487970] pci 0000:00:1e.0: completing resume
[304230.487973] ehci_hcd 0000:00:1d.0: completing resume
[304230.487976] pci 0000:00:1c.4: completing resume
[304230.487978] pci 0000:00:1c.3: completing resume
[304230.487980] pci 0000:00:1c.0: completing resume
[304230.487983] HDA Intel 0000:00:1b.0: completing resume
[304230.487986] ehci_hcd 0000:00:1a.0: completing resume
[304230.487988] e1000e 0000:00:19.0: completing resume
[304230.487992] serial 0000:00:16.3: completing resume
[304230.487994] pci 0000:00:16.0: completing resume
[304230.487997] i915 0000:00:02.0: completing resume
[304230.487999] agpgart-intel 0000:00:00.0: completing resume
[304230.488003] pci 0000:ff:02.3: completing resume
[304230.488005] pci 0000:ff:02.2: completing resume
[304230.488008] pci 0000:ff:02.1: completing resume
[304230.488010] pci 0000:ff:02.0: completing resume
[304230.488012] pci 0000:ff:00.1: completing resume
[304230.488015] pci 0000:ff:00.0: completing resume
[304230.488018] platform dock.2: completing resume
[304230.488021] platform dock.1: completing resume
[304230.488023] platform dock.0: completing resume
[304230.488631] PM: Finishing wakeup.
[304230.488633] Restarting tasks ... done.
[304230.492286] video LNXVIDEO:00: Restoring backlight state
[304231.105253] usb 1-1.4: new full speed USB device using ehci_hcd and add=
ress 48
[304231.194353] PM: Adding info for usb:1-1.4
[304231.194496] PM: Adding info for usb:1-1.4:1.0
[304231.194606] PM: Adding info for No Bus:hci0
[304231.194641] PM: Adding info for No Bus:rfkill7
[304231.194674] PM: Adding info for No Bus:ep_81
[304231.194687] PM: Adding info for No Bus:ep_82
[304231.194700] PM: Adding info for No Bus:ep_02
[304231.194715] PM: Adding info for usb:1-1.4:1.1
[304231.194739] PM: Adding info for No Bus:ep_83
[304231.194751] PM: Adding info for No Bus:ep_03
[304231.194764] PM: Adding info for usb:1-1.4:1.2
[304231.194807] PM: Adding info for No Bus:ep_84
[304231.194819] PM: Adding info for No Bus:ep_04
[304231.194833] PM: Adding info for usb:1-1.4:1.3
[304231.194871] PM: Adding info for No Bus:ep_00
[304951.572592] add_index: xtInsert failed!
[304951.572597] add_index: xtInsert failed!
[304951.572618] add_index: xtInsert failed!
[304951.572620] add_index: xtInsert failed!
[305231.955597] usb 1-1.4: USB disconnect, address 48
[305231.955625] btusb_intr_complete: hci0 urb ffff88009638c6c0 failed to re=
submit (19)
[305231.955710] btusb_bulk_complete: hci0 urb ffff88009638c000 failed to re=
submit (19)
[305231.955714] btusb_bulk_complete: hci0 urb ffff88009638c0c0 failed to re=
submit (19)
[305231.955725] PM: Removing info for No Bus:ep_81
[305231.955745] PM: Removing info for No Bus:ep_82
[305231.955755] PM: Removing info for No Bus:ep_02
[305231.955766] PM: Removing info for usb:1-1.4:1.0
[305231.955969] btusb_send_frame: hci0 urb ffff8800802140c0 submission fail=
ed
[305232.205088] PM: Removing info for No Bus:rfkill7
[305232.205164] PM: Removing info for No Bus:hci0
[305232.205282] PM: Removing info for No Bus:ep_83
[305232.205311] PM: Removing info for No Bus:ep_03
[305232.205321] PM: Removing info for usb:1-1.4:1.1
[305232.205346] PM: Removing info for No Bus:ep_84
[305232.205358] PM: Removing info for No Bus:ep_04
[305232.205369] PM: Removing info for usb:1-1.4:1.2
[305232.205391] PM: Removing info for usb:1-1.4:1.3
[305232.205413] PM: Removing info for No Bus:ep_00
[305232.205423] PM: Removing info for usb:1-1.4
[305232.833321] PM: Syncing filesystems ... done.
[305232.858557] PM: Preparing system for mem sleep
[305233.867937] Freezing user space processes ... (elapsed 0.01 seconds) do=
ne.
[305233.879035] Freezing remaining freezable tasks ... (elapsed 0.01 second=
s) done.
[305233.890055] PM: Entering mem sleep
[305233.890174] Suspending console(s) (use no_console_suspend to debug)
[305233.890202] platform dock.0: preparing suspend
[305233.890204] platform dock.1: preparing suspend
[305233.890206] platform dock.2: preparing suspend
[305233.890209] pci 0000:ff:00.0: preparing suspend
[305233.890211] pci 0000:ff:00.1: preparing suspend
[305233.890213] pci 0000:ff:02.0: preparing suspend
[305233.890215] pci 0000:ff:02.1: preparing suspend
[305233.890217] pci 0000:ff:02.2: preparing suspend
[305233.890219] pci 0000:ff:02.3: preparing suspend
[305233.890221] agpgart-intel 0000:00:00.0: preparing suspend
[305233.890224] i915 0000:00:02.0: preparing suspend
[305233.890226] pci 0000:00:16.0: preparing suspend
[305233.890229] serial 0000:00:16.3: preparing suspend
[305233.890231] e1000e 0000:00:19.0: preparing suspend, may wakeup
[305233.890234] ehci_hcd 0000:00:1a.0: preparing suspend
[305233.890236] HDA Intel 0000:00:1b.0: preparing suspend
[305233.890238] pci 0000:00:1c.0: preparing suspend
[305233.890240] pci 0000:00:1c.3: preparing suspend
[305233.890242] pci 0000:00:1c.4: preparing suspend
[305233.890244] ehci_hcd 0000:00:1d.0: preparing suspend
[305233.890246] pci 0000:00:1e.0: preparing suspend
[305233.890248] pci 0000:00:1f.0: preparing suspend
[305233.890250] ahci 0000:00:1f.2: preparing suspend
[305233.890252] i801_smbus 0000:00:1f.3: preparing suspend
[305233.890255] intel ips 0000:00:1f.6: preparing suspend
[305233.890257] iwlagn 0000:02:00.0: preparing suspend
[305233.890273] pcspkr pcspkr: preparing suspend
[305233.890275] platform microcode: preparing suspend
[305233.890353] i8042 i8042: preparing suspend
[305233.890362] usb usb1: preparing type suspend, may wakeup
[305233.890366] serial8250 serial8250: preparing suspend
[305233.890369] usb usb2: preparing type suspend, may wakeup
[305233.890374] platform regulatory.0: preparing suspend
[305233.890377] thinkpad_acpi thinkpad_acpi: preparing suspend
[305233.890380] thinkpad_hwmon thinkpad_hwmon: preparing suspend
[305233.890388] usb 1-1: preparing type suspend
[305233.890391] usb 2-1: preparing type suspend
[305233.890394] usb 1-1.3: preparing type suspend
[305233.890397] usb 1-1.6: preparing type suspend
[305233.890426] input input10: type suspend
[305233.890430] backlight acpi_video0: legacy class suspend
[305233.890433] i2c i2c-4: suspend
[305233.890436] drm card0-DisplayPort-1: legacy class suspend
[305233.890438] drm card0-HDMI Type A-1: legacy class suspend
[305233.890440] i2c i2c-3: suspend
[305233.890442] drm card0-VGA-1: legacy class suspend
[305233.890444] i2c i2c-2: suspend
[305233.890446] drm card0-LVDS-1: legacy class suspend
[305233.890448] i2c i2c-1: suspend
[305233.890451] drm card0: legacy class suspend
[305233.890453] drm controlD64: legacy class suspend
[305233.890496] input input9: type suspend
[305233.890499] input input8: type suspend
[305233.890518] rfkill rfkill1: legacy class suspend
[305233.890521] usb 1-1.6: type suspend
[305233.890523] ieee80211 phy0: legacy class suspend
[305233.890531] usb 1-1.3: type suspend
[305233.890538] usb 2-1: type suspend
[305233.894959] usb 1-1: type suspend
[305233.894962] input input7: type suspend
[305233.894966] input input6: type suspend
[305233.894970] leds tpacpi::thinkvantage: legacy class suspend
[305233.894973] leds tpacpi::unknown_led3: legacy class suspend
[305233.894976] leds tpacpi::unknown_led2: legacy class suspend
[305233.894979] leds tpacpi::dock_status2: legacy class suspend
[305233.894982] leds tpacpi::dock_status1: legacy class suspend
[305233.894985] leds tpacpi::standby: legacy class suspend
[305233.894988] leds tpacpi::unknown_led: legacy class suspend
[305233.894990] leds tpacpi::dock_batt: legacy class suspend
[305233.894993] leds tpacpi::bay_active: legacy class suspend
[305233.894996] leds tpacpi::dock_active: legacy class suspend
[305233.894998] leds tpacpi:green:batt: legacy class suspend
[305233.895001] leds tpacpi:orange:batt: legacy class suspend
[305233.895004] leds tpacpi::power: legacy class suspend
[305233.895007] leds tpacpi::thinklight: legacy class suspend
[305233.895010] rfkill rfkill0: legacy class suspend
[305233.895013] thinkpad_hwmon thinkpad_hwmon: suspend
[305233.895017] thinkpad_acpi thinkpad_acpi: suspend
[305233.895022] i2c i2c-0: suspend
[305233.895027] platform regulatory.0: suspend
[305233.895039] serial8250 serial8250: suspend
[305233.895043] usb usb2: type suspend, may wakeup
[305233.895046] input input5: type suspend
[305233.895050] psmouse serio2: suspend
[305233.895075] usb usb1: type suspend, may wakeup
[305234.074542] input input4: type suspend
[305234.074562] input input3: type suspend
[305234.074572] psmouse serio1: suspend
[305234.074581] sd 0:0:0:0: suspend
[305234.074590] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[305234.117096] sd 0:0:0:0: [sda] Stopping disk
[305234.128877] atkbd serio0: suspend
[305234.129435] i8042 i8042: suspend
[305234.130053] scsi host5: suspend
[305234.130059] scsi host4: suspend
[305234.130063] scsi host3: suspend
[305234.130066] scsi host2: suspend
[305234.130069] scsi host1: suspend
[305234.130112] input input2: type suspend
[305234.130114] input input1: type suspend
[305234.130117] input input0: type suspend
[305234.130120] platform microcode: suspend
[305234.130122] pcspkr pcspkr: suspend
[305234.130146] system 00:0c: legacy suspend
[305234.130148] ACPI handle has no context!
[305234.130153] tpm_tis 00:0b: legacy suspend
[305234.321289] i8042 aux 00:0a: legacy suspend
[305234.321297] i8042 kbd 00:09: legacy suspend
[305234.321304] rtc_cmos 00:08: legacy suspend, may wakeup
[305234.321313] pnp 00:07: legacy suspend
[305234.321316] pnp 00:06: legacy suspend
[305234.321319] pnp 00:05: legacy suspend
[305234.321322] pnp 00:04: legacy suspend
[305234.321325] system 00:03: legacy suspend
[305234.321330] pnp 00:02: legacy suspend
[305234.321333] pnp 00:01: legacy suspend
[305234.321336] system 00:00: legacy suspend
[305234.321372] platform dock.2: suspend
[305234.321375] platform dock.1: suspend
[305234.321377] platform dock.0: suspend
[305234.321381] button LNXPWRBN:00: legacy suspend
[305234.321385] thermal LNXTHERM:01: legacy suspend
[305234.321388] acpi LNXTHERM:00: legacy suspend
[305234.321391] wmi PNP0C14:00: legacy suspend
[305234.321395] acpi PNP0C02:01: legacy suspend
[305234.321398] acpi device:32: legacy suspend
[305234.321401] acpi device:31: legacy suspend
[305234.321404] acpi device:2f: legacy suspend
[305234.321410] acpi device:2e: legacy suspend
[305234.321412] iwlagn 0000:02:00.0: suspend
[305234.321415] acpi device:2d: legacy suspend
[305234.321417] acpi device:2c: legacy suspend
[305234.321420] acpi device:2b: legacy suspend
[305234.321422] acpi device:2a: legacy suspend
[305234.321424] acpi device:29: legacy suspend
[305234.321426] acpi device:28: legacy suspend
[305234.321428] acpi device:27: legacy suspend
[305234.321429] acpi device:26: legacy suspend
[305234.321431] acpi device:25: legacy suspend
[305234.321433] acpi device:24: legacy suspend
[305234.321435] acpi device:23: legacy suspend
[305234.321437] acpi device:22: legacy suspend
[305234.321438] acpi device:21: legacy suspend
[305234.321441] acpi device:20: legacy suspend
[305234.321443] acpi device:1f: legacy suspend
[305234.321444] acpi device:1e: legacy suspend
[305234.321446] acpi device:1d: legacy suspend
[305234.321448] acpi device:1c: legacy suspend
[305234.321450] acpi device:1b: legacy suspend
[305234.321451] acpi device:1a: legacy suspend
[305234.321453] acpi device:19: legacy suspend
[305234.321455] acpi device:18: legacy suspend
[305234.321457] acpi device:17: legacy suspend
[305234.321459] acpi device:16: legacy suspend
[305234.321462] acpi device:15: legacy suspend
[305234.321464] acpi device:14: legacy suspend
[305234.321467] acpi device:13: legacy suspend
[305234.321469] acpi device:12: legacy suspend
[305234.321471] acpi device:11: legacy suspend
[305234.321474] acpi device:10: legacy suspend
[305234.321476] acpi device:0f: legacy suspend
[305234.321479] acpi device:0e: legacy suspend
[305234.321481] acpi device:0d: legacy suspend
[305234.321483] acpi device:0c: legacy suspend
[305234.321486] acpi device:0b: legacy suspend
[305234.321489] acpi LNXVIDEO:01: legacy suspend
[305234.321492] acpi device:0a: legacy suspend
[305234.321495] thinkpad_hotkey IBM0068:00: legacy suspend
[305234.321498] ac ACPI0003:00: legacy suspend
[305234.321502] intel ips 0000:00:1f.6: suspend
[305234.321505] battery PNP0C0A:00: legacy suspend
[305234.321508] power LNXPOWER:00: legacy suspend
[305234.321512] ec PNP0C09:00: legacy suspend
[305234.321514] acpi SMO1200:00: legacy suspend
[305234.321516] acpi LEN0018:00: legacy suspend
[305234.321517] acpi PNP0303:00: legacy suspend
[305234.321519] acpi PNP0B00:00: legacy suspend
[305234.321521] acpi PNP0C04:00: legacy suspend
[305234.321524] acpi PNP0800:00: legacy suspend
[305234.321527] acpi PNP0200:00: legacy suspend
[305234.321529] i801_smbus 0000:00:1f.3: suspend
[305234.321539] acpi PNP0103:00: legacy suspend
[305234.321541] acpi PNP0100:00: legacy suspend
[305234.321543] acpi PNP0000:00: legacy suspend
[305234.321545] acpi PNP0C02:00: legacy suspend
[305234.321548] acpi device:09: legacy suspend
[305234.321550] acpi device:08: legacy suspend
[305234.321552] acpi device:07: legacy suspend
[305234.321553] acpi device:06: legacy suspend
[305234.321555] acpi device:05: legacy suspend
[305234.321557] acpi device:04: legacy suspend
[305234.321559] acpi device:03: legacy suspend
[305234.321561] acpi device:02: legacy suspend
[305234.321563] acpi device:01: legacy suspend
[305234.321565] video LNXVIDEO:00: legacy suspend
[305234.321569] pci_root PNP0A08:00: legacy suspend
[305234.321571] acpi device:00: legacy suspend
[305234.321572] pci_root PNP0A03:00: legacy suspend
[305234.321574] button PNP0C0E:00: legacy suspend
[305234.321576] button PNP0C0D:00: legacy suspend
[305234.321578] acpi PNP0C01:00: legacy suspend
[305234.321581] pci_link PNP0C0F:07: legacy suspend
[305234.321584] pci_link PNP0C0F:06: legacy suspend
[305234.321587] pci_link PNP0C0F:05: legacy suspend
[305234.321589] pci 0000:00:1f.0: suspend
[305234.321591] pci_link PNP0C0F:04: legacy suspend
[305234.321594] pci 0000:00:1e.0: suspend
[305234.321596] pci_link PNP0C0F:03: legacy suspend
[305234.321598] ehci_hcd 0000:00:1d.0: suspend
[305234.321600] pci_link PNP0C0F:02: legacy suspend
[305234.321615] pci_link PNP0C0F:01: legacy suspend
[305234.321618] pci_link PNP0C0F:00: legacy suspend
[305234.321643] acpi LNXSYBUS:00: legacy suspend
[305234.321646] processor LNXCPU:07: legacy suspend
[305234.321668] processor LNXCPU:06: legacy suspend
[305234.321670] processor LNXCPU:05: legacy suspend
[305234.321673] processor LNXCPU:04: legacy suspend
[305234.321676] processor LNXCPU:03: legacy suspend
[305234.321678] processor LNXCPU:02: legacy suspend
[305234.321681] processor LNXCPU:01: legacy suspend
[305234.321683] processor LNXCPU:00: legacy suspend
[305234.321687] acpi LNXSYSTM:00: legacy suspend
[305234.321698] ehci_hcd 0000:00:1d.0: PCI INT D disabled
[305234.321773] pci 0000:00:1c.3: suspend
[305234.321776] pci 0000:00:1c.0: suspend
[305234.321779] HDA Intel 0000:00:1b.0: suspend
[305234.321811] ehci_hcd 0000:00:1a.0: suspend
[305234.321832] ehci_hcd 0000:00:1a.0: PCI INT D disabled
[305234.321838] e1000e 0000:00:19.0: suspend, may wakeup
[305234.321882] serial 0000:00:16.3: suspend
[305234.321917] pci 0000:00:16.0: suspend
[305234.321925] i915 0000:00:02.0: suspend
[305234.321940] agpgart-intel 0000:00:00.0: suspend
[305234.321954] ACPI handle has no context!
[305234.321961] pci 0000:ff:02.3: suspend
[305234.321965] pci 0000:ff:02.2: suspend
[305234.321968] pci 0000:ff:02.1: suspend
[305234.321971] pci 0000:ff:02.0: suspend
[305234.321975] pci 0000:ff:00.1: suspend
[305234.321978] pci 0000:ff:00.0: suspend
[305234.332252] pci 0000:00:1c.4: suspend
[305234.337261] i915 0000:00:02.0: power state changed by ACPI to D3
[305234.423466] HDA Intel 0000:00:1b.0: PCI INT B disabled
[305234.512628] scsi target0:0:0: suspend
[305234.512673] scsi host0: suspend
[305234.512684] ahci 0000:00:1f.2: suspend
[305234.517340] e1000e 0000:00:19.0: PME# enabled
[305234.517348] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[305234.566909] PM: suspend of devices complete after 677.721 msecs
[305234.566952] input input10: LATE type suspend
[305234.566955] i2c i2c-4: LATE suspend
[305234.566958] i2c i2c-3: LATE suspend
[305234.566960] i2c i2c-2: LATE suspend
[305234.566963] i2c i2c-1: LATE suspend
[305234.566969] input input9: LATE type suspend
[305234.566972] input input8: LATE type suspend
[305234.566975] usb 1-1.6: LATE type suspend
[305234.566977] usb 1-1.3: LATE type suspend
[305234.566980] usb 2-1: LATE type suspend
[305234.566983] usb 1-1: LATE type suspend
[305234.566986] input input7: LATE type suspend
[305234.566988] input input6: LATE type suspend
[305234.566991] thinkpad_hwmon thinkpad_hwmon: LATE suspend
[305234.566994] thinkpad_acpi thinkpad_acpi: LATE suspend
[305234.566997] i2c i2c-0: LATE suspend
[305234.567000] platform regulatory.0: LATE suspend
[305234.567003] usb usb2: LATE type suspend, may wakeup
[305234.567006] serial8250 serial8250: LATE suspend
[305234.567009] usb usb1: LATE type suspend, may wakeup
[305234.567011] input input5: LATE type suspend
[305234.567014] psmouse serio2: LATE suspend
[305234.567016] input input4: LATE type suspend
[305234.567022] sd 0:0:0:0: LATE suspend
[305234.567024] scsi target0:0:0: LATE suspend
[305234.567026] input input3: LATE type suspend
[305234.567027] psmouse serio1: LATE suspend
[305234.567029] atkbd serio0: LATE suspend
[305234.567030] i8042 i8042: LATE suspend
[305234.567032] scsi host5: LATE suspend
[305234.567033] scsi host4: LATE suspend
[305234.567035] scsi host3: LATE suspend
[305234.567036] scsi host2: LATE suspend
[305234.567037] scsi host1: LATE suspend
[305234.567039] scsi host0: LATE suspend
[305234.567049] input input2: LATE type suspend
[305234.567051] input input1: LATE type suspend
[305234.567052] input input0: LATE type suspend
[305234.567054] platform microcode: LATE suspend
[305234.567056] pcspkr pcspkr: LATE suspend
[305234.567059] iwlagn 0000:02:00.0: LATE suspend
[305234.567061] intel ips 0000:00:1f.6: LATE suspend
[305234.567093] i801_smbus 0000:00:1f.3: LATE suspend
[305234.567095] ahci 0000:00:1f.2: LATE suspend
[305234.567097] pci 0000:00:1f.0: LATE suspend
[305234.567126] pci 0000:00:1e.0: LATE suspend
[305234.567153] ehci_hcd 0000:00:1d.0: LATE suspend
[305234.579842] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3
[305234.579849] pci 0000:00:1c.4: LATE suspend
[305234.579904] pci 0000:00:1c.3: LATE suspend
[305234.579955] pci 0000:00:1c.0: LATE suspend
[305234.580002] HDA Intel 0000:00:1b.0: LATE suspend
[305234.580004] ehci_hcd 0000:00:1a.0: LATE suspend
[305234.597751] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3
[305234.597758] e1000e 0000:00:19.0: LATE suspend, may wakeup
[305234.597761] serial 0000:00:16.3: LATE suspend
[305234.597764] pci 0000:00:16.0: LATE suspend
[305234.597804] i915 0000:00:02.0: LATE suspend
[305234.597806] agpgart-intel 0000:00:00.0: LATE suspend
[305234.597821] pci 0000:ff:02.3: LATE suspend
[305234.597831] pci 0000:ff:02.2: LATE suspend
[305234.597844] pci 0000:ff:02.1: LATE suspend
[305234.597850] pci 0000:ff:02.0: LATE suspend
[305234.597857] pci 0000:ff:00.1: LATE suspend
[305234.597863] pci 0000:ff:00.0: LATE suspend
[305234.597870] platform dock.2: LATE suspend
[305234.597872] platform dock.1: LATE suspend
[305234.597874] platform dock.0: LATE suspend
[305234.597878] PM: late suspend of devices complete after 31.022 msecs
[305234.598017] ACPI: Preparing to enter system sleep state S3
[305234.645718] PM: Saving platform NVS memory
[305234.776175] Disabling non-boot CPUs ...
[305234.789847] CPU 1 is now offline
[305234.809458] CPU 2 is now offline
[305234.822375] CPU 3 is now offline
[305234.822377] SMP alternatives: switching to UP code
[305234.826101] Extended CMOS year: 2000
[305234.826397] Back to C!
[305234.826401] PM: Restoring platform NVS memory
[305234.963728] Extended CMOS year: 2000
[305234.963763] Enabling non-boot CPUs ...
[305234.963911] SMP alternatives: switching to SMP code
[305234.966969] Booting Node 0 Processor 1 APIC 0x1
[305235.073871] CPU1 is up
[305235.073960] Booting Node 0 Processor 2 APIC 0x4
[305235.180677] CPU2 is up
[305235.180774] Booting Node 0 Processor 3 APIC 0x5
[305235.287637] CPU3 is up
[305235.288591] ACPI: Waking up from system sleep state S3
[305235.365245] platform dock.0: EARLY resume
[305235.365250] platform dock.1: EARLY resume
[305235.365254] platform dock.2: EARLY resume
[305235.365257] pci 0000:ff:00.0: EARLY resume
[305235.365276] pci 0000:ff:00.1: EARLY resume
[305235.365292] pci 0000:ff:02.0: EARLY resume
[305235.365307] pci 0000:ff:02.1: EARLY resume
[305235.365314] pci 0000:ff:02.2: EARLY resume
[305235.365322] pci 0000:ff:02.3: EARLY resume
[305235.365330] agpgart-intel 0000:00:00.0: EARLY resume
[305235.365342] i915 0000:00:02.0: EARLY resume
[305235.365354] i915 0000:00:02.0: restoring config space at offset 0x1 (wa=
s 0x900007, writing 0x900407)
[305235.365365] pci 0000:00:16.0: EARLY resume
[305235.365406] serial 0000:00:16.3: EARLY resume
[305235.365446] e1000e 0000:00:19.0: EARLY resume
[305235.365491] ehci_hcd 0000:00:1a.0: EARLY resume
[305235.365507] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[305235.365526] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728000)
[305235.365534] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[305235.376182] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[305235.378199] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[305235.378207] HDA Intel 0000:00:1b.0: EARLY resume
[305235.378270] pci 0000:00:1c.0: EARLY resume
[305235.378329] pci 0000:00:1c.3: EARLY resume
[305235.378381] pci 0000:00:1c.4: EARLY resume
[305235.378400] pci 0000:00:1c.4: restoring config space at offset 0xf (was=
 0x100, writing 0x4010b)
[305235.378412] pci 0000:00:1c.4: restoring config space at offset 0x9 (was=
 0x10001, writing 0x1fff1)
[305235.378417] pci 0000:00:1c.4: restoring config space at offset 0x8 (was=
 0x0, writing 0xf240f240)
[305235.378423] pci 0000:00:1c.4: restoring config space at offset 0x7 (was=
 0x0, writing 0xf0)
[305235.378432] pci 0000:00:1c.4: restoring config space at offset 0x3 (was=
 0x810000, writing 0x810010)
[305235.378438] pci 0000:00:1c.4: restoring config space at offset 0x1 (was=
 0x100000, writing 0x100107)
[305235.378456] ehci_hcd 0000:00:1d.0: EARLY resume
[305235.378472] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf=
 (was 0x400, writing 0x40b)
[305235.378490] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4=
 (was 0x0, writing 0xf2728400)
[305235.378499] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1=
 (was 0x2900000, writing 0x2900102)
[305235.380192] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[305235.382191] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[305235.382199] pci 0000:00:1e.0: EARLY resume
[305235.382244] pci 0000:00:1f.0: EARLY resume
[305235.382288] ahci 0000:00:1f.2: EARLY resume
[305235.382323] ahci 0000:00:1f.2: restoring config space at offset 0x1 (wa=
s 0x2b00007, writing 0x2b00407)
[305235.382354] i801_smbus 0000:00:1f.3: EARLY resume
[305235.382382] intel ips 0000:00:1f.6: EARLY resume
[305235.382396] intel ips 0000:00:1f.6: restoring config space at offset 0x=
f (was 0x400, writing 0x40b)
[305235.382419] intel ips 0000:00:1f.6: restoring config space at offset 0x=
1 (was 0x100000, writing 0x100002)
[305235.382432] iwlagn 0000:02:00.0: EARLY resume
[305235.382502] iwlagn 0000:02:00.0: restoring config space at offset 0x1 (=
was 0x100106, writing 0x100506)
[305235.382566] pcspkr pcspkr: EARLY resume
[305235.382568] platform microcode: EARLY resume
[305235.382570] input input0: EARLY type resume
[305235.382572] input input1: EARLY type resume
[305235.382574] input input2: EARLY type resume
[305235.382614] scsi host0: EARLY resume
[305235.382616] scsi host1: EARLY resume
[305235.382617] scsi host2: EARLY resume
[305235.382619] scsi host3: EARLY resume
[305235.382620] scsi host4: EARLY resume
[305235.382622] scsi host5: EARLY resume
[305235.382624] i8042 i8042: EARLY resume
[305235.382626] atkbd serio0: EARLY resume
[305235.382628] psmouse serio1: EARLY resume
[305235.382630] input input3: EARLY type resume
[305235.382632] scsi target0:0:0: EARLY resume
[305235.382634] sd 0:0:0:0: EARLY resume
[305235.382637] input input4: EARLY type resume
[305235.382639] psmouse serio2: EARLY resume
[305235.382641] input input5: EARLY type resume
[305235.382643] usb usb1: EARLY type resume
[305235.382645] serial8250 serial8250: EARLY resume
[305235.382648] usb usb2: EARLY type resume
[305235.382651] platform regulatory.0: EARLY resume
[305235.382654] i2c i2c-0: EARLY resume
[305235.382656] thinkpad_acpi thinkpad_acpi: EARLY resume
[305235.382658] thinkpad_hwmon thinkpad_hwmon: EARLY resume
[305235.382661] input input6: EARLY type resume
[305235.382663] input input7: EARLY type resume
[305235.382666] usb 1-1: EARLY type resume
[305235.382668] usb 2-1: EARLY type resume
[305235.382670] usb 1-1.3: EARLY type resume
[305235.382673] usb 1-1.6: EARLY type resume
[305235.382675] input input8: EARLY type resume
[305235.382677] input input9: EARLY type resume
[305235.382689] i2c i2c-1: EARLY resume
[305235.382690] i2c i2c-2: EARLY resume
[305235.382692] i2c i2c-3: EARLY resume
[305235.382694] i2c i2c-4: EARLY resume
[305235.382696] input input10: EARLY type resume
[305235.382699] PM: early resume of devices complete after 17.501 msecs
[305235.382827] pci 0000:ff:00.0: resume
[305235.382832] pci 0000:ff:00.1: resume
[305235.382835] pci 0000:ff:02.0: resume
[305235.382837] pci 0000:ff:02.1: resume
[305235.382839] pci 0000:ff:02.2: resume
[305235.382841] pci 0000:ff:02.3: resume
[305235.382846] agpgart-intel 0000:00:00.0: resume
[305235.382849] i915 0000:00:02.0: resume
[305235.382851] pci 0000:00:16.0: resume
[305235.382853] serial 0000:00:16.3: resume
[305235.382855] e1000e 0000:00:19.0: resume
[305235.382864] ehci_hcd 0000:00:1a.0: resume
[305235.382874] i915 0000:00:02.0: power state changed by ACPI to D0
[305235.382876] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[305235.382882] e1000e 0000:00:19.0: PME# disabled
[305235.382885] HDA Intel 0000:00:1b.0: resume
[305235.382891] acpi LNXSYSTM:00: legacy resume
[305235.382893] pci 0000:00:1c.0: resume
[305235.382895] processor LNXCPU:00: legacy resume
[305235.382905] processor LNXCPU:01: legacy resume
[305235.382910] pci 0000:00:1c.3: resume
[305235.382912] processor LNXCPU:02: legacy resume
[305235.382915] pci 0000:00:1c.4: resume
[305235.382920] ehci_hcd 0000:00:1d.0: resume
[305235.382929] pci 0000:00:1e.0: resume
[305235.382931] processor LNXCPU:03: legacy resume
[305235.382934] pci 0000:00:1f.0: resume
[305235.382936] processor LNXCPU:04: legacy resume
[305235.382938] ahci 0000:00:1f.2: resume
[305235.382940] processor LNXCPU:05: legacy resume
[305235.382942] processor LNXCPU:06: legacy resume
[305235.382945] processor LNXCPU:07: legacy resume
[305235.382947] i801_smbus 0000:00:1f.3: resume
[305235.382949] acpi LNXSYBUS:00: legacy resume
[305235.382952] pci_link PNP0C0F:00: legacy resume
[305235.382958] pci_link PNP0C0F:01: legacy resume
[305235.382960] pci_link PNP0C0F:02: legacy resume
[305235.382962] pci_link PNP0C0F:03: legacy resume
[305235.382964] pci_link PNP0C0F:04: legacy resume
[305235.382966] pci_link PNP0C0F:05: legacy resume
[305235.382968] pci_link PNP0C0F:06: legacy resume
[305235.382970] pci_link PNP0C0F:07: legacy resume
[305235.382972] acpi PNP0C01:00: legacy resume
[305235.382974] button PNP0C0D:00: legacy resume
[305235.382999] intel ips 0000:00:1f.6: resume
[305235.383032] e1000e 0000:00:19.0: irq 41 for MSI/MSI-X
[305235.383086] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[305235.383093] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[305235.383096] pci 0000:00:1c.0: setting latency timer to 64
[305235.383099] pci 0000:00:1c.3: setting latency timer to 64
[305235.383117] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[305235.383122] pci 0000:00:1c.4: setting latency timer to 64
[305235.383131] iwlagn 0000:02:00.0: resume
[305235.383144] pci 0000:00:1e.0: setting latency timer to 64
[305235.383203] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) ->=
 IRQ 17
[305235.383210] HDA Intel 0000:00:1b.0: setting latency timer to 64
[305235.383275] HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
[305235.383335] ahci 0000:00:1f.2: setting latency timer to 64
[305235.383428] scsi host0: resume
[305235.383435] scsi target0:0:0: resume
[305235.383470] scsi host3: resume
[305235.383479] scsi host4: resume
[305235.383486] i915 0000:00:02.0: power state changed by ACPI to D0
[305235.383488] scsi host5: resume
[305235.383490] i915 0000:00:02.0: setting latency timer to 64
[305235.383713] scsi host2: resume
[305235.383719] scsi host1: resume
[305235.383768] sd 0:0:0:0: resume
[305235.383772] sd 0:0:0:0: [sda] Starting disk
[305235.383876] button PNP0C0E:00: legacy resume
[305235.383879] pci_root PNP0A03:00: legacy resume
[305235.383881] acpi device:00: legacy resume
[305235.383883] pci_root PNP0A08:00: legacy resume
[305235.383886] video LNXVIDEO:00: legacy resume
[305235.383888] acpi device:01: legacy resume
[305235.383890] acpi device:02: legacy resume
[305235.383892] acpi device:03: legacy resume
[305235.383894] acpi device:04: legacy resume
[305235.383896] acpi device:05: legacy resume
[305235.383898] acpi device:06: legacy resume
[305235.383900] acpi device:07: legacy resume
[305235.383903] acpi device:08: legacy resume
[305235.383905] acpi device:09: legacy resume
[305235.383907] acpi PNP0C02:00: legacy resume
[305235.383909] acpi PNP0000:00: legacy resume
[305235.383911] acpi PNP0100:00: legacy resume
[305235.383913] acpi PNP0103:00: legacy resume
[305235.383915] acpi PNP0200:00: legacy resume
[305235.383918] acpi PNP0800:00: legacy resume
[305235.383920] acpi PNP0C04:00: legacy resume
[305235.383922] acpi PNP0B00:00: legacy resume
[305235.383924] acpi PNP0303:00: legacy resume
[305235.383926] acpi LEN0018:00: legacy resume
[305235.383928] acpi SMO1200:00: legacy resume
[305235.383931] ec PNP0C09:00: legacy resume
[305235.383933] power LNXPOWER:00: legacy resume
[305235.384087] battery PNP0C0A:00: legacy resume
[305235.399985] ac ACPI0003:00: legacy resume
[305235.400127] thinkpad_hotkey IBM0068:00: legacy resume
[305235.400129] acpi device:0a: legacy resume
[305235.400131] acpi LNXVIDEO:01: legacy resume
[305235.400133] acpi device:0b: legacy resume
[305235.400135] acpi device:0c: legacy resume
[305235.400137] acpi device:0d: legacy resume
[305235.400138] acpi device:0e: legacy resume
[305235.400140] acpi device:0f: legacy resume
[305235.400142] acpi device:10: legacy resume
[305235.400144] acpi device:11: legacy resume
[305235.400146] acpi device:12: legacy resume
[305235.400147] acpi device:13: legacy resume
[305235.400149] acpi device:14: legacy resume
[305235.400151] acpi device:15: legacy resume
[305235.400153] acpi device:16: legacy resume
[305235.400155] acpi device:17: legacy resume
[305235.400156] acpi device:18: legacy resume
[305235.400158] acpi device:19: legacy resume
[305235.400160] acpi device:1a: legacy resume
[305235.400162] acpi device:1b: legacy resume
[305235.400164] acpi device:1c: legacy resume
[305235.400165] acpi device:1d: legacy resume
[305235.400167] acpi device:1e: legacy resume
[305235.400169] acpi device:1f: legacy resume
[305235.400171] acpi device:20: legacy resume
[305235.400172] acpi device:21: legacy resume
[305235.400174] acpi device:22: legacy resume
[305235.400176] acpi device:23: legacy resume
[305235.400178] acpi device:24: legacy resume
[305235.400179] acpi device:25: legacy resume
[305235.400181] acpi device:26: legacy resume
[305235.400183] acpi device:27: legacy resume
[305235.400185] acpi device:28: legacy resume
[305235.400186] acpi device:29: legacy resume
[305235.400188] acpi device:2a: legacy resume
[305235.400190] acpi device:2b: legacy resume
[305235.400192] acpi device:2c: legacy resume
[305235.400194] acpi device:2d: legacy resume
[305235.400195] acpi device:2e: legacy resume
[305235.400197] acpi device:2f: legacy resume
[305235.400199] acpi device:31: legacy resume
[305235.400201] acpi device:32: legacy resume
[305235.400203] acpi PNP0C02:01: legacy resume
[305235.400205] wmi PNP0C14:00: legacy resume
[305235.400207] acpi LNXTHERM:00: legacy resume
[305235.400209] thermal LNXTHERM:01: legacy resume
[305235.400687] button LNXPWRBN:00: legacy resume
[305235.400690] platform dock.0: resume
[305235.400692] platform dock.1: resume
[305235.400693] platform dock.2: resume
[305235.400699] system 00:00: legacy resume
[305235.400702] pnp 00:01: legacy resume
[305235.400704] pnp 00:02: legacy resume
[305235.400706] system 00:03: legacy resume
[305235.400709] pnp 00:04: legacy resume
[305235.400710] pnp 00:05: legacy resume
[305235.400712] pnp 00:06: legacy resume
[305235.400714] pnp 00:07: legacy resume
[305235.400716] rtc_cmos 00:08: legacy resume
[305235.400719] i8042 kbd 00:09: legacy resume
[305235.400722] i8042 aux 00:0a: legacy resume
[305235.400724] tpm_tis 00:0b: legacy resume
[305235.400891] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[305235.401046] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[305235.401053] ehci_hcd 0000:00:1a.0: PCI INT D -> GSI 23 (level, low) -> =
IRQ 23
[305235.401060] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[305235.401110] usb usb1: type resume
[305235.401230] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[305235.401383] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[305235.401390] ehci_hcd 0000:00:1d.0: PCI INT D -> GSI 19 (level, low) -> =
IRQ 19
[305235.401397] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[305235.401423] usb usb2: type resume
[305235.425070] system 00:0c: legacy resume
[305235.425087] pcspkr pcspkr: resume
[305235.425088] platform microcode: resume
[305235.425091] input input0: type resume
[305235.425093] input input1: type resume
[305235.425102] input input2: type resume
[305235.425187] i8042 i8042: resume
[305235.426018] atkbd serio0: resume
[305235.426023] psmouse serio1: resume
[305235.426032] input input3: type resume
[305235.442034] usb 1-1: type resume
[305235.442039] usb 2-1: type resume
[305235.542933] usb 1-1.6: type resume
[305235.542962] usb 1-1.3: type resume
[305235.615996] usb 1-1.6: reset high speed USB device using ehci_hcd and a=
ddress 5
[305235.687604] ata2: SATA link down (SStatus 0 SControl 300)
[305235.691596] ata5: SATA link down (SStatus 0 SControl 300)
[305235.693609] ata6: SATA link down (SStatus 0 SControl 300)
[305235.777612] usb 1-1.3: reset full speed USB device using ehci_hcd and a=
ddress 3
[305237.931530] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[305237.933957] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[305237.933963] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[305237.933967] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[305237.938774] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succe=
eded
[305237.938780] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOC=
K) filtered out
[305237.938784] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filte=
red out
[305237.940896] ata1.00: configured for UDMA/100
[305237.956097] ata1.00: configured for UDMA/100
[305237.956103] ata1: EH complete
[305237.982789] input input4: type resume
[305237.982802] psmouse serio2: resume
[305237.982810] input input5: type resume
[305237.982837] serial8250 serial8250: resume
[305237.982856] platform regulatory.0: resume
[305237.982866] i2c i2c-0: resume
[305237.982871] thinkpad_acpi thinkpad_acpi: resume
[305237.984932] thinkpad_hwmon thinkpad_hwmon: resume
[305237.984936] rfkill rfkill0: legacy class resume
[305237.984939] leds tpacpi::thinklight: legacy class resume
[305237.984941] leds tpacpi::power: legacy class resume
[305237.984944] leds tpacpi:orange:batt: legacy class resume
[305237.984946] leds tpacpi:green:batt: legacy class resume
[305237.984948] leds tpacpi::dock_active: legacy class resume
[305237.984950] leds tpacpi::bay_active: legacy class resume
[305237.984953] leds tpacpi::dock_batt: legacy class resume
[305237.984955] leds tpacpi::unknown_led: legacy class resume
[305237.984957] leds tpacpi::standby: legacy class resume
[305237.984959] leds tpacpi::dock_status1: legacy class resume
[305237.984961] leds tpacpi::dock_status2: legacy class resume
[305237.984963] leds tpacpi::unknown_led2: legacy class resume
[305237.984965] leds tpacpi::unknown_led3: legacy class resume
[305237.984967] leds tpacpi::thinkvantage: legacy class resume
[305237.984970] input input6: type resume
[305237.984981] input input7: type resume
[305237.984988] ieee80211 phy0: legacy class resume
[305238.075413] rfkill rfkill1: legacy class resume
[305238.075466] input input8: type resume
[305238.075474] input input9: type resume
[305238.075503] drm controlD64: legacy class resume
[305238.075505] drm card0: legacy class resume
[305238.075507] i2c i2c-1: resume
[305238.075509] drm card0-LVDS-1: legacy class resume
[305238.075511] i2c i2c-2: resume
[305238.075513] drm card0-VGA-1: legacy class resume
[305238.075515] i2c i2c-3: resume
[305238.075517] drm card0-HDMI Type A-1: legacy class resume
[305238.075519] drm card0-DisplayPort-1: legacy class resume
[305238.075520] i2c i2c-4: resume
[305238.075523] backlight acpi_video0: legacy class resume
[305238.075526] input input10: type resume
[305238.075533] PM: resume of devices complete after 2697.685 msecs
[305238.075548] usb 1-1.6: completing type resume
[305238.075551] usb 1-1.3: completing type resume
[305238.075553] usb 2-1: completing type resume
[305238.075556] usb 1-1: completing type resume
[305238.075561] thinkpad_hwmon thinkpad_hwmon: completing resume
[305238.075562] thinkpad_acpi thinkpad_acpi: completing resume
[305238.075565] platform regulatory.0: completing resume
[305238.075569] usb usb2: completing type resume
[305238.075571] serial8250 serial8250: completing resume
[305238.075573] usb usb1: completing type resume
[305238.075580] i8042 i8042: completing resume
[305238.075661] platform microcode: completing resume
[305238.075664] pcspkr pcspkr: completing resume
[305238.075680] iwlagn 0000:02:00.0: completing resume
[305238.075682] intel ips 0000:00:1f.6: completing resume
[305238.075684] i801_smbus 0000:00:1f.3: completing resume
[305238.075686] ahci 0000:00:1f.2: completing resume
[305238.075689] pci 0000:00:1f.0: completing resume
[305238.075690] pci 0000:00:1e.0: completing resume
[305238.075692] ehci_hcd 0000:00:1d.0: completing resume
[305238.075694] pci 0000:00:1c.4: completing resume
[305238.075696] pci 0000:00:1c.3: completing resume
[305238.075698] pci 0000:00:1c.0: completing resume
[305238.075700] HDA Intel 0000:00:1b.0: completing resume
[305238.075702] ehci_hcd 0000:00:1a.0: completing resume
[305238.075704] e1000e 0000:00:19.0: completing resume
[305238.075706] serial 0000:00:16.3: completing resume
[305238.075708] pci 0000:00:16.0: completing resume
[305238.075710] i915 0000:00:02.0: completing resume
[305238.075713] agpgart-intel 0000:00:00.0: completing resume
[305238.075715] pci 0000:ff:02.3: completing resume
[305238.075717] pci 0000:ff:02.2: completing resume
[305238.075719] pci 0000:ff:02.1: completing resume
[305238.075720] pci 0000:ff:02.0: completing resume
[305238.075722] pci 0000:ff:00.1: completing resume
[305238.075724] pci 0000:ff:00.0: completing resume
[305238.075726] platform dock.2: completing resume
[305238.075728] platform dock.1: completing resume
[305238.075730] platform dock.0: completing resume
[305238.076254] PM: Finishing wakeup.
[305238.076255] Restarting tasks ... done.
[305238.084230] video LNXVIDEO:00: Restoring backlight state
[305238.646351] usb 1-1.4: new full speed USB device using ehci_hcd and add=
ress 49
[305238.735708] PM: Adding info for usb:1-1.4
[305238.735988] PM: Adding info for usb:1-1.4:1.0
[305238.736134] PM: Adding info for No Bus:hci0
[305238.736206] PM: Adding info for No Bus:rfkill8
[305238.736268] PM: Adding info for No Bus:ep_81
[305238.736294] PM: Adding info for No Bus:ep_82
[305238.736318] PM: Adding info for No Bus:ep_02
[305238.736347] PM: Adding info for usb:1-1.4:1.1
[305238.736402] PM: Adding info for No Bus:ep_83
[305238.736428] PM: Adding info for No Bus:ep_03
[305238.736457] PM: Adding info for usb:1-1.4:1.2
[305238.736548] PM: Adding info for No Bus:ep_84
[305238.736572] PM: Adding info for No Bus:ep_04
[305238.736601] PM: Adding info for usb:1-1.4:1.3
[305238.736685] PM: Adding info for No Bus:ep_00
[305238.832838] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305238.834906] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3 at 0)
[305239.218118] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.218141] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 7 at 0)
[305239.294027] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.294057] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 9 at 0)
[305239.369859] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.369890] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 12 at 0)
[305239.444759] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.444806] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 14 at 0)
[305239.520584] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.520615] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 16 at 0)
[305239.595476] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.595499] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 18 at 0)
[305239.671291] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.671322] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 20 at 0)
[305239.747168] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.747199] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 23 at 0)
[305239.823014] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.823038] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 26 at 0)
[305239.898927] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.898958] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 29 at 0)
[305239.974739] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305239.974754] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 31 at 0)
[305240.049635] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.049670] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 33 at 0)
[305240.147436] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.147505] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 34 at 0)
[305240.244262] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.244330] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 36 at 0)
[305240.340054] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.340081] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 170 at 0)
[305240.435942] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.435983] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 390 at 0)
[305240.532700] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.532727] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 748 at 0)
[305240.628595] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.628632] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 1207 at 0)
[305240.723351] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.723382] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 1542 at 0)
[305240.819177] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.819207] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 1954 at 0)
[305240.940990] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305240.941023] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2296 at 0)
[305241.066761] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.066790] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2633 at 0)
[305241.191567] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.191603] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2635 at 0)
[305241.317321] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.317353] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2637 at 0)
[305241.443072] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.443146] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2639 at 0)
[305241.568837] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.568865] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2641 at 0)
[305241.694635] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.694655] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2643 at 0)
[305241.818385] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.818431] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2645 at 0)
[305241.894265] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.894292] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2735 at 0)
[305241.970064] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305241.970078] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2737 at 0)
[305242.047985] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.048012] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2739 at 0)
[305242.124827] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.124858] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2741 at 0)
[305242.228669] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.228714] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2742 at 0)
[305242.354441] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.354469] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2744 at 0)
[305242.479223] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.479273] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2746 at 0)
[305242.604963] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.604998] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2748 at 0)
[305242.729744] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.729787] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2750 at 0)
[305242.871505] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.871548] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2752 at 0)
[305242.997228] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305242.997302] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2754 at 0)
[305243.123025] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.123056] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2756 at 0)
[305243.262773] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.262815] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2758 at 0)
[305243.398539] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.398574] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2760 at 0)
[305243.473378] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.473402] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2763 at 0)
[305243.548244] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.548278] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2766 at 0)
[305243.624090] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.624120] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2770 at 0)
[305243.699969] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.700001] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2774 at 0)
[305243.775824] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.775854] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2776 at 0)
[305243.851661] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.851690] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2779 at 0)
[305243.927544] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305243.927579] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2781 at 0)
[305244.002381] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.002412] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2784 at 0)
[305244.077263] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.077280] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2785 at 0)
[305244.213997] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.214023] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2786 at 0)
[305244.357742] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.357773] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2788 at 0)
[305244.499529] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.499551] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2790 at 0)
[305244.648209] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.648240] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2792 at 0)
[305244.795942] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.795979] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2794 at 0)
[305244.890766] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.890787] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2797 at 0)
[305244.965668] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305244.965698] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2799 at 0)
[305245.067469] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.067504] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2802 at 0)
[305245.163296] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.163331] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2819 at 0)
[305245.259119] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.259152] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2852 at 0)
[305245.355922] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.355946] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2892 at 0)
[305245.431809] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.431842] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2895 at 0)
[305245.506664] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.506694] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2897 at 0)
[305245.581524] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.581554] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2899 at 0)
[305245.656349] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.656387] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2902 at 0)
[305245.731248] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.731275] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2904 at 0)
[305245.807131] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.807164] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2906 at 0)
[305245.882973] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.883001] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2908 at 0)
[305245.957849] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305245.957885] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2910 at 0)
[305246.032706] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.032739] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2912 at 0)
[305246.107550] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.107578] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2914 at 0)
[305246.182414] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.182462] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2917 at 0)
[305246.257265] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.257338] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2920 at 0)
[305246.333136] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.333179] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2923 at 0)
[305246.408019] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.408084] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2926 at 0)
[305246.482880] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.482944] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2929 at 0)
[305246.557745] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.557819] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2932 at 0)
[305246.633612] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.633689] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2935 at 0)
[305246.709478] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.709507] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2939 at 0)
[305246.784333] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.784367] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2941 at 0)
[305246.878156] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.878187] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2943 at 0)
[305246.954028] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305246.954080] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2945 at 0)
[305247.029888] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305247.029922] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2948 at 0)
[305247.104739] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305247.104769] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2950 at 0)
[305247.179578] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305247.179620] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2953 at 0)
[305247.255461] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305247.255492] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2956 at 0)
[305247.330329] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305247.330360] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2958 at 0)
[305247.455048] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305251.733289] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305251.733320] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2960 at 0)
[305251.850075] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305251.850110] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 2972 at 0)
[305251.940891] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305251.940923] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3048 at 0)
[305252.015775] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.015806] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3050 at 0)
[305252.091603] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.091633] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3053 at 0)
[305252.168487] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.168515] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3055 at 0)
[305252.244344] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.244381] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3057 at 0)
[305252.320248] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.320323] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3060 at 0)
[305252.396041] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.396099] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3063 at 0)
[305252.471926] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.471961] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3066 at 0)
[305252.546798] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.546830] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3068 at 0)
[305252.621656] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.621691] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3070 at 0)
[305252.696467] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305252.696501] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3072 at 0)
[305252.772342] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305258.408996] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305258.409016] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3075 at 0)
[305318.289476] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305318.289503] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3077 at 0)
[305318.364358] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapse=
d... GPU hung
[305318.364392] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request ret=
urns -5 (awaiting 3079 at 0)

--NklN7DEeGtkPCoo3--

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyh2LgACgkQ19zI5DGHffCZYgCg4FjYV+T2ma3Cc3yIHSCOe6oz
isgAn3lCzsze9GE9xUh+guj0XjvUBcz6
=SVRp
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
