Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1DLMBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:01:33 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:52057 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1DLMBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:01:03 -0400
Date: Tue, 12 Apr 2011 14:00:56 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110412120055.GA7995@iram.es>
References: <20110404235259.GA30132@iram.es> <20110406084101.GB13963@pengutronix.de> <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com> <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local> <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local> <20110412113033.GA16649@iram.es> <1302608770.27054.36.camel@thor.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302608770.27054.36.camel@thor.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Apr 12, 2011 at 01:46:10PM +0200, Michel Dänzer wrote:
> > 
> > With no_wb=1 the driver goes a bit further but the X server ends
> > up in an infinite ioctl loop and the logs are: 
> 
> Which ioctl does it loop on? Please provide the Xorg.0.log file as well.

>From memory, the code was 0x64, which is DRM_RADEON_GEM_WAIT_IDLE.

The Xorg.0.log from the previous boot is attached.

	Gabriel

--BOKacYhQ+x31HxR3
Content-Type: application/x-trash
Content-Disposition: attachment; filename="Xorg.0.log.old"
Content-Transfer-Encoding: quoted-printable

=0AX.Org X Server 1.7.7=0ARelease Date: 2010-05-04=0AX Protocol Version 11,=
 Revision 0=0ABuild Operating System: Linux 2.6.26-2-powerpc64 ppc Debian=
=0ACurrent Operating System: Linux gra-vd1 2.6.38 #27 SMP Tue Apr 12 10:22:=
50 CEST 2011 ppc64=0AKernel command line: ro root=3D/dev/md0 =0ABuild Date:=
 19 February 2011  02:44:42PM=0Axorg-server 2:1.7.7-13 (Cyril Brulebois <ki=
bi@debian.org>) =0ACurrent version of pixman: 0.16.4=0A	Before reporting pr=
oblems, check http://wiki.x.org=0A	to make sure that you have the latest ve=
rsion.=0AMarkers: (--) probed, (**) from config file, (=3D=3D) default sett=
ing,=0A	(++) from command line, (!!) notice, (II) informational,=0A	(WW) wa=
rning, (EE) error, (NI) not implemented, (??) unknown.=0A(=3D=3D) Log file:=
 "/var/log/Xorg.0.log", Time: Tue Apr 12 10:59:25 2011=0A(=3D=3D) Using con=
fig file: "/etc/X11/xorg.conf"=0A(=3D=3D) Using system config directory "/u=
sr/share/X11/xorg.conf.d"=0A(=3D=3D) No Layout section.  Using the first Sc=
reen section.=0A(**) |-->Screen "Default Screen" (0)=0A(**) |   |-->Monitor=
 "Configured Monitor"=0A(=3D=3D) No device specified for screen "Default Sc=
reen".=0A	Using the first device section listed.=0A(**) |   |-->Device "Con=
figured Video Device"=0A(=3D=3D) Automatically adding devices=0A(=3D=3D) Au=
tomatically enabling devices=0A(WW) The directory "/usr/share/fonts/X11/cyr=
illic" does not exist.=0A	Entry deleted from font path.=0A(=3D=3D) FontPath=
 set to:=0A	/usr/share/fonts/X11/misc,=0A	/usr/share/fonts/X11/100dpi/:unsc=
aled,=0A	/usr/share/fonts/X11/75dpi/:unscaled,=0A	/usr/share/fonts/X11/Type=
1,=0A	/usr/share/fonts/X11/100dpi,=0A	/usr/share/fonts/X11/75dpi,=0A	/var/l=
ib/defoma/x-ttcidfont-conf.d/dirs/TrueType,=0A	built-ins=0A(=3D=3D) ModuleP=
ath set to "/usr/lib/xorg/modules"=0A(II) The server relies on udev to prov=
ide the list of input devices.=0A	If no devices become available, reconfigu=
re udev or disable AutoAddDevices.=0A(II) Loader magic: 0x101e90ec=0A(II) M=
odule ABI versions:=0A	X.Org ANSI C Emulation: 0.4=0A	X.Org Video Driver: 6=
=2E0=0A	X.Org XInput driver : 7.0=0A	X.Org Server Extension : 2.0=0A(++) us=
ing VT number 7=0A=0A(--) PCI:*(0:241:0:0) 1002:71c7:174b:0840 ATI Technolo=
gies Inc RV535 [Radeon X1650 Series] rev 158, Mem @ 0xc0000000/268435456, 0=
xe8000000/65536, I/O @ 0x0000f000/256, BIOS @ 0x????????/131072=0A(--) PCI:=
 (0:241:0:1) 1002:71e7:174b:0841 ATI Technologies Inc RV535 [Radeon X1650 S=
eries] rev 158, Mem @ 0xe8040000/65536=0A(II) LoadModule: "extmod"=0A(II) L=
oading /usr/lib/xorg/modules/extensions/libextmod.so=0A(II) Module extmod: =
vendor=3D"X.Org Foundation"=0A	compiled for 1.7.7, module version =3D 1.0.0=
=0A	Module class: X.Org Server Extension=0A	ABI class: X.Org Server Extensi=
on, version 2.0=0A(II) Loading extension SELinux=0A(II) Loading extension M=
IT-SCREEN-SAVER=0A(II) Loading extension XFree86-VidModeExtension=0A(II) Lo=
ading extension XFree86-DGA=0A(II) Loading extension DPMS=0A(II) Loading ex=
tension XVideo=0A(II) Loading extension XVideo-MotionCompensation=0A(II) Lo=
ading extension X-Resource=0A(II) LoadModule: "dbe"=0A(II) Loading /usr/lib=
/xorg/modules/extensions/libdbe.so=0A(II) Module dbe: vendor=3D"X.Org Found=
ation"=0A	compiled for 1.7.7, module version =3D 1.0.0=0A	Module class: X.O=
rg Server Extension=0A	ABI class: X.Org Server Extension, version 2.0=0A(II=
) Loading extension DOUBLE-BUFFER=0A(II) LoadModule: "glx"=0A(II) Loading /=
usr/lib/xorg/modules/extensions/libglx.so=0A(II) Module glx: vendor=3D"X.Or=
g Foundation"=0A	compiled for 1.7.7, module version =3D 1.0.0=0A	ABI class:=
 X.Org Server Extension, version 2.0=0A(=3D=3D) AIGLX enabled=0A(II) Loadin=
g extension GLX=0A(II) LoadModule: "record"=0A(II) Loading /usr/lib/xorg/mo=
dules/extensions/librecord.so=0A(II) Module record: vendor=3D"X.Org Foundat=
ion"=0A	compiled for 1.7.7, module version =3D 1.13.0=0A	Module class: X.Or=
g Server Extension=0A	ABI class: X.Org Server Extension, version 2.0=0A(II)=
 Loading extension RECORD=0A(II) LoadModule: "dri"=0A(II) Loading /usr/lib/=
xorg/modules/extensions/libdri.so=0A(II) Module dri: vendor=3D"X.Org Founda=
tion"=0A	compiled for 1.7.7, module version =3D 1.0.0=0A	ABI class: X.Org S=
erver Extension, version 2.0=0A(II) Loading extension XFree86-DRI=0A(II) Lo=
adModule: "dri2"=0A(II) Loading /usr/lib/xorg/modules/extensions/libdri2.so=
=0A(II) Module dri2: vendor=3D"X.Org Foundation"=0A	compiled for 1.7.7, mod=
ule version =3D 1.1.0=0A	ABI class: X.Org Server Extension, version 2.0=0A(=
II) Loading extension DRI2=0A(=3D=3D) Matched ati as autoconfigured driver =
0=0A(=3D=3D) Matched fbdev as autoconfigured driver 1=0A(=3D=3D) Assigned t=
he driver to the xf86ConfigLayout=0A(II) LoadModule: "ati"=0A(II) Loading /=
usr/lib/xorg/modules/drivers/ati_drv.so=0A(II) Module ati: vendor=3D"X.Org =
Foundation"=0A	compiled for 1.7.7, module version =3D 6.13.1=0A	Module clas=
s: X.Org Video Driver=0A	ABI class: X.Org Video Driver, version 6.0=0A(II) =
LoadModule: "radeon"=0A(II) Loading /usr/lib/xorg/modules/drivers/radeon_dr=
v.so=0A(II) Module radeon: vendor=3D"X.Org Foundation"=0A	compiled for 1.7.=
7, module version =3D 6.13.1=0A	Module class: X.Org Video Driver=0A	ABI cla=
ss: X.Org Video Driver, version 6.0=0A(II) LoadModule: "fbdev"=0A(II) Loadi=
ng /usr/lib/xorg/modules/drivers/fbdev_drv.so=0A(II) Module fbdev: vendor=
=3D"X.Org Foundation"=0A	compiled for 1.7.6.901, module version =3D 0.4.2=
=0A	ABI class: X.Org Video Driver, version 6.0=0A(II) RADEON: Driver for AT=
I Radeon chipsets:=0A	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireM=
V 2400 (PCI),=0A	ATI Radeon Mobility X300 (M24) 3152 (PCIE),=0A	ATI FireGL =
M24 GL 3154 (PCIE), ATI FireMV 2400 3155 (PCI),=0A	ATI Radeon X600 (RV380) =
3E50 (PCIE),=0A	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3=
) 4136,=0A	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),=
=0A	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),=0A	ATI FireGL Z1 =
AG (AGP), ATI Radeon 9800SE AH (AGP),=0A	ATI Radeon 9800 AI (AGP), ATI Rade=
on 9800 AJ (AGP),=0A	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),=0A	A=
TI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),=0A	ATI Radeon 9600 A=
S (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,=0A	ATI FireGL RV360 AV (A=
GP), ATI Radeon 7000 IGP (A4+) 4237,=0A	ATI Radeon 8500 AIW BB (AGP), ATI R=
adeon 8500 AIW BC (AGP),=0A	ATI Radeon IGP320M (U1) 4336, ATI Radeon IGP330=
M/340M/350M (U2) 4337,=0A	ATI Radeon Mobility 7000 IGP 4437, ATI Radeon 900=
0/PRO If (AGP/PCI),=0A	ATI Radeon 9000 Ig (AGP/PCI), ATI Radeon X800 (R420)=
 JH (AGP),=0A	ATI Radeon X800PRO (R420) JI (AGP),=0A	ATI Radeon X800SE (R42=
0) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),=0A	ATI Radeon X800 (R420) JL =
(AGP), ATI FireGL X3 (R420) JM (AGP),=0A	ATI Radeon Mobility 9800 (M18) JN =
(AGP),=0A	ATI Radeon X800 SE (R420) (AGP), ATI Radeon X800XT (R420) JP (AGP=
),=0A	ATI Radeon X800 VE (R420) JT (AGP), ATI Radeon X850 (R480) (AGP),=0A	=
ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),=0A	ATI Ra=
deon X850 PRO (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP),=0A	ATI Rade=
on Mobility M7 LW (AGP),=0A	ATI Mobility FireGL 7800 M7 LX (AGP),=0A	ATI Ra=
deon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),=0A	ATI FireGL M=
obility 9000 (M9) Ld (AGP),=0A	ATI Radeon Mobility 9000 (M9) Lf (AGP),=0A	A=
TI Radeon Mobility 9000 (M9) Lg (AGP), ATI Radeon 9700 Pro ND (AGP),=0A	ATI=
 Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),=0A	ATI FireGL X1=
 NG (AGP), ATI Radeon 9800PRO NH (AGP),=0A	ATI Radeon 9800 NI (AGP), ATI Fi=
reGL X2 NK (AGP),=0A	ATI Radeon 9800XT NJ (AGP),=0A	ATI Radeon Mobility 960=
0/9700 (M10/M11) NP (AGP),=0A	ATI Radeon Mobility 9600 (M10) NQ (AGP),=0A	A=
TI Radeon Mobility 9600 (M11) NR (AGP),=0A	ATI Radeon Mobility 9600 (M10) N=
S (AGP),=0A	ATI FireGL Mobility T2 (M10) NT (AGP),=0A	ATI FireGL Mobility T=
2e (M11) NV (AGP), ATI Radeon QD (AGP),=0A	ATI Radeon QE (AGP), ATI Radeon =
QF (AGP), ATI Radeon QG (AGP),=0A	ATI FireGL 8700/8800 QH (AGP), ATI Radeon=
 8500 QL (AGP),=0A	ATI Radeon 9100 QM (AGP), ATI Radeon 7500 QW (AGP/PCI),=
=0A	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon VE/7000 QY (AGP/PCI),=0A	ATI R=
adeon VE/7000 QZ (AGP/PCI), ATI ES1000 515E (PCI),=0A	ATI Radeon Mobility X=
300 (M22) 5460 (PCIE),=0A	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),=
=0A	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon X800 (R423) UH (PCIE),=0A	ATI=
 Radeon X800PRO (R423) UI (PCIE),=0A	ATI Radeon X800LE (R423) UJ (PCIE),=0A=
	ATI Radeon X800SE (R423) UK (PCIE),=0A	ATI Radeon X800 XTP (R430) (PCIE), =
ATI Radeon X800 XL (R430) (PCIE),=0A	ATI Radeon X800 SE (R430) (PCIE), ATI =
Radeon X800 (R430) (PCIE),=0A	ATI FireGL V7100 (R423) (PCIE), ATI FireGL V5=
100 (R423) UQ (PCIE),=0A	ATI FireGL unknown (R423) UR (PCIE),=0A	ATI FireGL=
 unknown (R423) UT (PCIE),=0A	ATI Mobility FireGL V5000 (M26) (PCIE),=0A	AT=
I Mobility FireGL V5000 (M26) (PCIE),=0A	ATI Mobility Radeon X700 XL (M26) =
(PCIE),=0A	ATI Mobility Radeon X700 (M26) (PCIE),=0A	ATI Mobility Radeon X7=
00 (M26) (PCIE),=0A	ATI Radeon X550XTX 5657 (PCIE), ATI Radeon 9100 IGP (A5=
) 5834,=0A	ATI Radeon Mobility 9100 IGP (U3) 5835,=0A	ATI Radeon XPRESS 200=
 5954 (PCIE),=0A	ATI Radeon XPRESS 200M 5955 (PCIE), ATI Radeon 9250 5960 (=
AGP),=0A	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),=0A	ATI Rad=
eon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),=0A	ATI ES1000 5969 (PCI), ATI=
 Radeon XPRESS 200 5974 (PCIE),=0A	ATI Radeon XPRESS 200M 5975 (PCIE),=0A	A=
TI Radeon XPRESS 200 5A41 (PCIE),=0A	ATI Radeon XPRESS 200M 5A42 (PCIE),=0A=
	ATI Radeon XPRESS 200 5A61 (PCIE),=0A	ATI Radeon XPRESS 200M 5A62 (PCIE),=
=0A	ATI Radeon X300 (RV370) 5B60 (PCIE),=0A	ATI Radeon X600 (RV370) 5B62 (P=
CIE),=0A	ATI Radeon X550 (RV370) 5B63 (PCIE),=0A	ATI FireGL V3100 (RV370) 5=
B64 (PCIE),=0A	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),=0A	ATI Radeon Mobi=
lity 9200 (M9+) 5C61 (AGP),=0A	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP),=
=0A	ATI Mobility Radeon X800 XT (M28) (PCIE),=0A	ATI Mobility FireGL V5100 =
(M28) (PCIE),=0A	ATI Mobility Radeon X800 (M28) (PCIE), ATI Radeon X850 5D4=
C (PCIE),=0A	ATI Radeon X850 XT PE (R480) (PCIE),=0A	ATI Radeon X850 SE (R4=
80) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),=0A	ATI unknown Radeon / Fire=
GL (R480) 5D50 (PCIE),=0A	ATI Radeon X850 XT (R480) (PCIE),=0A	ATI Radeon X=
800XT (R423) 5D57 (PCIE),=0A	ATI FireGL V5000 (RV410) (PCIE), ATI Radeon X7=
00 XT (RV410) (PCIE),=0A	ATI Radeon X700 PRO (RV410) (PCIE),=0A	ATI Radeon =
X700 SE (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),=0A	ATI Radeon X700 =
SE (RV410) (PCIE), ATI Radeon X1800,=0A	ATI Mobility Radeon X1800 XT, ATI M=
obility Radeon X1800,=0A	ATI Mobility FireGL V7200, ATI FireGL V7200, ATI F=
ireGL V5300,=0A	ATI Mobility FireGL V7100, ATI Radeon X1800, ATI Radeon X18=
00,=0A	ATI Radeon X1800, ATI Radeon X1800, ATI Radeon X1800,=0A	ATI FireGL =
V7300, ATI FireGL V7350, ATI Radeon X1600, ATI RV505,=0A	ATI Radeon X1300/X=
1550, ATI Radeon X1550, ATI M54-GL,=0A	ATI Mobility Radeon X1400, ATI Radeo=
n X1300/X1550,=0A	ATI Radeon X1550 64-bit, ATI Mobility Radeon X1300,=0A	AT=
I Mobility Radeon X1300, ATI Mobility Radeon X1300,=0A	ATI Mobility Radeon =
X1300, ATI Radeon X1300, ATI Radeon X1300,=0A	ATI RV505, ATI RV505, ATI Fir=
eGL V3300, ATI FireGL V3350,=0A	ATI Radeon X1300, ATI Radeon X1550 64-bit, =
ATI Radeon X1300/X1550,=0A	ATI Radeon X1600, ATI Radeon X1300/X1550, ATI Mo=
bility Radeon X1450,=0A	ATI Radeon X1300/X1550, ATI Mobility Radeon X2300,=
=0A	ATI Mobility Radeon X2300, ATI Mobility Radeon X1350,=0A	ATI Mobility R=
adeon X1350, ATI Mobility Radeon X1450,=0A	ATI Radeon X1300, ATI Radeon X15=
50, ATI Mobility Radeon X1350,=0A	ATI FireMV 2250, ATI Radeon X1550 64-bit,=
 ATI Radeon X1600,=0A	ATI Radeon X1650, ATI Radeon X1600, ATI Radeon X1600,=
=0A	ATI Mobility FireGL V5200, ATI Mobility Radeon X1600,=0A	ATI Radeon X16=
50, ATI Radeon X1650, ATI Radeon X1600,=0A	ATI Radeon X1300 XT/X1600 Pro, A=
TI FireGL V3400,=0A	ATI Mobility FireGL V5250, ATI Mobility Radeon X1700,=
=0A	ATI Mobility Radeon X1700 XT, ATI FireGL V5200,=0A	ATI Mobility Radeon =
X1700, ATI Radeon X2300HD,=0A	ATI Mobility Radeon HD 2300, ATI Mobility Rad=
eon HD 2300,=0A	ATI Radeon X1950, ATI Radeon X1900, ATI Radeon X1950,=0A	AT=
I Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,=0A	ATI Radeon X1900, AT=
I Radeon X1900, ATI Radeon X1900,=0A	ATI Radeon X1900, ATI Radeon X1900, AT=
I Radeon X1900,=0A	ATI AMD Stream Processor, ATI Radeon X1900, ATI Radeon X=
1950,=0A	ATI RV560, ATI RV560, ATI Mobility Radeon X1900, ATI RV560,=0A	ATI=
 Radeon X1950 GT, ATI RV570, ATI RV570, ATI FireGL V7400,=0A	ATI RV560, ATI=
 Radeon X1650, ATI Radeon X1650, ATI RV560,=0A	ATI Radeon 9100 PRO IGP 7834=
, ATI Radeon Mobility 9200 IGP 7835,=0A	ATI Radeon X1200, ATI Radeon X1200,=
 ATI Radeon X1200,=0A	ATI Radeon X1200, ATI Radeon X1200, ATI RS740, ATI RS=
740M, ATI RS740,=0A	ATI RS740M, ATI Radeon HD 2900 XT, ATI Radeon HD 2900 X=
T,=0A	ATI Radeon HD 2900 XT, ATI Radeon HD 2900 Pro, ATI Radeon HD 2900 GT,=
=0A	ATI FireGL V8650, ATI FireGL V8600, ATI FireGL V7600,=0A	ATI Radeon 480=
0 Series, ATI Radeon HD 4870 x2,=0A	ATI Radeon 4800 Series, ATI Radeon HD 4=
850 x2,=0A	ATI FirePro V8750 (FireGL), ATI FirePro V7760 (FireGL),=0A	ATI M=
obility RADEON HD 4850, ATI Mobility RADEON HD 4850 X2,=0A	ATI Radeon 4800 =
Series, ATI FirePro RV770, AMD FireStream 9270,=0A	AMD FireStream 9250, ATI=
 FirePro V8700 (FireGL),=0A	ATI Mobility RADEON HD 4870, ATI Mobility RADEO=
N M98,=0A	ATI Mobility RADEON HD 4870, ATI Radeon 4800 Series,=0A	ATI Radeo=
n 4800 Series, ATI FirePro M7750, ATI M98, ATI M98, ATI M98,=0A	ATI Mobilit=
y Radeon HD 4650, ATI Radeon RV730 (AGP),=0A	ATI Mobility Radeon HD 4670, A=
TI FirePro M5750,=0A	ATI Mobility Radeon HD 4670, ATI Radeon RV730 (AGP),=
=0A	ATI RV730XT [Radeon HD 4670], ATI RADEON E4600,=0A	ATI Radeon HD 4600 S=
eries, ATI RV730 PRO [Radeon HD 4650],=0A	ATI FirePro V7750 (FireGL), ATI F=
irePro V5700 (FireGL),=0A	ATI FirePro V3750 (FireGL), ATI Mobility Radeon H=
D 4830,=0A	ATI Mobility Radeon HD 4850, ATI FirePro M7740, ATI RV740,=0A	AT=
I Radeon HD 4770, ATI Radeon HD 4700 Series, ATI Radeon HD 4770,=0A	ATI Fir=
ePro M5750, ATI RV610, ATI Radeon HD 2400 XT,=0A	ATI Radeon HD 2400 Pro, AT=
I Radeon HD 2400 PRO AGP, ATI FireGL V4000,=0A	ATI RV610, ATI Radeon HD 235=
0, ATI Mobility Radeon HD 2400 XT,=0A	ATI Mobility Radeon HD 2400, ATI RADE=
ON E2400, ATI RV610,=0A	ATI FireMV 2260, ATI RV670, ATI Radeon HD3870,=0A	A=
TI Mobility Radeon HD 3850, ATI Radeon HD3850,=0A	ATI Mobility Radeon HD 38=
50 X2, ATI RV670,=0A	ATI Mobility Radeon HD 3870, ATI Mobility Radeon HD 38=
70 X2,=0A	ATI Radeon HD3870 X2, ATI FireGL V7700, ATI Radeon HD3850,=0A	ATI=
 Radeon HD3690, AMD Firestream 9170, ATI Radeon HD 4550,=0A	ATI Radeon RV71=
0, ATI Radeon RV710, ATI Radeon RV710,=0A	ATI Radeon HD 4350, ATI Mobility =
Radeon 4300 Series,=0A	ATI Mobility Radeon 4500 Series, ATI Mobility Radeon=
 4500 Series,=0A	ATI FirePro RG220, ATI Mobility Radeon 4330, ATI RV630,=0A=
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,=0A	ATI Radeon=
 HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,=0A	ATI Radeon HD 2600 XT, ATI =
Radeon HD 2600 Pro, ATI Gemini RV630,=0A	ATI Gemini Mobility Radeon HD 2600=
 XT, ATI FireGL V5600,=0A	ATI FireGL V3600, ATI Radeon HD 2600 LE,=0A	ATI M=
obility FireGL Graphics Processor, ATI Radeon HD 3470,=0A	ATI Mobility Rade=
on HD 3430, ATI Mobility Radeon HD 3400 Series,=0A	ATI Radeon HD 3450, ATI =
Radeon HD 3450, ATI Radeon HD 3430,=0A	ATI Radeon HD 3450, ATI FirePro V370=
0, ATI FireMV 2450,=0A	ATI FireMV 2260, ATI FireMV 2260, ATI Radeon HD 3600=
 Series,=0A	ATI Radeon HD 3650 AGP, ATI Radeon HD 3600 PRO,=0A	ATI Radeon H=
D 3600 XT, ATI Radeon HD 3600 PRO,=0A	ATI Mobility Radeon HD 3650, ATI Mobi=
lity Radeon HD 3670,=0A	ATI Mobility FireGL V5700, ATI Mobility FireGL V572=
5,=0A	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,=0A	ATI Radeon =
HD 3200 Graphics, ATI Radeon 3100 Graphics,=0A	ATI Radeon HD 3300 Graphics,=
 ATI Radeon HD 3200 Graphics,=0A	ATI Radeon 3000 Graphics, ATI Radeon HD 42=
00, ATI Radeon 4100,=0A	ATI Mobility Radeon HD 4200, ATI Mobility Radeon 41=
00,=0A	ATI Radeon HD 4290, ATI Radeon HD 4290, CYPRESS,=0A	ATI FirePro (Fir=
eGL) Graphics Adapter,=0A	ATI FirePro (FireGL) Graphics Adapter,=0A	ATI Fir=
ePro (FireGL) Graphics Adapter, ATI Radeon HD 5800 Series,=0A	ATI Radeon HD=
 5800 Series, ATI Radeon HD 5800 Series,=0A	ATI Radeon HD 5900 Series, ATI =
Radeon HD 5900 Series,=0A	ATI Mobility Radeon HD 5800 Series,=0A	ATI Mobili=
ty Radeon HD 5800 Series,=0A	ATI FirePro (FireGL) Graphics Adapter,=0A	ATI =
FirePro (FireGL) Graphics Adapter,=0A	ATI Mobility Radeon HD 5800 Series, A=
TI Radeon HD 5700 Series,=0A	ATI Radeon HD 5700 Series, ATI Radeon HD 5700 =
Series,=0A	ATI Mobility Radeon HD 5000 Series,=0A	ATI Mobility Radeon HD 50=
00 Series, ATI Mobility Radeon HD 5570,=0A	ATI FirePro (FireGL) Graphics Ad=
apter,=0A	ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5670,=0A	ATI=
 Radeon HD 5570, ATI Radeon HD 5500 Series, REDWOOD,=0A	ATI Mobility Radeon=
 HD 5000 Series,=0A	ATI Mobility Radeon HD 5000 Series, CEDAR, CEDAR, CEDAR=
,=0A	ATI FirePro (FireGL) Graphics Adapter,=0A	ATI FirePro (FireGL) Graphic=
s Adapter, CEDAR, ATI Radeon HD 5450,=0A	CEDAR=0A(II) FBDEV: driver for fra=
mebuffer: fbdev=0A(II) Primary Device is: PCI f1@00:00:0=0A(II) [KMS] Kerne=
l modesetting enabled.=0A(WW) Falling back to old probe method for fbdev=0A=
(II) Loading sub module "fbdevhw"=0A(II) LoadModule: "fbdevhw"=0A(II) Loadi=
ng /usr/lib/xorg/modules/linux/libfbdevhw.so=0A(II) Module fbdevhw: vendor=
=3D"X.Org Foundation"=0A	compiled for 1.7.7, module version =3D 0.0.2=0A	AB=
I class: X.Org Video Driver, version 6.0=0A(II) RADEON(0): Creating default=
 Display subsection in Screen section=0A	"Default Screen" for depth/fbbpp 2=
4/32=0A(=3D=3D) RADEON(0): Depth 24, (--) framebuffer bpp 32=0A(II) RADEON(=
0): Pixel depth =3D 24 bits stored in 4 bytes (32 bpp pixmaps)=0A(=3D=3D) R=
ADEON(0): Default visual is TrueColor=0A(=3D=3D) RADEON(0): RGB weight 888=
=0A(II) RADEON(0): Using 8 bits per RGB (8 bit DAC)=0A(--) RADEON(0): Chips=
et: "ATI Radeon X1650" (ChipID =3D 0x71c7)=0A(II) RADEON(0): PCIE card dete=
cted=0A(II) RADEON(0): KMS Color Tiling: enabled=0AdrmOpenDevice: node name=
 is /dev/dri/card0=0AdrmOpenDevice: open result is 7, (OK)=0AdrmOpenByBusid=
: Searching for BusID pci:0000:f1:00.0=0AdrmOpenDevice: node name is /dev/d=
ri/card0=0AdrmOpenDevice: open result is 7, (OK)=0AdrmOpenByBusid: drmOpenM=
inor returns 7=0AdrmOpenByBusid: drmGetBusid reports pci:0000:f1:00.0=0A(II=
) RADEON(0): Output DVI-0 using monitor section Configured Monitor=0A(II) R=
ADEON(0): Output S-video has no monitor section=0A(II) RADEON(0): Output DV=
I-1 has no monitor section=0A(II) RADEON(0): EDID for output DVI-0=0A(II) R=
ADEON(0): EDID for output S-video=0A(II) RADEON(0): EDID for output DVI-1=
=0A(II) RADEON(0): Manufacturer: DEL  Model: a02e  Serial#: 810309459=0A(II=
) RADEON(0): Year: 2009  Week: 2=0A(II) RADEON(0): EDID Version: 1.3=0A(II)=
 RADEON(0): Digital Display Input=0A(II) RADEON(0): Max Image Size [cm]: ho=
riz.: 52  vert.: 32=0A(II) RADEON(0): Gamma: 2.20=0A(II) RADEON(0): DPMS ca=
pabilities: StandBy Suspend Off=0A(II) RADEON(0): Supported color encodings=
: RGB 4:4:4 YCrCb 4:4:4 =0A(II) RADEON(0): Default color space is primary c=
olor space=0A(II) RADEON(0): First detailed timing is preferred mode=0A(II)=
 RADEON(0): redX: 0.640 redY: 0.330   greenX: 0.300 greenY: 0.600=0A(II) RA=
DEON(0): blueX: 0.150 blueY: 0.060   whiteX: 0.312 whiteY: 0.329=0A(II) RAD=
EON(0): Supported established timings:=0A(II) RADEON(0): 720x400@70Hz=0A(II=
) RADEON(0): 640x480@60Hz=0A(II) RADEON(0): 640x480@75Hz=0A(II) RADEON(0): =
800x600@60Hz=0A(II) RADEON(0): 800x600@75Hz=0A(II) RADEON(0): 1024x768@60Hz=
=0A(II) RADEON(0): 1024x768@75Hz=0A(II) RADEON(0): 1280x1024@75Hz=0A(II) RA=
DEON(0): Manufacturer's mask: 0=0A(II) RADEON(0): Supported standard timing=
s:=0A(II) RADEON(0): #0: hsize: 1152  vsize 864  refresh: 75  vid: 20337=0A=
(II) RADEON(0): #1: hsize: 1280  vsize 1024  refresh: 60  vid: 32897=0A(II)=
 RADEON(0): #2: hsize: 1600  vsize 1200  refresh: 60  vid: 16553=0A(II) RAD=
EON(0): Supported detailed timing:=0A(II) RADEON(0): clock: 154.0 MHz   Ima=
ge Size:  518 x 324 mm=0A(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sy=
nc_end 2000 h_blank_end 2080 h_border: 0=0A(II) RADEON(0): v_active: 1200  =
v_sync: 1203  v_sync_end 1209 v_blanking: 1235 v_border: 0=0A(II) RADEON(0)=
: Serial No: G274H9160LWS=0A(II) RADEON(0): Monitor name: DELL E248WFP=0A(I=
I) RADEON(0): Ranges: V min: 56 V max: 76 Hz, H min: 30 H max: 83 kHz, PixC=
lock max 175 MHz=0A(II) RADEON(0): EDID (in hex):=0A(II) RADEON(0): 	00ffff=
ffffffff0010ac2ea053574c30=0A(II) RADEON(0): 	0213010380342078eeee91a3544c9=
926=0A(II) RADEON(0): 	0f5054a54b00714f8180a94001010101=0A(II) RADEON(0): 	=
010101010101283c80a070b023403020=0A(II) RADEON(0): 	360006442100001a000000f=
f00473237=0A(II) RADEON(0): 	3448393136304c575320000000fc0044=0A(II) RADEON=
(0): 	454c4c20453234385746500a000000fd=0A(II) RADEON(0): 	00384c1e5311000a2=
020202020200024=0A(II) RADEON(0): Printing probed modes for output DVI-1=0A=
(II) RADEON(0): Modeline "1920x1200"x60.0  154.00  1920 1968 2000 2080  120=
0 1203 1209 1235 +hsync -vsync (74.0 kHz)=0A(II) RADEON(0): Modeline "1600x=
1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync =
(75.0 kHz)=0A(II) RADEON(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1=
440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)=0A(II) RADEON(0): Mo=
deline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +=
hsync +vsync (64.0 kHz)=0A(II) RADEON(0): Modeline "1152x864"x75.0  108.00 =
 1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)=0A(II) RADEO=
N(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 80=
0 +hsync +vsync (60.1 kHz)=0A(II) RADEON(0): Modeline "1024x768"x60.0   65.=
00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)=0A(II) RA=
DEON(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625=
 +hsync +vsync (46.9 kHz)=0A(II) RADEON(0): Modeline "800x600"x60.3   40.00=
  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)=0A(II) RADEON(=
0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsyn=
c -vsync (37.5 kHz)=0A(II) RADEON(0): Modeline "640x480"x60.0   25.20  640 =
656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)=0A(II) RADEON(0): Mod=
eline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsyn=
c (31.5 kHz)=0A(II) RADEON(0): Output DVI-0 disconnected=0A(II) RADEON(0): =
Output S-video disconnected=0A(II) RADEON(0): Output DVI-1 connected=0A(II)=
 RADEON(0): Using exact sizes for initial modes=0A(II) RADEON(0): Output DV=
I-1 using initial mode 1920x1200=0A(II) RADEON(0): Using default gamma of (=
1.0, 1.0, 1.0) unless otherwise stated.=0A(II) RADEON(0): mem size init: ga=
rt size :1fdff000 vram size: s:20000000 visible:1f6f6000=0A(II) RADEON(0): =
EXA: Driver will allow EXA pixmaps in VRAM=0A(=3D=3D) RADEON(0): DPI set to=
 (96, 96)=0A(II) Loading sub module "fb"=0A(II) LoadModule: "fb"=0A(II) Loa=
ding /usr/lib/xorg/modules/libfb.so=0A(II) Module fb: vendor=3D"X.Org Found=
ation"=0A	compiled for 1.7.7, module version =3D 1.0.0=0A	ABI class: X.Org =
ANSI C Emulation, version 0.4=0A(II) Loading sub module "ramdac"=0A(II) Loa=
dModule: "ramdac"=0A(II) Module "ramdac" already built-in=0A(II) Loading su=
b module "exa"=0A(II) LoadModule: "exa"=0A(II) Loading /usr/lib/xorg/module=
s/libexa.so=0A(II) Module exa: vendor=3D"X.Org Foundation"=0A	compiled for =
1.7.7, module version =3D 2.5.0=0A	ABI class: X.Org Video Driver, version 6=
=2E0=0A(II) UnloadModule: "fbdev"=0A(II) Unloading /usr/lib/xorg/modules/dr=
ivers/fbdev_drv.so=0A(II) UnloadModule: "fbdevhw"=0A(II) Unloading /usr/lib=
/xorg/modules/linux/libfbdevhw.so=0A(--) Depth 24 pixmap format is 32 bpp=
=0A(II) RADEON(0): [DRI2] Setup complete=0A(II) RADEON(0): Front buffer siz=
e: 9000K=0A(II) RADEON(0): VRAM usage limit set to 455428K=0A(=3D=3D) RADEO=
N(0): Backing store disabled=0A(II) RADEON(0): Direct rendering enabled=0A(=
II) RADEON(0): Render acceleration enabled for R300/R400/R500 type cards.=
=0A(II) RADEON(0): Setting EXA maxPitchBytes=0A(II) EXA(0): Driver allocate=
d offscreen pixmaps=0A(II) EXA(0): Driver registered support for the follow=
ing operations:=0A(II)         Solid=0A(II)         Copy=0A(II)         Com=
posite (RENDER acceleration)=0A(II)         UploadToScreen=0A(II)         D=
ownloadFromScreen=0A(II) RADEON(0): Acceleration enabled=0A(=3D=3D) RADEON(=
0): DPMS enabled=0A(=3D=3D) RADEON(0): Silken mouse enabled=0A(II) RADEON(0=
): Set up textured video=0A(II) RADEON(0): RandR 1.2 enabled, ignore the fo=
llowing RandR disabled message.=0A(--) RandR disabled=0A(II) Initializing b=
uilt-in extension Generic Event Extension=0A(II) Initializing built-in exte=
nsion SHAPE=0A(II) Initializing built-in extension MIT-SHM=0A(II) Initializ=
ing built-in extension XInputExtension=0A(II) Initializing built-in extensi=
on XTEST=0A(II) Initializing built-in extension BIG-REQUESTS=0A(II) Initial=
izing built-in extension SYNC=0A(II) Initializing built-in extension XKEYBO=
ARD=0A(II) Initializing built-in extension XC-MISC=0A(II) Initializing buil=
t-in extension SECURITY=0A(II) Initializing built-in extension XINERAMA=0A(=
II) Initializing built-in extension XFIXES=0A(II) Initializing built-in ext=
ension RENDER=0A(II) Initializing built-in extension RANDR=0A(II) Initializ=
ing built-in extension COMPOSITE=0A(II) Initializing built-in extension DAM=
AGE=0ASELinux: Disabled on system, not enabling in X server=0A(II) AIGLX: e=
nabled GLX_MESA_copy_sub_buffer=0A(II) AIGLX: enabled GLX_SGI_make_current_=
read=0A(II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control=
=0A(II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects=0A(II) =
AIGLX: Loaded and initialized /usr/lib/dri/r300_dri.so=0A(II) GLX: Initiali=
zed DRI2 GL provider for screen 0=0A(II) RADEON(0): Setting screen physical=
 size to 508 x 317=0A(II) config/udev: Adding input device Mitsumi Electric=
 Apple Extended USB Keyboard (/dev/input/event0)=0A(**) Mitsumi Electric Ap=
ple Extended USB Keyboard: Applying InputClass "evdev keyboard catchall"=0A=
(II) LoadModule: "evdev"=0A(II) Loading /usr/lib/xorg/modules/input/evdev_d=
rv.so=0A(II) Module evdev: vendor=3D"X.Org Foundation"=0A	compiled for 1.7.=
6.901, module version =3D 2.3.2=0A	Module class: X.Org XInput Driver=0A	ABI=
 class: X.Org XInput driver, version 7.0=0A(**) Mitsumi Electric Apple Exte=
nded USB Keyboard: always reports core events=0A(**) Mitsumi Electric Apple=
 Extended USB Keyboard: Device: "/dev/input/event0"=0A(II) Mitsumi Electric=
 Apple Extended USB Keyboard: Found keys=0A(II) Mitsumi Electric Apple Exte=
nded USB Keyboard: Configuring as keyboard=0A(II) XINPUT: Adding extended i=
nput device "Mitsumi Electric Apple Extended USB Keyboard" (type: KEYBOARD)=
=0A(**) Option "xkb_rules" "evdev"=0A(**) Option "xkb_model" "macintosh"=0A=
(**) Option "xkb_layout" "es"=0A(**) Option "xkb_options" "altwin:alt_super=
_win,altwin:swap_lalt_lwin,lv3:alt_switch"=0A(II) config/udev: Adding input=
 device Mitsumi Electric Apple Extended USB Keyboard (/dev/input/event1)=0A=
(**) Mitsumi Electric Apple Extended USB Keyboard: Applying InputClass "evd=
ev keyboard catchall"=0A(**) Mitsumi Electric Apple Extended USB Keyboard: =
always reports core events=0A(**) Mitsumi Electric Apple Extended USB Keybo=
ard: Device: "/dev/input/event1"=0A(II) Mitsumi Electric Apple Extended USB=
 Keyboard: Found keys=0A(II) Mitsumi Electric Apple Extended USB Keyboard: =
Configuring as keyboard=0A(II) XINPUT: Adding extended input device "Mitsum=
i Electric Apple Extended USB Keyboard" (type: KEYBOARD)=0A(**) Option "xkb=
_rules" "evdev"=0A(**) Option "xkb_model" "macintosh"=0A(**) Option "xkb_la=
yout" "es"=0A(**) Option "xkb_options" "altwin:alt_super_win,altwin:swap_la=
lt_lwin,lv3:alt_switch"=0A(II) config/udev: Adding input device Logitech US=
B-PS/2 Optical Mouse (/dev/input/event2)=0A(**) Logitech USB-PS/2 Optical M=
ouse: Applying InputClass "evdev pointer catchall"=0A(**) Logitech USB-PS/2=
 Optical Mouse: always reports core events=0A(**) Logitech USB-PS/2 Optical=
 Mouse: Device: "/dev/input/event2"=0A(II) Logitech USB-PS/2 Optical Mouse:=
 Found 3 mouse buttons=0A(II) Logitech USB-PS/2 Optical Mouse: Found scroll=
 wheel(s)=0A(II) Logitech USB-PS/2 Optical Mouse: Found relative axes=0A(II=
) Logitech USB-PS/2 Optical Mouse: Found x and y relative axes=0A(II) Logit=
ech USB-PS/2 Optical Mouse: Configuring as mouse=0A(**) Logitech USB-PS/2 O=
ptical Mouse: YAxisMapping: buttons 4 and 5=0A(**) Logitech USB-PS/2 Optica=
l Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeou=
t: 200=0A(II) XINPUT: Adding extended input device "Logitech USB-PS/2 Optic=
al Mouse" (type: MOUSE)=0A(II) Logitech USB-PS/2 Optical Mouse: initialized=
 for relative axes.=0A(II) config/udev: Adding input device Logitech USB-PS=
/2 Optical Mouse (/dev/input/mouse0)=0A(II) No input driver/identifier spec=
ified (ignoring)=0A
--BOKacYhQ+x31HxR3--
