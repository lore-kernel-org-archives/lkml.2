Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1JQWba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:31:30 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:56421 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab1JQWb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:31:28 -0400
Date: Tue, 18 Oct 2011 00:31:27 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, keithp@keithp.com,
        jkosina@suse.cz
Subject: Re: MacBook Air (4,2): Screen working in full resolution (keithp
 tree, fix-edp-vdd-power branch)
Message-ID: <20111017223127.GC1408@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>, keithp@keithp.com,
	jkosina@suse.cz
References: <20111017215114.GB1408@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <20111017215114.GB1408@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-g1f2c7e9 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Update: Using a MiniDisplayPort to HDMI adapter
and xrandr --output HDMI1 --left-of eDP1 --auto,
the image on the external monitor seems to show only parts
of what's there.

Moving the mouse left out and above out of the left/monitor
works -> mouse pointer disappears.

Attached full Xorg.0.log including the part when the new output 
was created.

Attaching a MiniDisplayPort to DVI adapter, no output is detected
by xrandr though (all outputs show disconnected).

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="Xorg.0.log"

[    61.239] 
X.Org X Server 1.11.1
Release Date: 2011-09-24
[    61.239] X Protocol Version 11, Revision 0
[    61.239] Build Operating System: Linux 3.0-ARCH x86_64 
[    61.239] Current Operating System: Linux brief 3.1.0-rc6-g1f2c7e9 #1 SMP PREEMPT Mon Oct 17 21:04:20 CEST 2011 x86_64
[    61.240] Kernel command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro initrd=../initramfs-keithp.img BOOT_IMAGE=../vmlinuz-keithp 
[    61.240] Build Date: 10 October 2011  08:55:30AM
[    61.240]  
[    61.240] Current version of pixman: 0.22.2
[    61.240] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    61.240] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    61.240] (==) Log file: "/var/log/Xorg.0.log", Time: Mon Oct 17 23:22:18 2011
[    61.242] (==) Using config directory: "/etc/X11/xorg.conf.d"
[    61.244] (==) No Layout section.  Using the first Screen section.
[    61.244] (==) No screen section available. Using defaults.
[    61.244] (**) |-->Screen "Default Screen Section" (0)
[    61.244] (**) |   |-->Monitor "<default monitor>"
[    61.245] (==) No monitor specified for screen "Default Screen Section".
	Using a default monitor configuration.
[    61.245] (==) Automatically adding devices
[    61.245] (==) Automatically enabling devices
[    61.248] (WW) The directory "/usr/share/fonts/OTF/" does not exist.
[    61.248] 	Entry deleted from font path.
[    61.250] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/100dpi/".
[    61.250] 	Entry deleted from font path.
[    61.250] 	(Run 'mkfontdir' on "/usr/share/fonts/100dpi/").
[    61.250] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/75dpi/".
[    61.250] 	Entry deleted from font path.
[    61.250] 	(Run 'mkfontdir' on "/usr/share/fonts/75dpi/").
[    61.250] (==) FontPath set to:
	/usr/share/fonts/misc/,
	/usr/share/fonts/TTF/,
	/usr/share/fonts/Type1/
[    61.250] (==) ModulePath set to "/usr/lib/xorg/modules"
[    61.250] (II) The server relies on udev to provide the list of input devices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    61.250] (II) Loader magic: 0x7ccae0
[    61.250] (II) Module ABI versions:
[    61.250] 	X.Org ANSI C Emulation: 0.4
[    61.250] 	X.Org Video Driver: 11.0
[    61.250] 	X.Org XInput driver : 13.0
[    61.250] 	X.Org Server Extension : 6.0
[    61.251] (--) PCI:*(0:0:2:0) 8086:0116:106b:00eb rev 9, Mem @ 0xa0000000/4194304, 0x90000000/268435456, I/O @ 0x00002000/64
[    61.251] (WW) Open ACPI failed (/var/run/acpid.socket) (No such file or directory)
[    61.251] (II) LoadModule: "extmod"
[    61.254] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    61.256] (II) Module extmod: vendor="X.Org Foundation"
[    61.256] 	compiled for 1.11.1, module version = 1.0.0
[    61.256] 	Module class: X.Org Server Extension
[    61.256] 	ABI class: X.Org Server Extension, version 6.0
[    61.256] (II) Loading extension MIT-SCREEN-SAVER
[    61.256] (II) Loading extension XFree86-VidModeExtension
[    61.256] (II) Loading extension XFree86-DGA
[    61.256] (II) Loading extension DPMS
[    61.256] (II) Loading extension XVideo
[    61.256] (II) Loading extension XVideo-MotionCompensation
[    61.256] (II) Loading extension X-Resource
[    61.256] (II) LoadModule: "dbe"
[    61.257] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    61.258] (II) Module dbe: vendor="X.Org Foundation"
[    61.258] 	compiled for 1.11.1, module version = 1.0.0
[    61.258] 	Module class: X.Org Server Extension
[    61.258] 	ABI class: X.Org Server Extension, version 6.0
[    61.258] (II) Loading extension DOUBLE-BUFFER
[    61.258] (II) LoadModule: "glx"
[    61.258] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    61.263] (II) Module glx: vendor="X.Org Foundation"
[    61.263] 	compiled for 1.11.1, module version = 1.0.0
[    61.263] 	ABI class: X.Org Server Extension, version 6.0
[    61.263] (==) AIGLX enabled
[    61.263] (II) Loading extension GLX
[    61.263] (II) LoadModule: "record"
[    61.263] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    61.265] (II) Module record: vendor="X.Org Foundation"
[    61.265] 	compiled for 1.11.1, module version = 1.13.0
[    61.265] 	Module class: X.Org Server Extension
[    61.265] 	ABI class: X.Org Server Extension, version 6.0
[    61.265] (II) Loading extension RECORD
[    61.265] (II) LoadModule: "dri"
[    61.265] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    61.269] (II) Module dri: vendor="X.Org Foundation"
[    61.269] 	compiled for 1.11.1, module version = 1.0.0
[    61.269] 	ABI class: X.Org Server Extension, version 6.0
[    61.269] (II) Loading extension XFree86-DRI
[    61.269] (II) LoadModule: "dri2"
[    61.269] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    61.270] (II) Module dri2: vendor="X.Org Foundation"
[    61.270] 	compiled for 1.11.1, module version = 1.2.0
[    61.270] 	ABI class: X.Org Server Extension, version 6.0
[    61.270] (II) Loading extension DRI2
[    61.270] (==) Matched intel as autoconfigured driver 0
[    61.270] (==) Matched vesa as autoconfigured driver 1
[    61.270] (==) Matched fbdev as autoconfigured driver 2
[    61.270] (==) Assigned the driver to the xf86ConfigLayout
[    61.270] (II) LoadModule: "intel"
[    61.270] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    61.278] (II) Module intel: vendor="X.Org Foundation"
[    61.278] 	compiled for 1.10.99.902, module version = 2.16.0
[    61.278] 	Module class: X.Org Video Driver
[    61.278] 	ABI class: X.Org Video Driver, version 11.0
[    61.278] (II) LoadModule: "vesa"
[    61.280] (WW) Warning, couldn't open module vesa
[    61.280] (II) UnloadModule: "vesa"
[    61.280] (II) Unloading vesa
[    61.280] (EE) Failed to load module "vesa" (module does not exist, 0)
[    61.280] (II) LoadModule: "fbdev"
[    61.280] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    61.281] (II) Module fbdev: vendor="X.Org Foundation"
[    61.281] 	compiled for 1.10.99.902, module version = 0.4.2
[    61.282] 	ABI class: X.Org Video Driver, version 11.0
[    61.282] (II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
	i810-dc100, i810e, i815, i830M, 845G, 854, 852GM/855GM, 865G, 915G,
	E7221 (i915), 915GM, 945G, 945GM, 945GME, Pineview GM, Pineview G,
	965G, G35, 965Q, 946GZ, 965GM, 965GME/GLE, G33, Q35, Q33, GM45,
	4 Series, G45/G43, Q45/Q43, G41, B43, B43, Clarkdale, Arrandale,
	Sandybridge Desktop (GT1), Sandybridge Desktop (GT2),
	Sandybridge Desktop (GT2+), Sandybridge Mobile (GT1),
	Sandybridge Mobile (GT2), Sandybridge Mobile (GT2+),
	Sandybridge Server, Ivybridge Mobile (GT1), Ivybridge Mobile (GT2),
	Ivybridge Desktop (GT1), Ivybridge Desktop (GT2), Ivybridge Server
[    61.282] (II) FBDEV: driver for framebuffer: fbdev
[    61.282] (--) using VT number 7

[    61.300] (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
[    61.300] (WW) Falling back to old probe method for fbdev
[    61.301] (II) Loading sub module "fbdevhw"
[    61.301] (II) LoadModule: "fbdevhw"
[    61.301] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    61.302] (II) Module fbdevhw: vendor="X.Org Foundation"
[    61.302] 	compiled for 1.11.1, module version = 0.0.2
[    61.302] 	ABI class: X.Org Video Driver, version 11.0
[    61.303] drmOpenDevice: node name is /dev/dri/card0
[    61.303] drmOpenDevice: open result is 8, (OK)
[    61.303] drmOpenByBusid: Searching for BusID pci:0000:00:02.0
[    61.303] drmOpenDevice: node name is /dev/dri/card0
[    61.303] drmOpenDevice: open result is 8, (OK)
[    61.303] drmOpenByBusid: drmOpenMinor returns 8
[    61.303] drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
[    61.303] (II) intel(0): Creating default Display subsection in Screen section
	"Default Screen Section" for depth/fbbpp 24/32
[    61.303] (==) intel(0): Depth 24, (--) framebuffer bpp 32
[    61.303] (==) intel(0): RGB weight 888
[    61.303] (==) intel(0): Default visual is TrueColor
[    61.303] (II) intel(0): Integrated Graphics Chipset: Intel(R) Sandybridge Mobile (GT2)
[    61.303] (--) intel(0): Chipset: "Sandybridge Mobile (GT2)"
[    61.303] (**) intel(0): Relaxed fencing enabled
[    61.303] (**) intel(0): Wait on SwapBuffers? enabled
[    61.303] (**) intel(0): Triple buffering? enabled
[    61.303] (**) intel(0): Framebuffer tiled
[    61.303] (**) intel(0): Pixmaps tiled
[    61.303] (**) intel(0): 3D buffers tiled
[    61.303] (**) intel(0): SwapBuffers wait enabled
[    61.303] (==) intel(0): video overlay key set to 0x101fe
[    61.361] (II) intel(0): Output eDP1 has no monitor section
[    61.361] (II) intel(0): Output VGA1 has no monitor section
[    61.384] (II) intel(0): Output HDMI1 has no monitor section
[    61.423] (II) intel(0): Output DP1 has no monitor section
[    61.446] (II) intel(0): Output HDMI2 has no monitor section
[    61.470] (II) intel(0): Output HDMI3 has no monitor section
[    61.510] (II) intel(0): Output DP2 has no monitor section
[    61.550] (II) intel(0): Output DP3 has no monitor section
[    61.606] (II) intel(0): EDID for output eDP1
[    61.606] (II) intel(0): Manufacturer: APP  Model: 9cf0  Serial#: 0
[    61.606] (II) intel(0): Year: 2011  Week: 25
[    61.606] (II) intel(0): EDID Version: 1.4
[    61.606] (II) intel(0): Digital Display Input
[    61.606] (II) intel(0): 6 bits per channel
[    61.606] (II) intel(0): Digital interface is DisplayPort
[    61.606] (II) intel(0): Max Image Size [cm]: horiz.: 29  vert.: 18
[    61.606] (II) intel(0): Gamma: 2.20
[    61.606] (II) intel(0): No DPMS capabilities specified
[    61.606] (II) intel(0): Supported color encodings: RGB 4:4:4 
[    61.606] (II) intel(0): First detailed timing is preferred mode
[    61.606] (II) intel(0): Preferred mode is native pixel format and refresh rate
[    61.606] (II) intel(0): redX: 0.593 redY: 0.342   greenX: 0.331 greenY: 0.573
[    61.606] (II) intel(0): blueX: 0.152 blueY: 0.133   whiteX: 0.313 whiteY: 0.329
[    61.606] (II) intel(0): Manufacturer's mask: 0
[    61.606] (II) intel(0): Supported detailed timing:
[    61.606] (II) intel(0): clock: 88.9 MHz   Image Size:  30 x 179 mm
[    61.606] (II) intel(0): h_active: 1440  h_sync: 1488  h_sync_end 1520 h_blank_end 1600 h_border: 0
[    61.606] (II) intel(0): v_active: 900  v_sync: 903  v_sync_end 909 v_blanking: 926 v_border: 0
[    61.606] (II) intel(0):  LTH133BT01A03
[    61.606] (II) intel(0): Monitor name: Color LCD
[    61.606] (II) intel(0): EDID (in hex):
[    61.606] (II) intel(0): 	00ffffffffffff000610f09c00000000
[    61.606] (II) intel(0): 	19150104951d127802ef059757549227
[    61.606] (II) intel(0): 	22505400000001010101010101010101
[    61.606] (II) intel(0): 	010101010101b922a0a050841a303020
[    61.606] (II) intel(0): 	36001eb3000000180000001000000000
[    61.606] (II) intel(0): 	00000000000000000000000000fe004c
[    61.606] (II) intel(0): 	544831333342543031413033000000fc
[    61.606] (II) intel(0): 	00436f6c6f72204c43440a2020200006
[    61.606] (II) intel(0): EDID vendor "APP", prod id 40176
[    61.606] (II) intel(0): Printing DDC gathered Modelines:
[    61.606] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[    61.606] (II) intel(0): Printing probed modes for output eDP1
[    61.606] (II) intel(0): Modeline "1440x900"x60.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[    61.606] (II) intel(0): EDID for output VGA1
[    61.630] (II) intel(0): EDID for output HDMI1
[    61.670] (II) intel(0): EDID for output DP1
[    61.693] (II) intel(0): EDID for output HDMI2
[    61.717] (II) intel(0): EDID for output HDMI3
[    61.756] (II) intel(0): EDID for output DP2
[    61.796] (II) intel(0): EDID for output DP3
[    61.796] (II) intel(0): Output eDP1 connected
[    61.796] (II) intel(0): Output VGA1 disconnected
[    61.796] (II) intel(0): Output HDMI1 disconnected
[    61.796] (II) intel(0): Output DP1 disconnected
[    61.796] (II) intel(0): Output HDMI2 disconnected
[    61.796] (II) intel(0): Output HDMI3 disconnected
[    61.796] (II) intel(0): Output DP2 disconnected
[    61.796] (II) intel(0): Output DP3 disconnected
[    61.796] (II) intel(0): Using exact sizes for initial modes
[    61.796] (II) intel(0): Output eDP1 using initial mode 1440x900
[    61.796] (II) intel(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    61.796] (II) intel(0): Kernel page flipping support detected, enabling
[    61.796] (**) intel(0): Display dimensions: (290, 180) mm
[    61.796] (**) intel(0): DPI set to (126, 127)
[    61.796] (II) Loading sub module "fb"
[    61.796] (II) LoadModule: "fb"
[    61.797] (II) Loading /usr/lib/xorg/modules/libfb.so
[    61.801] (II) Module fb: vendor="X.Org Foundation"
[    61.801] 	compiled for 1.11.1, module version = 1.0.0
[    61.801] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    61.801] (II) Loading sub module "dri2"
[    61.801] (II) LoadModule: "dri2"
[    61.801] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    61.801] (II) Module dri2: vendor="X.Org Foundation"
[    61.801] 	compiled for 1.11.1, module version = 1.2.0
[    61.801] 	ABI class: X.Org Server Extension, version 6.0
[    61.801] (II) UnloadModule: "fbdev"
[    61.801] (II) Unloading fbdev
[    61.801] (II) UnloadModule: "fbdevhw"
[    61.801] (II) Unloading fbdevhw
[    61.801] (==) Depth 24 pixmap format is 32 bpp
[    61.801] (II) intel(0): [DRI2] Setup complete
[    61.801] (II) intel(0): [DRI2]   DRI driver: i965
[    61.801] (II) intel(0): Allocated new frame buffer 1472x900 stride 6144, tiled
[    61.807] (II) UXA(0): Driver registered support for the following operations:
[    61.807] (II)         solid
[    61.807] (II)         copy
[    61.807] (II)         composite (RENDER acceleration)
[    61.807] (II)         put_image
[    61.807] (II)         get_image
[    61.807] (==) intel(0): Backing store disabled
[    61.807] (==) intel(0): Silken mouse enabled
[    61.807] (II) intel(0): Initializing HW Cursor
[    61.866] (II) intel(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    61.867] (==) intel(0): DPMS enabled
[    61.867] (==) intel(0): Intel XvMC decoder enabled
[    61.867] (II) intel(0): Set up textured video
[    61.867] (II) intel(0): [XvMC] xvmc_vld driver initialized.
[    61.867] (II) intel(0): direct rendering: DRI2 Enabled
[    61.867] (==) intel(0): hotplug detection: "enabled"
[    61.867] (--) RandR disabled
[    61.867] (II) Initializing built-in extension Generic Event Extension
[    61.867] (II) Initializing built-in extension SHAPE
[    61.867] (II) Initializing built-in extension MIT-SHM
[    61.867] (II) Initializing built-in extension XInputExtension
[    61.867] (II) Initializing built-in extension XTEST
[    61.867] (II) Initializing built-in extension BIG-REQUESTS
[    61.867] (II) Initializing built-in extension SYNC
[    61.867] (II) Initializing built-in extension XKEYBOARD
[    61.867] (II) Initializing built-in extension XC-MISC
[    61.867] (II) Initializing built-in extension SECURITY
[    61.867] (II) Initializing built-in extension XINERAMA
[    61.867] (II) Initializing built-in extension XFIXES
[    61.867] (II) Initializing built-in extension RENDER
[    61.867] (II) Initializing built-in extension RANDR
[    61.867] (II) Initializing built-in extension COMPOSITE
[    61.867] (II) Initializing built-in extension DAMAGE
[    61.921] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    61.921] (II) AIGLX: enabled GLX_INTEL_swap_event
[    61.921] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    61.921] (II) AIGLX: enabled GLX_SGI_make_current_read
[    61.921] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    61.921] (II) AIGLX: Loaded and initialized i965
[    61.921] (II) GLX: Initialized DRI2 GL provider for screen 0
[    61.921] (II) intel(0): Setting screen physical size to 381 x 238
[    62.001] (II) config/udev: Adding input device Power Button (/dev/input/event7)
[    62.001] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    62.001] (II) LoadModule: "evdev"
[    62.001] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.003] (II) Module evdev: vendor="X.Org Foundation"
[    62.003] 	compiled for 1.10.99.902, module version = 2.6.0
[    62.003] 	Module class: X.Org XInput Driver
[    62.003] 	ABI class: X.Org XInput driver, version 13.0
[    62.003] (II) Using input driver 'evdev' for 'Power Button'
[    62.003] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.003] (**) Power Button: always reports core events
[    62.003] (**) Power Button: Device: "/dev/input/event7"
[    62.003] (--) Power Button: Found keys
[    62.003] (II) Power Button: Configuring as keyboard
[    62.003] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input7/event7"
[    62.003] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 6)
[    62.003] (**) Option "xkb_rules" "evdev"
[    62.003] (**) Option "xkb_model" "evdev"
[    62.003] (**) Option "xkb_layout" "us"
[    62.030] (II) config/udev: Adding input device Video Bus (/dev/input/event10)
[    62.030] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    62.030] (II) Using input driver 'evdev' for 'Video Bus'
[    62.030] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.030] (**) Video Bus: always reports core events
[    62.030] (**) Video Bus: Device: "/dev/input/event10"
[    62.030] (--) Video Bus: Found keys
[    62.030] (II) Video Bus: Configuring as keyboard
[    62.030] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input10/event10"
[    62.030] (II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD, id 7)
[    62.030] (**) Option "xkb_rules" "evdev"
[    62.030] (**) Option "xkb_model" "evdev"
[    62.030] (**) Option "xkb_layout" "us"
[    62.030] (II) config/udev: Adding input device Power Button (/dev/input/event5)
[    62.030] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    62.030] (II) Using input driver 'evdev' for 'Power Button'
[    62.030] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.030] (**) Power Button: always reports core events
[    62.031] (**) Power Button: Device: "/dev/input/event5"
[    62.031] (--) Power Button: Found keys
[    62.031] (II) Power Button: Configuring as keyboard
[    62.031] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5/event5"
[    62.031] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD, id 8)
[    62.031] (**) Option "xkb_rules" "evdev"
[    62.031] (**) Option "xkb_model" "evdev"
[    62.031] (**) Option "xkb_layout" "us"
[    62.031] (II) config/udev: Adding input device Lid Switch (/dev/input/event4)
[    62.031] (II) No input driver/identifier specified (ignoring)
[    62.031] (II) config/udev: Adding input device Sleep Button (/dev/input/event6)
[    62.031] (**) Sleep Button: Applying InputClass "evdev keyboard catchall"
[    62.031] (II) Using input driver 'evdev' for 'Sleep Button'
[    62.031] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.031] (**) Sleep Button: always reports core events
[    62.031] (**) Sleep Button: Device: "/dev/input/event6"
[    62.031] (--) Sleep Button: Found keys
[    62.031] (II) Sleep Button: Configuring as keyboard
[    62.031] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input6/event6"
[    62.031] (II) XINPUT: Adding extended input device "Sleep Button" (type: KEYBOARD, id 9)
[    62.031] (**) Option "xkb_rules" "evdev"
[    62.031] (**) Option "xkb_model" "evdev"
[    62.031] (**) Option "xkb_layout" "us"
[    62.032] (II) config/udev: Adding input device HID 05ac:820a (/dev/input/event2)
[    62.032] (**) HID 05ac:820a: Applying InputClass "evdev keyboard catchall"
[    62.032] (II) Using input driver 'evdev' for 'HID 05ac:820a'
[    62.032] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.032] (**) HID 05ac:820a: always reports core events
[    62.032] (**) HID 05ac:820a: Device: "/dev/input/event2"
[    62.032] (--) HID 05ac:820a: Found keys
[    62.032] (II) HID 05ac:820a: Configuring as keyboard
[    62.032] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input2/event2"
[    62.032] (II) XINPUT: Adding extended input device "HID 05ac:820a" (type: KEYBOARD, id 10)
[    62.032] (**) Option "xkb_rules" "evdev"
[    62.032] (**) Option "xkb_model" "evdev"
[    62.032] (**) Option "xkb_layout" "us"
[    62.033] (II) config/udev: Adding input device HID 05ac:820b (/dev/input/event3)
[    62.033] (**) HID 05ac:820b: Applying InputClass "evdev pointer catchall"
[    62.033] (II) Using input driver 'evdev' for 'HID 05ac:820b'
[    62.033] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.033] (**) HID 05ac:820b: always reports core events
[    62.033] (**) HID 05ac:820b: Device: "/dev/input/event3"
[    62.033] (--) HID 05ac:820b: Found 3 mouse buttons
[    62.033] (--) HID 05ac:820b: Found relative axes
[    62.033] (--) HID 05ac:820b: Found x and y relative axes
[    62.033] (II) HID 05ac:820b: Configuring as mouse
[    62.033] (**) HID 05ac:820b: YAxisMapping: buttons 4 and 5
[    62.033] (**) HID 05ac:820b: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    62.033] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input3/event3"
[    62.033] (II) XINPUT: Adding extended input device "HID 05ac:820b" (type: MOUSE, id 11)
[    62.033] (II) HID 05ac:820b: initialized for relative axes.
[    62.033] (**) HID 05ac:820b: (accel) keeping acceleration scheme 1
[    62.033] (**) HID 05ac:820b: (accel) acceleration profile 0
[    62.033] (**) HID 05ac:820b: (accel) acceleration factor: 2.000
[    62.033] (**) HID 05ac:820b: (accel) acceleration threshold: 4
[    62.033] (II) config/udev: Adding input device HID 05ac:820b (/dev/input/mouse1)
[    62.033] (II) No input driver/identifier specified (ignoring)
[    62.034] (II) config/udev: Adding input device Apple Inc. Apple Internal Keyboard / Trackpad (/dev/input/event0)
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: Applying InputClass "evdev keyboard catchall"
[    62.034] (II) Using input driver 'evdev' for 'Apple Inc. Apple Internal Keyboard / Trackpad'
[    62.034] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: always reports core events
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: Device: "/dev/input/event0"
[    62.034] (--) Apple Inc. Apple Internal Keyboard / Trackpad: Found keys
[    62.034] (II) Apple Inc. Apple Internal Keyboard / Trackpad: Configuring as keyboard
[    62.034] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input0/event0"
[    62.034] (II) XINPUT: Adding extended input device "Apple Inc. Apple Internal Keyboard / Trackpad" (type: KEYBOARD, id 12)
[    62.034] (**) Option "xkb_rules" "evdev"
[    62.034] (**) Option "xkb_model" "evdev"
[    62.034] (**) Option "xkb_layout" "us"
[    62.034] (II) config/udev: Adding input device Apple Inc. Apple Internal Keyboard / Trackpad (/dev/input/event1)
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: Applying InputClass "evdev pointer catchall"
[    62.034] (II) Using input driver 'evdev' for 'Apple Inc. Apple Internal Keyboard / Trackpad'
[    62.034] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: always reports core events
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: Device: "/dev/input/event1"
[    62.034] (--) Apple Inc. Apple Internal Keyboard / Trackpad: Found 3 mouse buttons
[    62.034] (--) Apple Inc. Apple Internal Keyboard / Trackpad: Found relative axes
[    62.034] (--) Apple Inc. Apple Internal Keyboard / Trackpad: Found x and y relative axes
[    62.034] (II) Apple Inc. Apple Internal Keyboard / Trackpad: Configuring as mouse
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: YAxisMapping: buttons 4 and 5
[    62.034] (**) Apple Inc. Apple Internal Keyboard / Trackpad: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    62.034] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input1/event1"
[    62.034] (II) XINPUT: Adding extended input device "Apple Inc. Apple Internal Keyboard / Trackpad" (type: MOUSE, id 13)
[    62.034] (II) Apple Inc. Apple Internal Keyboard / Trackpad: initialized for relative axes.
[    62.035] (**) Apple Inc. Apple Internal Keyboard / Trackpad: (accel) keeping acceleration scheme 1
[    62.035] (**) Apple Inc. Apple Internal Keyboard / Trackpad: (accel) acceleration profile 0
[    62.035] (**) Apple Inc. Apple Internal Keyboard / Trackpad: (accel) acceleration factor: 2.000
[    62.035] (**) Apple Inc. Apple Internal Keyboard / Trackpad: (accel) acceleration threshold: 4
[    62.035] (II) config/udev: Adding input device Apple Inc. Apple Internal Keyboard / Trackpad (/dev/input/mouse0)
[    62.035] (II) No input driver/identifier specified (ignoring)
[    62.035] (II) config/udev: Adding input device FaceTime Camera (Built-in) (/dev/input/event9)
[    62.035] (**) FaceTime Camera (Built-in): Applying InputClass "evdev keyboard catchall"
[    62.035] (II) Using input driver 'evdev' for 'FaceTime Camera (Built-in)'
[    62.035] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    62.035] (**) FaceTime Camera (Built-in): always reports core events
[    62.035] (**) FaceTime Camera (Built-in): Device: "/dev/input/event9"
[    62.035] (--) FaceTime Camera (Built-in): Found keys
[    62.035] (II) FaceTime Camera (Built-in): Configuring as keyboard
[    62.035] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input9/event9"
[    62.035] (II) XINPUT: Adding extended input device "FaceTime Camera (Built-in)" (type: KEYBOARD, id 14)
[    62.035] (**) Option "xkb_rules" "evdev"
[    62.035] (**) Option "xkb_model" "evdev"
[    62.035] (**) Option "xkb_layout" "us"
[    62.036] (II) config/udev: Adding input device HDA Intel PCH HDMI/DP (/dev/input/event11)
[    62.036] (II) No input driver/identifier specified (ignoring)
[    62.036] (II) config/udev: Adding input device HDA Intel PCH HDMI/DP (/dev/input/event12)
[    62.036] (II) No input driver/identifier specified (ignoring)
[    62.036] (II) config/udev: Adding input device HDA Intel PCH HDMI/DP (/dev/input/event13)
[    62.036] (II) No input driver/identifier specified (ignoring)
[    62.037] (II) config/udev: Adding input device PC Speaker (/dev/input/event8)
[    62.037] (II) No input driver/identifier specified (ignoring)
[  1441.968] (II) intel(0): EDID vendor "APP", prod id 40176
[  1441.969] (II) intel(0): Printing DDC gathered Modelines:
[  1441.969] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3533.789] (II) intel(0): EDID vendor "APP", prod id 40176
[  3533.789] (II) intel(0): Printing DDC gathered Modelines:
[  3533.789] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3534.039] (II) Quirked EDID physical size to 0x0 cm
[  3546.186] (II) intel(0): EDID vendor "APP", prod id 40176
[  3546.186] (II) intel(0): Printing DDC gathered Modelines:
[  3546.186] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3546.437] (II) Quirked EDID physical size to 0x0 cm
[  3580.187] (II) intel(0): EDID vendor "APP", prod id 40176
[  3580.187] (II) intel(0): Printing DDC gathered Modelines:
[  3580.187] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3580.437] (II) Quirked EDID physical size to 0x0 cm
[  3580.608] (II) intel(0): Allocated new frame buffer 3392x1080 stride 13824, tiled
[  3581.429] (II) intel(0): EDID vendor "APP", prod id 40176
[  3581.429] (II) intel(0): Printing DDC gathered Modelines:
[  3581.429] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3582.393] (II) intel(0): EDID vendor "APP", prod id 40176
[  3582.393] (II) intel(0): Printing DDC gathered Modelines:
[  3582.393] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3582.642] (II) Quirked EDID physical size to 0x0 cm
[  3594.293] (II) intel(0): EDID vendor "APP", prod id 40176
[  3594.293] (II) intel(0): Printing DDC gathered Modelines:
[  3594.293] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3594.545] (II) Quirked EDID physical size to 0x0 cm
[  3614.080] (II) intel(0): EDID vendor "APP", prod id 40176
[  3614.081] (II) intel(0): Printing DDC gathered Modelines:
[  3614.081] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3614.329] (II) Quirked EDID physical size to 0x0 cm
[  3624.199] (II) intel(0): EDID vendor "APP", prod id 40176
[  3624.199] (II) intel(0): Printing DDC gathered Modelines:
[  3624.200] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3625.142] (II) intel(0): EDID vendor "APP", prod id 40176
[  3625.142] (II) intel(0): Printing DDC gathered Modelines:
[  3625.142] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3625.391] (II) Quirked EDID physical size to 0x0 cm
[  3645.769] (II) intel(0): EDID vendor "APP", prod id 40176
[  3645.769] (II) intel(0): Printing DDC gathered Modelines:
[  3645.769] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3646.719] (II) intel(0): EDID vendor "APP", prod id 40176
[  3646.719] (II) intel(0): Printing DDC gathered Modelines:
[  3646.719] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3646.978] (II) Quirked EDID physical size to 0x0 cm
[  3930.806] (II) intel(0): EDID vendor "APP", prod id 40176
[  3930.806] (II) intel(0): Printing DDC gathered Modelines:
[  3930.806] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3931.076] (II) Quirked EDID physical size to 0x0 cm
[  3932.177] (II) intel(0): Allocated new frame buffer 1472x900 stride 6144, tiled
[  3972.436] (II) intel(0): EDID vendor "APP", prod id 40176
[  3972.436] (II) intel(0): Printing DDC gathered Modelines:
[  3972.436] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3973.409] (II) intel(0): EDID vendor "APP", prod id 40176
[  3973.409] (II) intel(0): Printing DDC gathered Modelines:
[  3973.409] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3973.662] (II) Quirked EDID physical size to 0x0 cm
[  3998.536] (II) intel(0): EDID vendor "APP", prod id 40176
[  3998.536] (II) intel(0): Printing DDC gathered Modelines:
[  3998.536] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3999.513] (II) intel(0): EDID vendor "APP", prod id 40176
[  3999.513] (II) intel(0): Printing DDC gathered Modelines:
[  3999.513] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  3999.763] (II) Quirked EDID physical size to 0x0 cm
[  4005.416] (II) intel(0): EDID vendor "APP", prod id 40176
[  4005.416] (II) intel(0): Printing DDC gathered Modelines:
[  4005.416] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  4029.551] (II) intel(0): EDID vendor "APP", prod id 40176
[  4029.551] (II) intel(0): Printing DDC gathered Modelines:
[  4029.551] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)
[  4044.455] (II) intel(0): EDID vendor "APP", prod id 40176
[  4044.455] (II) intel(0): Printing DDC gathered Modelines:
[  4044.455] (II) intel(0): Modeline "1440x900"x0.0   88.89  1440 1488 1520 1600  900 903 909 926 -hsync -vsync (55.6 kHz)

--A6N2fC+uXW/VQSAv--
