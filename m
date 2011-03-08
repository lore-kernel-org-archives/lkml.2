Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1CHJfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:35:41 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39036 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1CHJff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:35:35 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Date: Tue, 8 Mar 2011 10:35:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7-tp42-snapshot-p1+2-00163-gfb62c00-dirty; KDE/4.5.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>
References: <201103051510.35057.Martin@lichtvoll.de> <201103062020.21959.Martin@lichtvoll.de> <AANLkTinhx12_HvDq3Mp7xrkrCez90pNiSuh7KrJAmFXp@mail.gmail.com> (sfid-20110306_225141_227758_3579E4FA)
In-Reply-To: <AANLkTinhx12_HvDq3Mp7xrkrCez90pNiSuh7KrJAmFXp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8966602.QD4hpjIMDz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103081035.24459.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8966602.QD4hpjIMDz
Content-Type: multipart/mixed;
  boundary="Boundary-01=_WhfdNHASEG5wotN"
Content-Transfer-Encoding: 7bit


--Boundary-01=_WhfdNHASEG5wotN
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Its rainy again in Sevilla...

Am Sunday 06 March 2011 schrieb Dave Airlie:
> > I verified this. Lockup happens with 2.6.38, last one tested
> > rc8-gfb62c00, but not with 2.6.37 with exactly same userspace.
> > Needed to try the effect several times, as this time the lockup with
> > 2.6.38 only happened shortly after the second activation of the
> > effect.
>=20
> Hmm, can you attach Xorg logs from both?

Attached. I have dmesgs available as well. Both kernels are mainly=20
upstream. The 2.6.37 contains some recursive mtime patches from Jan for=20
Ext3/4 that are very likely unrelated. For 2.6.38 I am testing too=20
hibernation patches from Raphael, but the lockup also happened with a=20
plain vanilla 2.6.38 one before.
=20
> I'm guessing its either pageflipping or a later kernel allowing some
> feature of mesa to be used.

I guess so too. This is the mesa stuff I use:

martin@shambhala:~> apt-show-versions | egrep "(libdrm|libkms|libgl1-
mesa)"
libdrm-intel1/sid uptodate 2.4.23-3
libdrm-nouveau1/wheezy uptodate 2.4.21-1~squeeze3
libdrm-radeon1/sid uptodate 2.4.23-3
libdrm-radeon1-dbg/sid uptodate 2.4.23-3
libdrm2/sid uptodate 2.4.23-3
libdrm2-dbg/sid uptodate 2.4.23-3
libgl1-mesa-dev/sid uptodate 7.10-4
libgl1-mesa-dri/sid uptodate 7.10-4
libgl1-mesa-dri-dbg/sid uptodate 7.10-4
libgl1-mesa-glx/sid uptodate 7.10-4
libgl1-mesa-glx-dbg/sid uptodate 7.10-4
libkms1/sid uptodate 2.4.23-3

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-01=_WhfdNHASEG5wotN
Content-Type: text/x-log;
  charset="UTF-8";
  name="Xorg.0-2.6.38-rc7-tp42-snapshot-p1+2-00163-gfb62c00-dirty.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Xorg.0-2.6.38-rc7-tp42-snapshot-p1+2-00163-gfb62c00-dirty.log"

[    41.969]=20
X.Org X Server 1.9.4
Release Date: 2011-02-04
[    42.007] X Protocol Version 11, Revision 0
[    42.007] Build Operating System: Linux 2.6.32.29-dsa-ia32 i686 Debian
[    42.007] Current Operating System: Linux shambhala 2.6.38-rc7-tp42-snap=
shot-p1+2-00163-gfb62c00-dirty #6 PREEMPT Sun Mar 6 19:22:04 CET 2011 i686
[    42.007] Kernel command line: BOOT_IMAGE=3D/vmlinuz-2.6.38-rc7-tp42-sna=
pshot-p1+2-00163-gfb62c00-dirty root=3D/dev/mapper/shambhala-debian ro no_c=
onsole_suspend splash cgroup_disable=3Dmemory resume=3D/dev/sda2
[    42.008] Build Date: 20 February 2011  05:47:22AM
[    42.008] xorg-server 2:1.9.4-3 (Cyril Brulebois <kibi@debian.org>)=20
[    42.008] Current version of pixman: 0.21.4
[    42.008] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    42.008] Markers: (--) probed, (**) from config file, (=3D=3D) default =
setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    42.008] (=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Tue Mar  8 10:=
05:42 2011
[    42.102] (=3D=3D) Using config directory: "/etc/X11/xorg.conf.d"
[    42.102] (=3D=3D) Using system config directory "/usr/share/X11/xorg.co=
nf.d"
[    42.160] (=3D=3D) No Layout section.  Using the first Screen section.
[    42.160] (=3D=3D) No screen section available. Using defaults.
[    42.160] (**) |-->Screen "Default Screen Section" (0)
[    42.160] (**) |   |-->Monitor "<default monitor>"
[    42.180] (=3D=3D) No device specified for screen "Default Screen Sectio=
n".
	Using the first device section listed.
[    42.180] (**) |   |-->Device "Grafikchip"
[    42.180] (=3D=3D) No monitor specified for screen "Default Screen Secti=
on".
	Using a default monitor configuration.
[    42.180] (=3D=3D) Automatically adding devices
[    42.180] (=3D=3D) Automatically enabling devices
[    42.255] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not ex=
ist.
[    42.255] 	Entry deleted from font path.
[    42.329] (=3D=3D) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    42.329] (=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
[    42.329] (II) The server relies on udev to provide the list of input de=
vices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    42.329] (II) Loader magic: 0x81f7140
[    42.329] (II) Module ABI versions:
[    42.329] 	X.Org ANSI C Emulation: 0.4
[    42.329] 	X.Org Video Driver: 8.0
[    42.329] 	X.Org XInput driver : 11.0
[    42.329] 	X.Org Server Extension : 4.0
[    42.330] (--) PCI:*(0:1:0:0) 1002:4e50:1014:0550 rev 0, Mem @ 0xe000000=
0/134217728, 0xc0100000/65536, I/O @ 0x00003000/256, BIOS @ 0x????????/1310=
72
[    42.330] (II) Open ACPI successful (/var/run/acpid.socket)
[    42.330] (II) LoadModule: "extmod"
[    42.377] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    42.393] (II) Module extmod: vendor=3D"X.Org Foundation"
[    42.393] 	compiled for 1.9.4, module version =3D 1.0.0
[    42.393] 	Module class: X.Org Server Extension
[    42.393] 	ABI class: X.Org Server Extension, version 4.0
[    42.393] (II) Loading extension SELinux
[    42.393] (II) Loading extension MIT-SCREEN-SAVER
[    42.393] (II) Loading extension XFree86-VidModeExtension
[    42.393] (II) Loading extension XFree86-DGA
[    42.393] (II) Loading extension DPMS
[    42.393] (II) Loading extension XVideo
[    42.393] (II) Loading extension XVideo-MotionCompensation
[    42.393] (II) Loading extension X-Resource
[    42.393] (II) LoadModule: "dbe"
[    42.393] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    42.402] (II) Module dbe: vendor=3D"X.Org Foundation"
[    42.402] 	compiled for 1.9.4, module version =3D 1.0.0
[    42.402] 	Module class: X.Org Server Extension
[    42.402] 	ABI class: X.Org Server Extension, version 4.0
[    42.402] (II) Loading extension DOUBLE-BUFFER
[    42.402] (II) LoadModule: "glx"
[    42.403] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    42.426] (II) Module glx: vendor=3D"X.Org Foundation"
[    42.426] 	compiled for 1.9.4, module version =3D 1.0.0
[    42.426] 	ABI class: X.Org Server Extension, version 4.0
[    42.427] (=3D=3D) AIGLX enabled
[    42.428] (II) Loading extension GLX
[    42.428] (II) LoadModule: "record"
[    42.428] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    42.436] (II) Module record: vendor=3D"X.Org Foundation"
[    42.436] 	compiled for 1.9.4, module version =3D 1.13.0
[    42.436] 	Module class: X.Org Server Extension
[    42.436] 	ABI class: X.Org Server Extension, version 4.0
[    42.436] (II) Loading extension RECORD
[    42.436] (II) LoadModule: "dri"
[    42.436] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    42.448] (II) Module dri: vendor=3D"X.Org Foundation"
[    42.448] 	compiled for 1.9.4, module version =3D 1.0.0
[    42.448] 	ABI class: X.Org Server Extension, version 4.0
[    42.448] (II) Loading extension XFree86-DRI
[    42.448] (II) LoadModule: "dri2"
[    42.448] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    42.459] (II) Module dri2: vendor=3D"X.Org Foundation"
[    42.459] 	compiled for 1.9.4, module version =3D 1.2.0
[    42.459] 	ABI class: X.Org Server Extension, version 4.0
[    42.459] (II) Loading extension DRI2
[    42.459] (=3D=3D) Matched ati as autoconfigured driver 0
[    42.459] (=3D=3D) Matched vesa as autoconfigured driver 1
[    42.459] (=3D=3D) Matched fbdev as autoconfigured driver 2
[    42.459] (=3D=3D) Assigned the driver to the xf86ConfigLayout
[    42.459] (II) LoadModule: "ati"
[    42.459] (II) Loading /usr/lib/xorg/modules/drivers/ati_drv.so
[    42.465] (II) Module ati: vendor=3D"X.Org Foundation"
[    42.465] 	compiled for 1.9.4, module version =3D 6.14.0
[    42.465] 	Module class: X.Org Video Driver
[    42.465] 	ABI class: X.Org Video Driver, version 8.0
[    42.465] (II) LoadModule: "radeon"
[    42.466] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[    42.506] (II) Module radeon: vendor=3D"X.Org Foundation"
[    42.506] 	compiled for 1.9.4, module version =3D 6.14.0
[    42.506] 	Module class: X.Org Video Driver
[    42.506] 	ABI class: X.Org Video Driver, version 8.0
[    42.507] (II) LoadModule: "vesa"
[    42.507] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    42.524] (II) Module vesa: vendor=3D"X.Org Foundation"
[    42.524] 	compiled for 1.9.4, module version =3D 2.3.0
[    42.524] 	Module class: X.Org Video Driver
[    42.524] 	ABI class: X.Org Video Driver, version 8.0
[    42.524] (II) LoadModule: "fbdev"
[    42.524] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    42.537] (II) Module fbdev: vendor=3D"X.Org Foundation"
[    42.542] 	compiled for 1.9.4, module version =3D 0.4.2
[    42.542] 	ABI class: X.Org Video Driver, version 8.0
[    42.542] (II) RADEON: Driver for ATI Radeon chipsets:
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
	AMD Radeon HD 6250 Graphics, CYPRESS,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, AMD Firestream 9370,
	AMD Firestream 9350, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5900 Series, ATI Radeon HD 5900 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 5700 Series,
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
	ATI Radeon HD 5450, CEDAR, AMD Radeon HD 6900M Series,
	Mobility Radeon HD 6000 Series, BARTS, BARTS,
	Mobility Radeon HD 6000 Series, Mobility Radeon HD 6000 Series,
	BARTS, BARTS, BARTS, BARTS, AMD Radeon HD 6800 Series,
	AMD Radeon HD 6800 Series, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS,
	TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, CAICOS, CAICOS,
	CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
	CAICOS
[    42.545] (II) VESA: driver for VESA chipsets: vesa
[    42.545] (II) FBDEV: driver for framebuffer: fbdev
[    42.545] (++) using VT number 7

[    42.612] (II) [KMS] Kernel modesetting enabled.
[    42.612] (WW) Falling back to old probe method for vesa
[    42.612] (WW) Falling back to old probe method for fbdev
[    42.612] (II) Loading sub module "fbdevhw"
[    42.612] (II) LoadModule: "fbdevhw"
[    42.613] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    42.682] (II) Module fbdevhw: vendor=3D"X.Org Foundation"
[    42.682] 	compiled for 1.9.4, module version =3D 0.0.2
[    42.682] 	ABI class: X.Org Video Driver, version 8.0
[    42.682] (II) RADEON(0): Creating default Display subsection in Screen =
section
	"Default Screen Section" for depth/fbbpp 24/32
[    42.682] (=3D=3D) RADEON(0): Depth 24, (--) framebuffer bpp 32
[    42.682] (II) RADEON(0): Pixel depth =3D 24 bits stored in 4 bytes (32 =
bpp pixmaps)
[    42.682] (=3D=3D) RADEON(0): Default visual is TrueColor
[    42.683] (=3D=3D) RADEON(0): RGB weight 888
[    42.683] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[    42.683] (--) RADEON(0): Chipset: "ATI Radeon Mobility 9600/9700 (M10/M=
11) NP (AGP)" (ChipID =3D 0x4e50)
[    42.683] (II) RADEON(0): AGP card detected
[    42.683] drmOpenDevice: node name is /dev/dri/card0
[    42.683] drmOpenDevice: open result is 9, (OK)
[    42.683] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[    42.683] drmOpenDevice: node name is /dev/dri/card0
[    42.683] drmOpenDevice: open result is 9, (OK)
[    42.683] drmOpenByBusid: drmOpenMinor returns 9
[    42.683] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[    42.683] (II) RADEON(0): KMS Color Tiling: enabled
[    42.683] (II) RADEON(0): KMS Pageflipping: enabled
[    42.683] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[    42.694] (II) RADEON(0): Output VGA-0 has no monitor section
[    42.700] (II) RADEON(0): Output DVI-0 has no monitor section
[    42.700] (II) RADEON(0): Output LVDS using monitor section Notebook-Dis=
play
[    42.722] (II) RADEON(0): Output S-video has no monitor section
[    42.731] (II) RADEON(0): EDID for output VGA-0
[    42.738] (II) RADEON(0): EDID for output DVI-0
[    42.738] (II) RADEON(0): EDID for output LVDS
[    42.738] (II) RADEON(0): Not using default mode "640x350" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "320x175" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "640x400" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "320x200" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "720x400" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "360x200" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "320x240" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "320x240" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "320x240" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1024x768i" (vrefresh o=
ut of range)
[    42.738] (II) RADEON(0): Not using default mode "512x384i" (vrefresh ou=
t of range)
[    42.738] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    42.738] (II) RADEON(0): Not using default mode "512x384" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    42.738] (II) RADEON(0): Not using default mode "512x384" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    42.738] (II) RADEON(0): Not using default mode "512x384" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    42.738] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1280x960" (vrefresh ou=
t of range)
[    42.738] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1280x1024" (vrefresh o=
ut of range)
[    42.738] (II) RADEON(0): Not using default mode "640x512" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1280x1024" (vrefresh o=
ut of range)
[    42.738] (II) RADEON(0): Not using default mode "640x512" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1600x1200" (hsync out =
of range)
[    42.738] (II) RADEON(0): Not using default mode "800x600" (hsync out of=
 range)
[    42.738] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    42.738] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.738] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    42.738] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1792x1344" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "896x672" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1792x1344" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "896x672" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1856x1392" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "928x696" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1856x1392" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "928x696" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1920x1440" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "960x720" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1920x1440" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "960x720" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "832x624" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "416x312" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    42.739] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    42.739] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    42.739] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    42.739] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    42.739] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1360x768" (monitor doe=
sn't support reduced blanking)
[    42.739] (II) RADEON(0): Not using default mode "1400x1050" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "700x525" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1400x1050" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "700x525" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1400x1050" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "700x525" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1400x1050" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "700x525" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1680x1050" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "840x525" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1680x1050" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "840x525" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1680x1050" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "840x525" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1680x1050" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "840x525" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1680x1050" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "840x525" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "1920x1080" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "960x540" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1920x1200" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "960x600" (hsync out of=
 range)
[    42.739] (II) RADEON(0): Not using default mode "1920x1440" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "960x720" (vrefresh out=
 of range)
[    42.739] (II) RADEON(0): Not using default mode "2048x1536" (hsync out =
of range)
[    42.739] (II) RADEON(0): Not using default mode "1024x768" (hsync out o=
f range)
[    42.739] (II) RADEON(0): Not using default mode "2048x1536" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    42.739] (II) RADEON(0): Not using default mode "2048x1536" (vrefresh o=
ut of range)
[    42.739] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    42.739] (II) RADEON(0): Printing probed modes for output LVDS
[    42.739] (II) RADEON(0): Modeline "1400x1050"x60.2  108.00  1400 34208 =
34320 1688  1050 1052 1055 1063 (64.0 kHz)
[    42.739] (II) RADEON(0): Modeline "1600x1024"x60.2  103.12  1600 1600 1=
656 1664  1024 1024 1029 1030 +hsync +vsync (62.0 kHz)
[    42.739] (II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1=
496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
[    42.739] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1=
440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    42.739] (II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1520 16=
72 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    42.739] (II) RADEON(0): Modeline "1280x960"x60.0  108.00  1280 1376 14=
88 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    42.739] (II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 14=
88 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
[    42.739] (II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 14=
80 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
[    42.739] (II) RADEON(0): Modeline "1360x768"x59.8   84.75  1360 1432 15=
68 1776  768 771 781 798 -hsync +vsync (47.7 kHz)
[    42.739] (II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 14=
80 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
[    42.739] (II) RADEON(0): Modeline "1152x864"x60.0   81.62  1152 1216 13=
36 1520  864 865 868 895 -hsync +vsync (53.7 kHz)
[    42.739] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 14=
72 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[    42.739] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 13=
28 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[    42.739] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048 11=
84 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    42.739] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 11=
76 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[    42.739] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840 968 1=
056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    42.739] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1=
024  600 603 607 624 -hsync +vsync (37.4 kHz)
[    42.739] (II) RADEON(0): Modeline "800x512"x60.2   51.56  800 800 828 8=
32  512 512 514 515 doublescan +hsync +vsync (62.0 kHz)
[    42.739] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1=
056  480 483 493 500 -hsync +vsync (29.8 kHz)
[    42.740] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 8=
96  480 483 493 500 -hsync +vsync (29.9 kHz)
[    42.740] (II) RADEON(0): Modeline "640x512"x60.0   54.00  640 664 720 8=
44  512 512 514 533 doublescan +hsync +vsync (64.0 kHz)
[    42.740] (II) RADEON(0): Modeline "720x450"x59.9   53.25  720 760 836 9=
52  450 451 454 467 doublescan -hsync +vsync (55.9 kHz)
[    42.740] (II) RADEON(0): Modeline "640x480"x60.0   54.00  640 688 744 9=
00  480 480 482 500 doublescan +hsync +vsync (60.0 kHz)
[    42.740] (II) RADEON(0): Modeline "640x480"x59.9   25.18  640 656 752 8=
00  480 490 492 525 -hsync -vsync (31.5 kHz)
[    42.740] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 8=
00  480 483 487 500 -hsync +vsync (29.7 kHz)
[    42.740] (II) RADEON(0): Modeline "680x384"x59.8   42.38  680 716 784 8=
88  384 385 390 399 doublescan -hsync +vsync (47.7 kHz)
[    42.740] (II) RADEON(0): Modeline "680x384"x60.0   36.00  680 704 720 7=
60  384 385 390 395 doublescan +hsync -vsync (47.4 kHz)
[    42.740] (II) RADEON(0): Modeline "576x432"x60.1   40.81  576 608 668 7=
60  432 432 434 447 doublescan -hsync +vsync (53.7 kHz)
[    42.740] (II) RADEON(0): Modeline "512x384"x60.0   32.50  512 524 592 6=
72  384 385 388 403 doublescan -hsync -vsync (48.4 kHz)
[    42.740] (II) RADEON(0): Modeline "400x300"x60.3   20.00  400 420 484 5=
28  300 300 302 314 doublescan +hsync +vsync (37.9 kHz)
[    42.740] (II) RADEON(0): Modeline "320x240"x60.1   12.59  320 328 376 4=
00  240 245 246 262 doublescan -hsync -vsync (31.5 kHz)
[    42.763] (II) RADEON(0): EDID for output S-video
[    42.763] (II) RADEON(0): Output VGA-0 disconnected
[    42.763] (II) RADEON(0): Output DVI-0 disconnected
[    42.763] (II) RADEON(0): Output LVDS connected
[    42.763] (II) RADEON(0): Output S-video disconnected
[    42.763] (II) RADEON(0): Using exact sizes for initial modes
[    42.763] (II) RADEON(0): Output LVDS using initial mode 1400x1050
[    42.763] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless =
otherwise stated.
[    42.763] (II) RADEON(0): Output LVDS wants gamma correction (1.2, 1.2, =
1.2)
[    42.763] (II) RADEON(0): mem size init: gart size :fdff000 vram size: s=
:4000000 visible:3a1c000
[    42.763] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[    42.763] (=3D=3D) RADEON(0): DPI set to (96, 96)
[    42.763] (II) Loading sub module "fb"
[    42.763] (II) LoadModule: "fb"
[    42.775] (II) Loading /usr/lib/xorg/modules/libfb.so
[    42.793] (II) Module fb: vendor=3D"X.Org Foundation"
[    42.793] 	compiled for 1.9.4, module version =3D 1.0.0
[    42.793] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    42.793] (II) Loading sub module "ramdac"
[    42.793] (II) LoadModule: "ramdac"
[    42.793] (II) Module "ramdac" already built-in
[    42.794] (II) Loading sub module "exa"
[    42.794] (II) LoadModule: "exa"
[    42.794] (II) Loading /usr/lib/xorg/modules/libexa.so
[    42.802] (II) Module exa: vendor=3D"X.Org Foundation"
[    42.802] 	compiled for 1.9.4, module version =3D 2.5.0
[    42.802] 	ABI class: X.Org Video Driver, version 8.0
[    42.802] (II) UnloadModule: "vesa"
[    42.802] (II) Unloading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    42.802] (II) UnloadModule: "fbdev"
[    42.802] (II) Unloading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    42.802] (II) UnloadModule: "fbdevhw"
[    42.802] (II) Unloading /usr/lib/xorg/modules/libfbdevhw.so
[    42.802] (--) Depth 24 pixmap format is 32 bpp
[    42.802] (II) RADEON(0): [DRI2] Setup complete
[    42.802] (II) RADEON(0): [DRI2]   DRI driver: r300
[    42.802] (II) RADEON(0): Front buffer size: 5808K
[    42.802] (II) RADEON(0): VRAM usage limit set to 48326K
[    42.824] (=3D=3D) RADEON(0): Backing store disabled
[    42.824] (II) RADEON(0): Direct rendering enabled
[    42.845] (II) RADEON(0): Render acceleration enabled for R300/R400/R500=
 type cards.
[    42.845] (II) RADEON(0): Setting EXA maxPitchBytes
[    42.845] (II) EXA(0): Driver allocated offscreen pixmaps
[    42.846] (II) EXA(0): Driver registered support for the following opera=
tions:
[    42.846] (II)         Solid
[    42.846] (II)         Copy
[    42.846] (II)         Composite (RENDER acceleration)
[    42.846] (II)         UploadToScreen
[    42.846] (II)         DownloadFromScreen
[    42.846] (II) RADEON(0): Acceleration enabled
[    42.846] (=3D=3D) RADEON(0): DPMS enabled
[    42.846] (=3D=3D) RADEON(0): Silken mouse enabled
[    42.865] (II) RADEON(0): Set up textured video
[    42.865] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR =
disabled message.
[    42.866] (--) RandR disabled
[    42.866] (II) Initializing built-in extension Generic Event Extension
[    42.866] (II) Initializing built-in extension SHAPE
[    42.866] (II) Initializing built-in extension MIT-SHM
[    42.866] (II) Initializing built-in extension XInputExtension
[    42.866] (II) Initializing built-in extension XTEST
[    42.866] (II) Initializing built-in extension BIG-REQUESTS
[    42.866] (II) Initializing built-in extension SYNC
[    42.866] (II) Initializing built-in extension XKEYBOARD
[    42.866] (II) Initializing built-in extension XC-MISC
[    42.866] (II) Initializing built-in extension XINERAMA
[    42.866] (II) Initializing built-in extension XFIXES
[    42.866] (II) Initializing built-in extension RENDER
[    42.866] (II) Initializing built-in extension RANDR
[    42.866] (II) Initializing built-in extension COMPOSITE
[    42.866] (II) Initializing built-in extension DAMAGE
[    42.866] (II) SELinux: Disabled on system
[    43.066] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    43.066] (II) AIGLX: enabled GLX_INTEL_swap_event
[    43.066] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_con=
trol
[    43.066] (II) AIGLX: enabled GLX_SGI_make_current_read
[    43.066] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objec=
ts
[    43.066] (II) AIGLX: Loaded and initialized /usr/lib/dri/r300_dri.so
[    43.066] (II) GLX: Initialized DRI2 GL provider for screen 0
[    43.079] (II) RADEON(0): Setting screen physical size to 306 x 230
[    44.164] (II) config/udev: Adding input device Power Button (/dev/input=
/event7)
[    44.164] (**) Power Button: Applying InputClass "evdev keyboard catchal=
l"
[    44.164] (II) LoadModule: "evdev"
[    44.164] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    44.197] (II) Module evdev: vendor=3D"X.Org Foundation"
[    44.197] 	compiled for 1.9.4, module version =3D 2.6.0
[    44.197] 	Module class: X.Org XInput Driver
[    44.197] 	ABI class: X.Org XInput driver, version 11.0
[    44.197] (**) Power Button: always reports core events
[    44.197] (**) Power Button: Device: "/dev/input/event7"
[    44.197] (--) Power Button: Found keys
[    44.197] (II) Power Button: Configuring as keyboard
[    44.197] (II) XINPUT: Adding extended input device "Power Button" (type=
: KEYBOARD)
[    44.197] (**) Option "xkb_rules" "evdev"
[    44.197] (**) Option "xkb_model" "pc105"
[    44.197] (**) Option "xkb_layout" "de"
[    44.197] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    44.340] (II) config/udev: Adding input device Video Bus (/dev/input/ev=
ent5)
[    44.340] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    44.340] (**) Video Bus: always reports core events
[    44.340] (**) Video Bus: Device: "/dev/input/event5"
[    44.340] (--) Video Bus: Found keys
[    44.340] (II) Video Bus: Configuring as keyboard
[    44.340] (II) XINPUT: Adding extended input device "Video Bus" (type: K=
EYBOARD)
[    44.340] (**) Option "xkb_rules" "evdev"
[    44.340] (**) Option "xkb_model" "pc105"
[    44.340] (**) Option "xkb_layout" "de"
[    44.340] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    44.342] (II) config/udev: Adding input device Lid Switch (/dev/input/e=
vent4)
[    44.342] (II) No input driver/identifier specified (ignoring)
[    44.342] (II) config/udev: Adding input device Sleep Button (/dev/input=
/event6)
[    44.342] (**) Sleep Button: Applying InputClass "evdev keyboard catchal=
l"
[    44.342] (**) Sleep Button: always reports core events
[    44.342] (**) Sleep Button: Device: "/dev/input/event6"
[    44.342] (--) Sleep Button: Found keys
[    44.342] (II) Sleep Button: Configuring as keyboard
[    44.342] (II) XINPUT: Adding extended input device "Sleep Button" (type=
: KEYBOARD)
[    44.342] (**) Option "xkb_rules" "evdev"
[    44.342] (**) Option "xkb_model" "pc105"
[    44.342] (**) Option "xkb_layout" "de"
[    44.342] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    44.351] (II) config/udev: Adding input device hdaps (/dev/input/event9)
[    44.351] (II) No input driver/identifier specified (ignoring)
[    44.352] (II) config/udev: Adding input device hdaps (/dev/input/js0)
[    44.352] (II) No input driver/identifier specified (ignoring)
[    44.352] (II) config/udev: Adding input device AT Translated Set 2 keyb=
oard (/dev/input/event1)
[    44.352] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev =
keyboard catchall"
[    44.352] (**) AT Translated Set 2 keyboard: always reports core events
[    44.352] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event1"
[    44.352] (--) AT Translated Set 2 keyboard: Found keys
[    44.352] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    44.352] (II) XINPUT: Adding extended input device "AT Translated Set 2=
 keyboard" (type: KEYBOARD)
[    44.352] (**) Option "xkb_rules" "evdev"
[    44.352] (**) Option "xkb_model" "pc105"
[    44.352] (**) Option "xkb_layout" "de"
[    44.352] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    44.353] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event2)
[    44.353] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[    44.353] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[    44.353] (II) LoadModule: "synaptics"
[    44.353] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[    44.394] (II) Module synaptics: vendor=3D"X.Org Foundation"
[    44.395] 	compiled for 1.9.4, module version =3D 1.4.0
[    44.395] 	Module class: X.Org XInput Driver
[    44.395] 	ABI class: X.Org XInput driver, version 11.0
[    44.395] (**) Option "Device" "/dev/input/event2"
[    44.395] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5472
[    44.395] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4448
[    44.395] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[    44.395] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[    44.395] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[    44.395] (--) SynPS/2 Synaptics TouchPad: touchpad found
[    44.395] (**) SynPS/2 Synaptics TouchPad: always reports core events
[    44.395] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[    44.395] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[    44.395] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[    44.395] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.040
[    44.395] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[    44.395] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[    44.395] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[    44.395] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[    44.395] (--) SynPS/2 Synaptics TouchPad: touchpad found
[    44.396] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[    44.396] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[    44.396] (**) Option "Device" "/dev/input/mouse0"
[    44.396] (--) SynPS/2 Synaptics TouchPad: invalid x-axis range.  defaul=
ting to 1615 - 5685
[    44.396] (--) SynPS/2 Synaptics TouchPad: invalid y-axis range.  defaul=
ting to 1729 - 4171
[    44.396] (--) SynPS/2 Synaptics TouchPad: invalid pressure range.  defa=
ulting to 0 - 256
[    44.396] (--) SynPS/2 Synaptics TouchPad: invalid finger width range.  =
defaulting to 0 - 16
[    44.416] (EE) Query no Synaptics: 6003C8
[    44.416] (--) SynPS/2 Synaptics TouchPad: no supported touchpad found
[    44.416] (EE) SynPS/2 Synaptics TouchPad Unable to query/initialize Syn=
aptics hardware.
[    44.416] (EE) PreInit returned NULL for "SynPS/2 Synaptics TouchPad"
[    44.416] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event3)
[    44.416] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[    44.416] (**) TPPS/2 IBM TrackPoint: always reports core events
[    44.416] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event3"
[    44.416] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[    44.416] (--) TPPS/2 IBM TrackPoint: Found relative axes
[    44.416] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[    44.416] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[    44.416] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[    44.417] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[    44.417] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[    44.417] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[    44.417] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[    44.417] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[    44.417] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[    44.417] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[    44.417] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[    44.417] (II) No input driver/identifier specified (ignoring)
[    44.417] (II) config/udev: Adding input device PC Speaker (/dev/input/e=
vent0)
[    44.417] (II) No input driver/identifier specified (ignoring)
[    44.418] (II) config/udev: Adding input device ThinkPad Extra Buttons (=
/dev/input/event8)
[    44.418] (**) ThinkPad Extra Buttons: Applying InputClass "evdev keyboa=
rd catchall"
[    44.418] (**) ThinkPad Extra Buttons: always reports core events
[    44.418] (**) ThinkPad Extra Buttons: Device: "/dev/input/event8"
[    44.418] (--) ThinkPad Extra Buttons: Found keys
[    44.418] (II) ThinkPad Extra Buttons: Configuring as keyboard
[    44.418] (II) XINPUT: Adding extended input device "ThinkPad Extra Butt=
ons" (type: KEYBOARD)
[    44.418] (**) Option "xkb_rules" "evdev"
[    44.418] (**) Option "xkb_model" "pc105"
[    44.418] (**) Option "xkb_layout" "de"
[    44.418] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    44.421] (II) config/udev: Adding input device ACPI Virtual Keyboard De=
vice (/dev/input/event10)
[    44.421] (**) ACPI Virtual Keyboard Device: Applying InputClass "evdev =
keyboard catchall"
[    44.421] (**) ACPI Virtual Keyboard Device: always reports core events
[    44.421] (**) ACPI Virtual Keyboard Device: Device: "/dev/input/event10"
[    44.421] (--) ACPI Virtual Keyboard Device: Found keys
[    44.421] (II) ACPI Virtual Keyboard Device: Configuring as keyboard
[    44.421] (II) XINPUT: Adding extended input device "ACPI Virtual Keyboa=
rd Device" (type: KEYBOARD)
[    44.421] (**) Option "xkb_rules" "evdev"
[    44.421] (**) Option "xkb_model" "pc105"
[    44.421] (**) Option "xkb_layout" "de"
[    44.421] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"

--Boundary-01=_WhfdNHASEG5wotN
Content-Type: text/x-log;
  charset="UTF-8";
  name="Xorg.0-2.6.37-tp42-rtime-00004-g9eb63ce.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Xorg.0-2.6.37-tp42-rtime-00004-g9eb63ce.log"

[    35.299]=20
X.Org X Server 1.9.4
Release Date: 2011-02-04
[    35.308] X Protocol Version 11, Revision 0
[    35.308] Build Operating System: Linux 2.6.32.29-dsa-ia32 i686 Debian
[    35.308] Current Operating System: Linux shambhala 2.6.37-tp42-rtime-00=
004-g9eb63ce #1 PREEMPT Thu Jan 13 10:59:19 CET 2011 i686
[    35.308] Kernel command line: BOOT_IMAGE=3D/vmlinuz-2.6.37-tp42-rtime-0=
0004-g9eb63ce root=3D/dev/mapper/shambhala-debian ro no_console_suspend spl=
ash cgroup_disable=3Dmemory resume=3D/dev/sda2
[    35.308] Build Date: 20 February 2011  05:47:22AM
[    35.308] xorg-server 2:1.9.4-3 (Cyril Brulebois <kibi@debian.org>)=20
[    35.308] Current version of pixman: 0.21.4
[    35.308] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    35.309] Markers: (--) probed, (**) from config file, (=3D=3D) default =
setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    35.309] (=3D=3D) Log file: "/var/log/Xorg.0.log", Time: Tue Mar  8 10:=
01:30 2011
[    35.432] (=3D=3D) Using config directory: "/etc/X11/xorg.conf.d"
[    35.432] (=3D=3D) Using system config directory "/usr/share/X11/xorg.co=
nf.d"
[    35.479] (=3D=3D) No Layout section.  Using the first Screen section.
[    35.479] (=3D=3D) No screen section available. Using defaults.
[    35.479] (**) |-->Screen "Default Screen Section" (0)
[    35.479] (**) |   |-->Monitor "<default monitor>"
[    35.497] (=3D=3D) No device specified for screen "Default Screen Sectio=
n".
	Using the first device section listed.
[    35.497] (**) |   |-->Device "Grafikchip"
[    35.497] (=3D=3D) No monitor specified for screen "Default Screen Secti=
on".
	Using a default monitor configuration.
[    35.497] (=3D=3D) Automatically adding devices
[    35.497] (=3D=3D) Automatically enabling devices
[    35.563] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not ex=
ist.
[    35.563] 	Entry deleted from font path.
[    35.624] (=3D=3D) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    35.624] (=3D=3D) ModulePath set to "/usr/lib/xorg/modules"
[    35.624] (II) The server relies on udev to provide the list of input de=
vices.
	If no devices become available, reconfigure udev or disable AutoAddDevices.
[    35.624] (II) Loader magic: 0x81f7140
[    35.624] (II) Module ABI versions:
[    35.624] 	X.Org ANSI C Emulation: 0.4
[    35.624] 	X.Org Video Driver: 8.0
[    35.624] 	X.Org XInput driver : 11.0
[    35.624] 	X.Org Server Extension : 4.0
[    35.625] (--) PCI:*(0:1:0:0) 1002:4e50:1014:0550 rev 0, Mem @ 0xe000000=
0/134217728, 0xc0100000/65536, I/O @ 0x00003000/256, BIOS @ 0x????????/1310=
72
[    35.625] (II) Open ACPI successful (/var/run/acpid.socket)
[    35.625] (II) LoadModule: "extmod"
[    35.707] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    35.723] (II) Module extmod: vendor=3D"X.Org Foundation"
[    35.723] 	compiled for 1.9.4, module version =3D 1.0.0
[    35.723] 	Module class: X.Org Server Extension
[    35.723] 	ABI class: X.Org Server Extension, version 4.0
[    35.723] (II) Loading extension SELinux
[    35.723] (II) Loading extension MIT-SCREEN-SAVER
[    35.723] (II) Loading extension XFree86-VidModeExtension
[    35.723] (II) Loading extension XFree86-DGA
[    35.723] (II) Loading extension DPMS
[    35.723] (II) Loading extension XVideo
[    35.723] (II) Loading extension XVideo-MotionCompensation
[    35.723] (II) Loading extension X-Resource
[    35.723] (II) LoadModule: "dbe"
[    35.723] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    35.732] (II) Module dbe: vendor=3D"X.Org Foundation"
[    35.732] 	compiled for 1.9.4, module version =3D 1.0.0
[    35.732] 	Module class: X.Org Server Extension
[    35.732] 	ABI class: X.Org Server Extension, version 4.0
[    35.732] (II) Loading extension DOUBLE-BUFFER
[    35.732] (II) LoadModule: "glx"
[    35.733] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    35.756] (II) Module glx: vendor=3D"X.Org Foundation"
[    35.756] 	compiled for 1.9.4, module version =3D 1.0.0
[    35.756] 	ABI class: X.Org Server Extension, version 4.0
[    35.758] (=3D=3D) AIGLX enabled
[    35.758] (II) Loading extension GLX
[    35.758] (II) LoadModule: "record"
[    35.758] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    35.766] (II) Module record: vendor=3D"X.Org Foundation"
[    35.766] 	compiled for 1.9.4, module version =3D 1.13.0
[    35.766] 	Module class: X.Org Server Extension
[    35.766] 	ABI class: X.Org Server Extension, version 4.0
[    35.766] (II) Loading extension RECORD
[    35.766] (II) LoadModule: "dri"
[    35.766] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    35.778] (II) Module dri: vendor=3D"X.Org Foundation"
[    35.778] 	compiled for 1.9.4, module version =3D 1.0.0
[    35.778] 	ABI class: X.Org Server Extension, version 4.0
[    35.778] (II) Loading extension XFree86-DRI
[    35.778] (II) LoadModule: "dri2"
[    35.778] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    35.789] (II) Module dri2: vendor=3D"X.Org Foundation"
[    35.789] 	compiled for 1.9.4, module version =3D 1.2.0
[    35.789] 	ABI class: X.Org Server Extension, version 4.0
[    35.789] (II) Loading extension DRI2
[    35.789] (=3D=3D) Matched ati as autoconfigured driver 0
[    35.789] (=3D=3D) Matched vesa as autoconfigured driver 1
[    35.789] (=3D=3D) Matched fbdev as autoconfigured driver 2
[    35.789] (=3D=3D) Assigned the driver to the xf86ConfigLayout
[    35.789] (II) LoadModule: "ati"
[    35.789] (II) Loading /usr/lib/xorg/modules/drivers/ati_drv.so
[    35.806] (II) Module ati: vendor=3D"X.Org Foundation"
[    35.806] 	compiled for 1.9.4, module version =3D 6.14.0
[    35.806] 	Module class: X.Org Video Driver
[    35.806] 	ABI class: X.Org Video Driver, version 8.0
[    35.806] (II) LoadModule: "radeon"
[    35.807] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[    35.847] (II) Module radeon: vendor=3D"X.Org Foundation"
[    35.847] 	compiled for 1.9.4, module version =3D 6.14.0
[    35.847] 	Module class: X.Org Video Driver
[    35.847] 	ABI class: X.Org Video Driver, version 8.0
[    35.848] (II) LoadModule: "vesa"
[    35.848] (II) Loading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    35.865] (II) Module vesa: vendor=3D"X.Org Foundation"
[    35.865] 	compiled for 1.9.4, module version =3D 2.3.0
[    35.865] 	Module class: X.Org Video Driver
[    35.865] 	ABI class: X.Org Video Driver, version 8.0
[    35.865] (II) LoadModule: "fbdev"
[    35.865] (II) Loading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    35.878] (II) Module fbdev: vendor=3D"X.Org Foundation"
[    35.878] 	compiled for 1.9.4, module version =3D 0.4.2
[    35.878] 	ABI class: X.Org Video Driver, version 8.0
[    35.878] (II) RADEON: Driver for ATI Radeon chipsets:
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
	AMD Radeon HD 6250 Graphics, CYPRESS,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, AMD Firestream 9370,
	AMD Firestream 9350, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5900 Series, ATI Radeon HD 5900 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 5700 Series,
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
	ATI Radeon HD 5450, CEDAR, AMD Radeon HD 6900M Series,
	Mobility Radeon HD 6000 Series, BARTS, BARTS,
	Mobility Radeon HD 6000 Series, Mobility Radeon HD 6000 Series,
	BARTS, BARTS, BARTS, BARTS, AMD Radeon HD 6800 Series,
	AMD Radeon HD 6800 Series, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS,
	TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, CAICOS, CAICOS,
	CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
	CAICOS
[    35.882] (II) VESA: driver for VESA chipsets: vesa
[    35.882] (II) FBDEV: driver for framebuffer: fbdev
[    35.882] (++) using VT number 7

[    35.949] (II) [KMS] Kernel modesetting enabled.
[    35.949] (WW) Falling back to old probe method for vesa
[    35.949] (WW) Falling back to old probe method for fbdev
[    35.949] (II) Loading sub module "fbdevhw"
[    35.949] (II) LoadModule: "fbdevhw"
[    35.949] (II) Loading /usr/lib/xorg/modules/libfbdevhw.so
[    35.950] (II) Module fbdevhw: vendor=3D"X.Org Foundation"
[    35.950] 	compiled for 1.9.4, module version =3D 0.0.2
[    35.950] 	ABI class: X.Org Video Driver, version 8.0
[    35.950] (II) RADEON(0): Creating default Display subsection in Screen =
section
	"Default Screen Section" for depth/fbbpp 24/32
[    35.950] (=3D=3D) RADEON(0): Depth 24, (--) framebuffer bpp 32
[    35.950] (II) RADEON(0): Pixel depth =3D 24 bits stored in 4 bytes (32 =
bpp pixmaps)
[    35.950] (=3D=3D) RADEON(0): Default visual is TrueColor
[    35.950] (=3D=3D) RADEON(0): RGB weight 888
[    35.950] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[    35.950] (--) RADEON(0): Chipset: "ATI Radeon Mobility 9600/9700 (M10/M=
11) NP (AGP)" (ChipID =3D 0x4e50)
[    35.950] (II) RADEON(0): AGP card detected
[    35.950] drmOpenDevice: node name is /dev/dri/card0
[    35.950] drmOpenDevice: open result is 9, (OK)
[    35.950] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[    35.950] drmOpenDevice: node name is /dev/dri/card0
[    35.950] drmOpenDevice: open result is 9, (OK)
[    35.950] drmOpenByBusid: drmOpenMinor returns 9
[    35.950] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[    35.950] (II) RADEON(0): KMS Color Tiling: enabled
[    35.950] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[    35.958] (II) RADEON(0): Output VGA-0 has no monitor section
[    35.962] (II) RADEON(0): Output DVI-0 has no monitor section
[    35.962] (II) RADEON(0): Output LVDS using monitor section Notebook-Dis=
play
[    35.985] (II) RADEON(0): Output S-video has no monitor section
[    35.995] (II) RADEON(0): EDID for output VGA-0
[    36.000] (II) RADEON(0): EDID for output DVI-0
[    36.000] (II) RADEON(0): EDID for output LVDS
[    36.000] (II) RADEON(0): Not using default mode "640x350" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "320x175" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "640x400" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "320x200" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "720x400" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "360x200" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "320x240" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "320x240" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "320x240" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "400x300" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1024x768i" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "512x384i" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "512x384" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "512x384" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "512x384" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1280x960" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "640x480" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1280x1024" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "640x512" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1280x1024" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "640x512" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1600x1200" (hsync out =
of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (hsync out of=
 range)
[    36.001] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1600x1200" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "800x600" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1792x1344" (hsync out =
of range)
[    36.001] (II) RADEON(0): Not using default mode "896x672" (hsync out of=
 range)
[    36.001] (II) RADEON(0): Not using default mode "1792x1344" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "896x672" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1856x1392" (hsync out =
of range)
[    36.001] (II) RADEON(0): Not using default mode "928x696" (hsync out of=
 range)
[    36.001] (II) RADEON(0): Not using default mode "1856x1392" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "928x696" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1920x1440" (hsync out =
of range)
[    36.001] (II) RADEON(0): Not using default mode "960x720" (hsync out of=
 range)
[    36.001] (II) RADEON(0): Not using default mode "1920x1440" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "960x720" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "832x624" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "416x312" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1152x864" (vrefresh ou=
t of range)
[    36.001] (II) RADEON(0): Not using default mode "576x432" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1360x768" (monitor doe=
sn't support reduced blanking)
[    36.001] (II) RADEON(0): Not using default mode "1400x1050" (hsync out =
of range)
[    36.001] (II) RADEON(0): Not using default mode "700x525" (hsync out of=
 range)
[    36.001] (II) RADEON(0): Not using default mode "1400x1050" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "700x525" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1400x1050" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "700x525" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1400x1050" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "700x525" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1680x1050" (hsync out =
of range)
[    36.001] (II) RADEON(0): Not using default mode "840x525" (hsync out of=
 range)
[    36.001] (II) RADEON(0): Not using default mode "1680x1050" (hsync out =
of range)
[    36.001] (II) RADEON(0): Not using default mode "840x525" (hsync out of=
 range)
[    36.001] (II) RADEON(0): Not using default mode "1680x1050" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "840x525" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1680x1050" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "840x525" (vrefresh out=
 of range)
[    36.001] (II) RADEON(0): Not using default mode "1680x1050" (vrefresh o=
ut of range)
[    36.001] (II) RADEON(0): Not using default mode "840x525" (vrefresh out=
 of range)
[    36.002] (II) RADEON(0): Not using default mode "1920x1080" (hsync out =
of range)
[    36.002] (II) RADEON(0): Not using default mode "960x540" (hsync out of=
 range)
[    36.002] (II) RADEON(0): Not using default mode "1920x1200" (hsync out =
of range)
[    36.002] (II) RADEON(0): Not using default mode "960x600" (hsync out of=
 range)
[    36.002] (II) RADEON(0): Not using default mode "1920x1440" (vrefresh o=
ut of range)
[    36.002] (II) RADEON(0): Not using default mode "960x720" (vrefresh out=
 of range)
[    36.002] (II) RADEON(0): Not using default mode "2048x1536" (hsync out =
of range)
[    36.002] (II) RADEON(0): Not using default mode "1024x768" (hsync out o=
f range)
[    36.002] (II) RADEON(0): Not using default mode "2048x1536" (vrefresh o=
ut of range)
[    36.002] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    36.002] (II) RADEON(0): Not using default mode "2048x1536" (vrefresh o=
ut of range)
[    36.002] (II) RADEON(0): Not using default mode "1024x768" (vrefresh ou=
t of range)
[    36.002] (II) RADEON(0): Printing probed modes for output LVDS
[    36.002] (II) RADEON(0): Modeline "1400x1050"x60.2  108.00  1400 34208 =
34320 1688  1050 1052 1055 1063 (64.0 kHz)
[    36.002] (II) RADEON(0): Modeline "1600x1024"x60.2  103.12  1600 1600 1=
656 1664  1024 1024 1029 1030 +hsync +vsync (62.0 kHz)
[    36.002] (II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1=
496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
[    36.002] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1=
440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    36.002] (II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1520 16=
72 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    36.002] (II) RADEON(0): Modeline "1280x960"x60.0  108.00  1280 1376 14=
88 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    36.002] (II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 14=
88 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
[    36.002] (II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 14=
80 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
[    36.002] (II) RADEON(0): Modeline "1360x768"x59.8   84.75  1360 1432 15=
68 1776  768 771 781 798 -hsync +vsync (47.7 kHz)
[    36.002] (II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 14=
80 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
[    36.002] (II) RADEON(0): Modeline "1152x864"x60.0   81.62  1152 1216 13=
36 1520  864 865 868 895 -hsync +vsync (53.7 kHz)
[    36.002] (II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 14=
72 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
[    36.002] (II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 13=
28 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
[    36.002] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048 11=
84 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    36.002] (II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 11=
76 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
[    36.002] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840 968 1=
056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    36.002] (II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1=
024  600 603 607 624 -hsync +vsync (37.4 kHz)
[    36.002] (II) RADEON(0): Modeline "800x512"x60.2   51.56  800 800 828 8=
32  512 512 514 515 doublescan +hsync +vsync (62.0 kHz)
[    36.002] (II) RADEON(0): Modeline "848x480"x59.7   31.50  848 872 952 1=
056  480 483 493 500 -hsync +vsync (29.8 kHz)
[    36.002] (II) RADEON(0): Modeline "720x480"x59.7   26.75  720 744 808 8=
96  480 483 493 500 -hsync +vsync (29.9 kHz)
[    36.002] (II) RADEON(0): Modeline "640x512"x60.0   54.00  640 664 720 8=
44  512 512 514 533 doublescan +hsync +vsync (64.0 kHz)
[    36.002] (II) RADEON(0): Modeline "720x450"x59.9   53.25  720 760 836 9=
52  450 451 454 467 doublescan -hsync +vsync (55.9 kHz)
[    36.002] (II) RADEON(0): Modeline "640x480"x60.0   54.00  640 688 744 9=
00  480 480 482 500 doublescan +hsync +vsync (60.0 kHz)
[    36.002] (II) RADEON(0): Modeline "640x480"x59.9   25.18  640 656 752 8=
00  480 490 492 525 -hsync -vsync (31.5 kHz)
[    36.002] (II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 8=
00  480 483 487 500 -hsync +vsync (29.7 kHz)
[    36.002] (II) RADEON(0): Modeline "680x384"x59.8   42.38  680 716 784 8=
88  384 385 390 399 doublescan -hsync +vsync (47.7 kHz)
[    36.002] (II) RADEON(0): Modeline "680x384"x60.0   36.00  680 704 720 7=
60  384 385 390 395 doublescan +hsync -vsync (47.4 kHz)
[    36.002] (II) RADEON(0): Modeline "576x432"x60.1   40.81  576 608 668 7=
60  432 432 434 447 doublescan -hsync +vsync (53.7 kHz)
[    36.002] (II) RADEON(0): Modeline "512x384"x60.0   32.50  512 524 592 6=
72  384 385 388 403 doublescan -hsync -vsync (48.4 kHz)
[    36.002] (II) RADEON(0): Modeline "400x300"x60.3   20.00  400 420 484 5=
28  300 300 302 314 doublescan +hsync +vsync (37.9 kHz)
[    36.002] (II) RADEON(0): Modeline "320x240"x60.1   12.59  320 328 376 4=
00  240 245 246 262 doublescan -hsync -vsync (31.5 kHz)
[    36.024] (II) RADEON(0): EDID for output S-video
[    36.024] (II) RADEON(0): Output VGA-0 disconnected
[    36.024] (II) RADEON(0): Output DVI-0 disconnected
[    36.024] (II) RADEON(0): Output LVDS connected
[    36.024] (II) RADEON(0): Output S-video disconnected
[    36.024] (II) RADEON(0): Using exact sizes for initial modes
[    36.024] (II) RADEON(0): Output LVDS using initial mode 1400x1050
[    36.024] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless =
otherwise stated.
[    36.024] (II) RADEON(0): Output LVDS wants gamma correction (1.2, 1.2, =
1.2)
[    36.024] (II) RADEON(0): mem size init: gart size :fdff000 vram size: s=
:4000000 visible:3a1c000
[    36.024] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[    36.024] (=3D=3D) RADEON(0): DPI set to (96, 96)
[    36.024] (II) Loading sub module "fb"
[    36.024] (II) LoadModule: "fb"
[    36.060] (II) Loading /usr/lib/xorg/modules/libfb.so
[    36.079] (II) Module fb: vendor=3D"X.Org Foundation"
[    36.079] 	compiled for 1.9.4, module version =3D 1.0.0
[    36.079] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    36.079] (II) Loading sub module "ramdac"
[    36.079] (II) LoadModule: "ramdac"
[    36.079] (II) Module "ramdac" already built-in
[    36.079] (II) Loading sub module "exa"
[    36.079] (II) LoadModule: "exa"
[    36.080] (II) Loading /usr/lib/xorg/modules/libexa.so
[    36.087] (II) Module exa: vendor=3D"X.Org Foundation"
[    36.087] 	compiled for 1.9.4, module version =3D 2.5.0
[    36.087] 	ABI class: X.Org Video Driver, version 8.0
[    36.087] (II) UnloadModule: "vesa"
[    36.087] (II) Unloading /usr/lib/xorg/modules/drivers/vesa_drv.so
[    36.087] (II) UnloadModule: "fbdev"
[    36.087] (II) Unloading /usr/lib/xorg/modules/drivers/fbdev_drv.so
[    36.087] (II) UnloadModule: "fbdevhw"
[    36.087] (II) Unloading /usr/lib/xorg/modules/libfbdevhw.so
[    36.087] (--) Depth 24 pixmap format is 32 bpp
[    36.087] (II) RADEON(0): [DRI2] Setup complete
[    36.087] (II) RADEON(0): [DRI2]   DRI driver: r300
[    36.088] (II) RADEON(0): Front buffer size: 5808K
[    36.088] (II) RADEON(0): VRAM usage limit set to 48326K
[    36.110] (=3D=3D) RADEON(0): Backing store disabled
[    36.110] (II) RADEON(0): Direct rendering enabled
[    36.131] (II) RADEON(0): Render acceleration enabled for R300/R400/R500=
 type cards.
[    36.131] (II) RADEON(0): Setting EXA maxPitchBytes
[    36.131] (II) EXA(0): Driver allocated offscreen pixmaps
[    36.131] (II) EXA(0): Driver registered support for the following opera=
tions:
[    36.131] (II)         Solid
[    36.131] (II)         Copy
[    36.131] (II)         Composite (RENDER acceleration)
[    36.131] (II)         UploadToScreen
[    36.131] (II)         DownloadFromScreen
[    36.131] (II) RADEON(0): Acceleration enabled
[    36.131] (=3D=3D) RADEON(0): DPMS enabled
[    36.131] (=3D=3D) RADEON(0): Silken mouse enabled
[    36.162] (II) RADEON(0): Set up textured video
[    36.162] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR =
disabled message.
[    36.162] (--) RandR disabled
[    36.162] (II) Initializing built-in extension Generic Event Extension
[    36.162] (II) Initializing built-in extension SHAPE
[    36.162] (II) Initializing built-in extension MIT-SHM
[    36.162] (II) Initializing built-in extension XInputExtension
[    36.162] (II) Initializing built-in extension XTEST
[    36.162] (II) Initializing built-in extension BIG-REQUESTS
[    36.162] (II) Initializing built-in extension SYNC
[    36.162] (II) Initializing built-in extension XKEYBOARD
[    36.162] (II) Initializing built-in extension XC-MISC
[    36.162] (II) Initializing built-in extension XINERAMA
[    36.162] (II) Initializing built-in extension XFIXES
[    36.162] (II) Initializing built-in extension RENDER
[    36.162] (II) Initializing built-in extension RANDR
[    36.162] (II) Initializing built-in extension COMPOSITE
[    36.162] (II) Initializing built-in extension DAMAGE
[    36.163] (II) SELinux: Disabled on system
[    36.396] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    36.396] (II) AIGLX: enabled GLX_INTEL_swap_event
[    36.396] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_con=
trol
[    36.396] (II) AIGLX: enabled GLX_SGI_make_current_read
[    36.396] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objec=
ts
[    36.396] (II) AIGLX: Loaded and initialized /usr/lib/dri/r300_dri.so
[    36.396] (II) GLX: Initialized DRI2 GL provider for screen 0
[    36.409] (II) RADEON(0): Setting screen physical size to 306 x 230
[    37.714] (II) config/udev: Adding input device Power Button (/dev/input=
/event6)
[    37.714] (**) Power Button: Applying InputClass "evdev keyboard catchal=
l"
[    37.714] (II) LoadModule: "evdev"
[    37.714] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    37.729] (II) Module evdev: vendor=3D"X.Org Foundation"
[    37.729] 	compiled for 1.9.4, module version =3D 2.6.0
[    37.729] 	Module class: X.Org XInput Driver
[    37.729] 	ABI class: X.Org XInput driver, version 11.0
[    37.729] (**) Power Button: always reports core events
[    37.729] (**) Power Button: Device: "/dev/input/event6"
[    37.729] (--) Power Button: Found keys
[    37.729] (II) Power Button: Configuring as keyboard
[    37.729] (II) XINPUT: Adding extended input device "Power Button" (type=
: KEYBOARD)
[    37.729] (**) Option "xkb_rules" "evdev"
[    37.729] (**) Option "xkb_model" "pc105"
[    37.730] (**) Option "xkb_layout" "de"
[    37.730] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    37.914] (II) config/udev: Adding input device Video Bus (/dev/input/ev=
ent7)
[    37.914] (**) Video Bus: Applying InputClass "evdev keyboard catchall"
[    37.914] (**) Video Bus: always reports core events
[    37.914] (**) Video Bus: Device: "/dev/input/event7"
[    37.914] (--) Video Bus: Found keys
[    37.914] (II) Video Bus: Configuring as keyboard
[    37.914] (II) XINPUT: Adding extended input device "Video Bus" (type: K=
EYBOARD)
[    37.914] (**) Option "xkb_rules" "evdev"
[    37.914] (**) Option "xkb_model" "pc105"
[    37.914] (**) Option "xkb_layout" "de"
[    37.914] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    37.915] (II) config/udev: Adding input device Lid Switch (/dev/input/e=
vent4)
[    37.915] (II) No input driver/identifier specified (ignoring)
[    37.916] (II) config/udev: Adding input device Sleep Button (/dev/input=
/event5)
[    37.916] (**) Sleep Button: Applying InputClass "evdev keyboard catchal=
l"
[    37.916] (**) Sleep Button: always reports core events
[    37.916] (**) Sleep Button: Device: "/dev/input/event5"
[    37.916] (--) Sleep Button: Found keys
[    37.916] (II) Sleep Button: Configuring as keyboard
[    37.916] (II) XINPUT: Adding extended input device "Sleep Button" (type=
: KEYBOARD)
[    37.916] (**) Option "xkb_rules" "evdev"
[    37.916] (**) Option "xkb_model" "pc105"
[    37.916] (**) Option "xkb_layout" "de"
[    37.916] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    37.924] (II) config/udev: Adding input device AT Translated Set 2 keyb=
oard (/dev/input/event1)
[    37.924] (**) AT Translated Set 2 keyboard: Applying InputClass "evdev =
keyboard catchall"
[    37.924] (**) AT Translated Set 2 keyboard: always reports core events
[    37.924] (**) AT Translated Set 2 keyboard: Device: "/dev/input/event1"
[    37.924] (--) AT Translated Set 2 keyboard: Found keys
[    37.924] (II) AT Translated Set 2 keyboard: Configuring as keyboard
[    37.924] (II) XINPUT: Adding extended input device "AT Translated Set 2=
 keyboard" (type: KEYBOARD)
[    37.924] (**) Option "xkb_rules" "evdev"
[    37.924] (**) Option "xkb_model" "pc105"
[    37.924] (**) Option "xkb_layout" "de"
[    37.924] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    37.925] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/event2)
[    37.925] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "evdev to=
uchpad catchall"
[    37.925] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[    37.925] (II) LoadModule: "synaptics"
[    37.925] (II) Loading /usr/lib/xorg/modules/input/synaptics_drv.so
[    37.961] (II) Module synaptics: vendor=3D"X.Org Foundation"
[    37.961] 	compiled for 1.9.4, module version =3D 1.4.0
[    37.961] 	Module class: X.Org XInput Driver
[    37.961] 	ABI class: X.Org XInput driver, version 11.0
[    37.961] (**) Option "Device" "/dev/input/event2"
[    37.961] (--) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5472
[    37.961] (--) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4448
[    37.961] (--) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
[    37.961] (--) SynPS/2 Synaptics TouchPad: finger width range 0 - 15
[    37.961] (--) SynPS/2 Synaptics TouchPad: buttons: left right double tr=
iple
[    37.961] (--) SynPS/2 Synaptics TouchPad: touchpad found
[    37.961] (**) SynPS/2 Synaptics TouchPad: always reports core events
[    37.961] (II) XINPUT: Adding extended input device "SynPS/2 Synaptics T=
ouchPad" (type: TOUCHPAD)
[    37.961] (**) SynPS/2 Synaptics TouchPad: (accel) MinSpeed is now const=
ant deceleration 2.5
[    37.961] (**) SynPS/2 Synaptics TouchPad: MaxSpeed is now 1.75
[    37.961] (**) SynPS/2 Synaptics TouchPad: AccelFactor is now 0.040
[    37.961] (**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration =
scheme 1
[    37.961] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration profile 1
[    37.961] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration factor: =
2.000
[    37.961] (**) SynPS/2 Synaptics TouchPad: (accel) acceleration threshol=
d: 4
[    37.961] (--) SynPS/2 Synaptics TouchPad: touchpad found
[    37.962] (II) config/udev: Adding input device SynPS/2 Synaptics TouchP=
ad (/dev/input/mouse0)
[    37.962] (**) SynPS/2 Synaptics TouchPad: Applying InputClass "touchpad=
 catchall"
[    37.962] (**) Option "Device" "/dev/input/mouse0"
[    37.962] (--) SynPS/2 Synaptics TouchPad: invalid x-axis range.  defaul=
ting to 1615 - 5685
[    37.962] (--) SynPS/2 Synaptics TouchPad: invalid y-axis range.  defaul=
ting to 1729 - 4171
[    37.962] (--) SynPS/2 Synaptics TouchPad: invalid pressure range.  defa=
ulting to 0 - 256
[    37.962] (--) SynPS/2 Synaptics TouchPad: invalid finger width range.  =
defaulting to 0 - 16
[    37.982] (EE) Query no Synaptics: 6003C8
[    37.982] (--) SynPS/2 Synaptics TouchPad: no supported touchpad found
[    37.982] (EE) SynPS/2 Synaptics TouchPad Unable to query/initialize Syn=
aptics hardware.
[    37.982] (EE) PreInit returned NULL for "SynPS/2 Synaptics TouchPad"
[    37.982] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/event3)
[    37.982] (**) TPPS/2 IBM TrackPoint: Applying InputClass "evdev pointer=
 catchall"
[    37.982] (**) TPPS/2 IBM TrackPoint: always reports core events
[    37.982] (**) TPPS/2 IBM TrackPoint: Device: "/dev/input/event3"
[    37.982] (--) TPPS/2 IBM TrackPoint: Found 3 mouse buttons
[    37.982] (--) TPPS/2 IBM TrackPoint: Found relative axes
[    37.982] (--) TPPS/2 IBM TrackPoint: Found x and y relative axes
[    37.982] (II) TPPS/2 IBM TrackPoint: Configuring as mouse
[    37.982] (**) TPPS/2 IBM TrackPoint: YAxisMapping: buttons 4 and 5
[    37.982] (**) TPPS/2 IBM TrackPoint: EmulateWheelButton: 4, EmulateWhee=
lInertia: 10, EmulateWheelTimeout: 200
[    37.982] (II) XINPUT: Adding extended input device "TPPS/2 IBM TrackPoi=
nt" (type: MOUSE)
[    37.982] (**) TPPS/2 IBM TrackPoint: (accel) keeping acceleration schem=
e 1
[    37.982] (**) TPPS/2 IBM TrackPoint: (accel) acceleration profile 0
[    37.983] (**) TPPS/2 IBM TrackPoint: (accel) acceleration factor: 2.000
[    37.983] (**) TPPS/2 IBM TrackPoint: (accel) acceleration threshold: 4
[    37.983] (II) TPPS/2 IBM TrackPoint: initialized for relative axes.
[    37.983] (II) config/udev: Adding input device TPPS/2 IBM TrackPoint (/=
dev/input/mouse1)
[    37.983] (II) No input driver/identifier specified (ignoring)
[    37.983] (II) config/udev: Adding input device PC Speaker (/dev/input/e=
vent0)
[    37.983] (II) No input driver/identifier specified (ignoring)
[    37.984] (II) config/udev: Adding input device ThinkPad Extra Buttons (=
/dev/input/event8)
[    37.984] (**) ThinkPad Extra Buttons: Applying InputClass "evdev keyboa=
rd catchall"
[    37.984] (**) ThinkPad Extra Buttons: always reports core events
[    37.984] (**) ThinkPad Extra Buttons: Device: "/dev/input/event8"
[    37.984] (--) ThinkPad Extra Buttons: Found keys
[    37.984] (II) ThinkPad Extra Buttons: Configuring as keyboard
[    37.984] (II) XINPUT: Adding extended input device "ThinkPad Extra Butt=
ons" (type: KEYBOARD)
[    37.984] (**) Option "xkb_rules" "evdev"
[    37.984] (**) Option "xkb_model" "pc105"
[    37.984] (**) Option "xkb_layout" "de"
[    37.984] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    37.987] (II) config/udev: Adding input device ThinkPad HDAPS accelerom=
eter data (/dev/input/event10)
[    37.987] (II) No input driver/identifier specified (ignoring)
[    37.988] (II) config/udev: Adding input device ThinkPad HDAPS accelerom=
eter data (/dev/input/js1)
[    37.988] (II) No input driver/identifier specified (ignoring)
[    37.988] (II) config/udev: Adding input device ACPI Virtual Keyboard De=
vice (/dev/input/event11)
[    37.988] (**) ACPI Virtual Keyboard Device: Applying InputClass "evdev =
keyboard catchall"
[    37.988] (**) ACPI Virtual Keyboard Device: always reports core events
[    37.988] (**) ACPI Virtual Keyboard Device: Device: "/dev/input/event11"
[    37.988] (--) ACPI Virtual Keyboard Device: Found keys
[    37.988] (II) ACPI Virtual Keyboard Device: Configuring as keyboard
[    37.988] (II) XINPUT: Adding extended input device "ACPI Virtual Keyboa=
rd Device" (type: KEYBOARD)
[    37.988] (**) Option "xkb_rules" "evdev"
[    37.988] (**) Option "xkb_model" "pc105"
[    37.988] (**) Option "xkb_layout" "de"
[    37.988] (**) Option "xkb_options" "lv3:ralt_switch,terminate:ctrl_alt_=
bksp"
[    37.989] (II) config/udev: Adding input device ThinkPad HDAPS joystick =
emulation (/dev/input/event9)
[    37.989] (II) No input driver/identifier specified (ignoring)
[    37.989] (II) config/udev: Adding input device ThinkPad HDAPS joystick =
emulation (/dev/input/js0)
[    37.989] (II) No input driver/identifier specified (ignoring)

--Boundary-01=_WhfdNHASEG5wotN--

--nextPart8966602.QD4hpjIMDz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk11+FYACgkQmRvqrKWZhMdbswCaAwR5yeOC7/zrUCTpUuHndnGp
mlgAnA9TZhl9LWKICfWDjIJoOtwVlmuG
=U8FU
-----END PGP SIGNATURE-----

--nextPart8966602.QD4hpjIMDz--
