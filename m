Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0HPIlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:41:05 -0400
Received: from contentorg.co.uk ([87.106.218.60]:53979 "EHLO contentorg.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab0HPIlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:41:02 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 04:41:00 EDT
Message-ID: <4C68F806.9090801@content-org.com>
Date: Mon, 16 Aug 2010 09:34:14 +0100
From: Ian Newton <i.newton@content-org.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100808 Mandriva/3.1.2-69.1mib2010.1 (2010.1) Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: suspend/resume no longer working on kernel 2.6.34 (34 or 35) Via
 VX800/VX820 chipset
Content-Type: multipart/mixed;
 boundary="------------090009080804060700030402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090009080804060700030402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

 [1.] One line summary of the problem:
suspend/resume no longer working on kernel 2.6.33 (34 or 35) Via
VX800/VX820 chipset

[2.] Full description of the problem/report:Upgrading from 2.6.31-13
kernel (Mandriva 2010.0)  to 2.6.33-5 kernel (Mandriva 2010.1) results
in the final stage of shutdown on suspend (ram or disk) hanging without
putting the laptop (Samsung NC20) to sleep. The network and power leds
and processor remain on though the screen has powered down. Reverting to
2.6.31-13 resolves the issue. The pm-suspend.log (attached) seems to be
correct though when control is passed to the kernel the hang state result=
s.

[3.] Keywords (i.e., modules, networking, kernel):
kernel suspend/resume power management

[4.] Kernel version (from /proc/version):
Linux version 2.6.34.2-tmb-laptop-2mdv (mandrake@n4.mandriva.com) (gcc
version 4.4.3 (GCC) ) #1 SMP Sun Aug 15 13:50:18 UTC 2010

[5.] Output of Oops.. message (if applicable) with symbolic information
resolved (see Documentation/oops-tracing.txt)

[6.] A small shell script or example program which triggers the
problem (if possible)

[7.] Environment
LESSKEY=3D/etc/.less
LC_PAPER=3Den_GB.UTF-8
LC_ADDRESS=3Den_GB.UTF-8
KDE_MULTIHEAD=3Dfalse
DM_CONTROL=3D/var/run/xdmctl
HOSTNAME=3Dlocalhost.localdomain
LC_MONETARY=3Den_GB.UTF-8
MALLOC_CHECK_=3D2
GPG_AGENT_INFO=3D/home/ixnewton/.gnupg/S.gpg-agent:5985:1
TERM=3Dxterm
SHELL=3D/bin/bash
XDG_MENU_PREFIX=3Dkde-
HISTSIZE=3D1000
XDG_SESSION_COOKIE=3Ddc07773cfbd39ff212b34c9c4b49ab89-1281943875.441308-1=
898716235
XDM_MANAGED=3Dmethod=3Dclassic,auto
LC_SOURCED=3D1
CANBERRA_DRIVER=3Dpulse
GTK2_RC_FILES=3D/etc/gtk-2.0/gtkrc:/home/ixnewton/.gtkrc-2.0::/home/ixnew=
ton/.kde4/share/config/gtkrc-2.0
KONSOLE_DBUS_SERVICE=3D:1.35
TMPDIR=3D/home/ixnewton/tmp
GTK_RC_FILES=3D/etc/gtk/gtkrc:/home/ixnewton/.gtkrc::/home/ixnewton/.kde4=
/share/config/gtkrc
GS_LIB=3D/home/ixnewton/.fonts
WINDOWID=3D39845927
LC_NUMERIC=3Den_GB.UTF-8
QTDIR=3D/usr/lib/qt4
GTK_MODULES=3Dcanberra-gtk-module
KDE_FULL_SESSION=3Dtrue
USER=3Dixnewton
LS_COLORS=3Drs=3D0:di=3D01;34:ln=3D01;36:mh=3D00:pi=3D40;33:so=3D01;35:do=
=3D01;35:bd=3D40;33;01:cd=3D40;33;01:or=3D01;05;37;41:mi=3D01;05;37;41:su=
=3D37;41:sg=3D30;43:ca=3D30;41:tw=3D30;42:ow=3D34;42:st=3D37;44:ex=3D01;3=
2:*.cmd=3D01;32:*.exe=3D01;32:*.com=3D01;32:*.btm=3D01;32:*.bat=3D01;32:*=
=2Esh=3D01;32:*.csh=3D01;32:*.tar=3D01;31:*.tgz=3D01;31:*.arj=3D01;31:*.t=
az=3D01;31:*.lzh=3D01;31:*.lzma=3D01;31:*.tlz=3D01;31:*.txz=3D01;31:*.zip=
=3D01;31:*.z=3D01;31:*.Z=3D01;31:*.dz=3D01;31:*.gz=3D01;31:*.lz=3D01;31:*=
=2Exz=3D01;31:*.bz2=3D01;31:*.bz=3D01;31:*.tbz=3D01;31:*.tbz2=3D01;31:*.t=
z=3D01;31:*.deb=3D01;31:*.rpm=3D01;31:*.jar=3D01;31:*.rar=3D01;31:*.ace=3D=
01;31:*.zoo=3D01;31:*.cpio=3D01;31:*.7z=3D01;31:*.rz=3D01;31:*.iso=3D01;3=
1:*.jpg=3D01;35:*.jpeg=3D01;35:*.JPG=3D01;35:*.JPEG=3D01;35:*.gif=3D01;35=
:*.bmp=3D01;35:*.pbm=3D01;35:*.pgm=3D01;35:*.ppm=3D01;35:*.tga=3D01;35:*.=
xbm=3D01;35:*.xpm=3D01;35:*.tif=3D01;35:*.tiff=3D01;35:*.png=3D01;35:*.ic=
o=3D01;35:*.svg=3D01;35:*.svgz=3D01;35:*.mng=3D01;35:*.pcx=3D01;35:*.mov=3D=
01;35:*.mpg=3D01;35:*.mpeg=3D01;35:*.m2v=3D01;35:*.mkv=3D01;35:*.ogm=3D01=
;35:*.divx=3D01;35:*.xvid=3D01;35:*.3gp=3D01;35:*.mp4=3D01;35:*.m4v=3D01;=
35:*.mp4v=3D01;35:*.vob=3D01;35:*.qt=3D01;35:*.nuv=3D01;35:*.wmv=3D01;35:=
*.asf=3D01;35:*.rm=3D01;35:*.rmvb=3D01;35:*.flc=3D01;35:*.avi=3D01;35:*.f=
li=3D01;35:*.flv=3D01;35:*.gl=3D01;35:*.dl=3D01;35:*.xcf=3D01;35:*.xwd=3D=
01;35:*.yuv=3D01;35:*.cgm=3D01;35:*.emf=3D01;35:*.axv=3D01;35:*.anx=3D01;=
35:*.ogv=3D01;35:*.ogx=3D01;35:*.aac=3D00;36:*.au=3D00;36:*.flac=3D00;36:=
*.mid=3D00;36:*.midi=3D00;36:*.mka=3D00;36:*.mp3=3D00;36:*.mpc=3D00;36:*.=
ogg=3D00;36:*.ra=3D00;36:*.wav=3D00;36:*.axa=3D00;36:*.oga=3D00;36:*.spx=3D=
00;36:*.xspf=3D00;36:*.mp2=3D00;36:*.mod=3D00;36:*.xm=3D00;36:*.s3m=3D00;=
36:*.it=3D00;36:*.wma=3D00;36:*~=3D47;30:*.bak=3D47;30:*.swp=3D47;30:*.bc=
k=3D47;30:*.bk=3D47;30:*.old=3D47;30:*.tmp=3D47;30:*.save=3D47;30:*.rpmsa=
ve=3D47;30:*.rpmnew=3D47;30:
QT4DOCDIR=3D/usr/share/doc/qt4/doc
LC_TELEPHONE=3Den_GB.UTF-8
SESSION_MANAGER=3Dlocal/localhost.localdomain:@/tmp/.ICE-unix/7737,unix/l=
ocalhost.localdomain:/tmp/.ICE-unix/7737
XDG_CONFIG_DIRS=3D/etc/xdg:/etc/xdg/kde4
NLSPATH=3D/usr/share/locale/%l/%N
DESKTOP_SESSION=3D01KDE4
PATH=3D/usr/bin:/bin:/usr/local/bin:/usr/X11R6/bin/:/usr/games:/usr/lib/q=
t4/bin:/home/ixnewton/bin
MAIL=3D/var/spool/mail/ixnewton
LC_MESSAGES=3Den_GB.UTF-8
LC_IDENTIFICATION=3Den_GB.UTF-8
LC_COLLATE=3Den_GB.UTF-8
PWD=3D/home/ixnewton/.kde4/Autostart
INPUTRC=3D/etc/inputrc
XMODIFIERS=3D@im=3Dnone
KDE_COLOR_DEBUG=3D1
LANG=3Den_GB.UTF-8
KDE_SESSION_UID=3D10001
PYTHONSTARTUP=3D/etc/pythonrc.py
LC_MEASUREMENT=3Den_GB.UTF-8
PYTHONDONTWRITEBYTECODE=3D1
KONSOLE_DBUS_SESSION=3D/Sessions/2
HISTCONTROL=3Dignoredups
SSH_ASKPASS=3D/usr/lib/ssh/ssh-askpass
COLORFGBG=3D0;15
SHLVL=3D2
HOME=3D/home/ixnewton
LESSCHARSET=3Dutf-8
KDE_SESSION_VERSION=3D4
LANGUAGE=3Den_GB.UTF-8:en_GB:en
XCURSOR_THEME=3DOxygen_White
GCONF_TMPDIR=3D/tmp
LESS=3D-MM
G_FILENAME_ENCODING=3D@locale
LOGNAME=3Dixnewton
PYTHONPATH=3D/usr/lib/ooo/basis-link/program:/usr/lib/ooo/basis-link/prog=
ram
TMP=3D/home/ixnewton/tmp
LC_CTYPE=3Den_GB.UTF-8
DBUS_SESSION_BUS_ADDRESS=3Dunix:abstract=3D/tmp/dbus-tIXCkOOHNa,guid=3Da0=
71bf0f0167ce81ab9642ee00000040
XDG_DATA_DIRS=3D/usr/share:/usr/share:/usr/local/share
LESSOPEN=3D|/usr/bin/lesspipe.sh %s
BROWSER=3D/usr/bin/www-browser
WINDOWPATH=3D8
PROFILEHOME=3D
DISPLAY=3D:0
QTEST_COLORED=3D1
META_CLASS=3Ddesktop
QT_PLUGIN_PATH=3D/home/ixnewton/.kde4/lib/kde4/plugins/:/usr/lib/kde4/plu=
gins/
LC_TIME=3Den_GB.UTF-8
MDV_MENU_STYLE=3Dmandriva
LC_NAME=3Den_GB.UTF-8
_=3D/usr/bin/env

[7.1.] Software (add the output of the ver_linux script here)

[7.2.] Processor information (from /proc/cpuinfo):

[7.3.] Module information (from /proc/modules):

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem=
)

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: VIA Technologies, Inc. VX800 Host Bridge (rev 12)
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes

00:00.1 Host bridge: VIA Technologies, Inc. VX800/VX820 Error Reporting
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

00:00.2 Host bridge: VIA Technologies, Inc. VX800/VX820 Host Bus Control
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

00:00.3 Host bridge: VIA Technologies, Inc. VX800 PCI to PCI Bridge
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:00.4 Host bridge: VIA Technologies, Inc. VX800/VX820 Power Management
Control
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

00:00.5 PIC: VIA Technologies, Inc. VX800/VX820 APIC and Central Traffic
Control (prog-if 20 [IO(X)-APIC])
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

00:00.6 Host bridge: VIA Technologies, Inc. VX800/VX820 Scratch Registers=

        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

00:00.7 Host bridge: VIA Technologies, Inc. VX800/VX820 North-South
Module Interface Control
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes

00:01.0 VGA compatible controller: VIA Technologies, Inc. VX800/VX820
Chrome 9 HC3 Integrated Graphics (rev 11) (prog-if 00 [VGA controller])
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort+ <MAbort+ >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=3D256M]=

        Region 1: Memory at f4000000 (32-bit, non-prefetchable) [size=3D1=
6M]
        Region 2: Memory at f0000000 (32-bit, non-prefetchable) [size=3D6=
4M]
        [virtual] Expansion ROM at 80400000 [disabled] [size=3D64K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [90] MSI: Enable- Count=3D1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Kernel modules: viafb

00:03.0 PCI bridge: VIA Technologies, Inc. VX800/VX820 PCI Express Root
Port (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: f5000000-f50fffff
        Prefetchable memory behind bridge: 0000000080000000-00000000801ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr+ UnsuppReq- AuxPwr+
TransPend+
                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <1us
                        ClockPM- Surprise+ LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
                        Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [70] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
                Address: 00000000fee0100c  Data: 4149
                Masking: 00000001  Pending: 00000000
        Capabilities: [98] Subsystem: Samsung Electronics Co Ltd Device c=
04e
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP+ BadDLLP+ Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopT=
rans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D=
ff
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=3D02 ComponentID=3D01 EltType=3DConfig=

                Link0:  Desc:   TargetPort=3D00 TargetComponent=3D01
AssocRCRB- LinkType=3DMemMapped LinkValid+
                        Addr:   0000000000000000
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:03.1 PCI bridge: VIA Technologies, Inc. VX800/VX820 PCI Express Root
Port (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: f5100000-f51fffff
        Prefetchable memory behind bridge: 0000000080200000-00000000803ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr+ UnsuppReq- AuxPwr+
TransPend+
                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <1us
                        ClockPM- Surprise+ LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
                        Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [70] MSI: Enable+ Count=3D1/1 Maskable+ 64bit+
                Address: 00000000fee0100c  Data: 4151
                Masking: 00000001  Pending: 00000000
        Capabilities: [98] Subsystem: Samsung Electronics Co Ltd Device c=
04e
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopT=
rans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D=
ff
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=3D03 ComponentID=3D01 EltType=3DConfig=

                Link0:  Desc:   TargetPort=3D00 TargetComponent=3D01
AssocRCRB- LinkType=3DMemMapped LinkValid+
                        Addr:   0000000000000000
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:0d.0 FLASH memory: VIA Technologies, Inc. Secure Digital Memory Card
Controller
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f5404000 (32-bit, non-prefetchable) [size=3D2=
K]
        Region 1: I/O ports at 4470 [size=3D8]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Kernel driver in use: via_sdmmc
        Kernel modules: via-sdmmc

00:0f.0 IDE interface: VIA Technologies, Inc. VX800 Serial ATA and EIDE
Controller (prog-if 8a [Master SecP PriP])
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [size=3D8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [size=3D1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [size=3D8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [size=3D1]
        Region 4: I/O ports at 4460 [size=3D16]
        Capabilities: [b0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Kernel driver in use: pata_via
        Kernel modules: via82cxxx, pata_via

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev a0) (prog-if 00 [UHCI])
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at 4400 [size=3D32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev a0) (prog-if 00 [UHCI])
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 22
        Region 4: I/O ports at 4420 [size=3D32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
+
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev a0) (prog-if 00 [UHCI])
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 21
        Region 4: I/O ports at 4440 [size=3D32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 90) (prog-if
20 [EHCI])
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at f5404800 (32-bit, non-prefetchable) [size=3D2=
56]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [88] Debug port: BAR=3D1 offset=3D00a0
        Kernel driver in use: ehci_hcd
        Kernel modules: ehci-hcd

00:11.0 ISA bridge: VIA Technologies, Inc. VX800/VX820 Bus Control and
Power Management
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Kernel modules: i2c-viapro

00:11.7 Host bridge: VIA Technologies, Inc. VX8xx South-North Module
Interface Control
        Subsystem: VIA Technologies, Inc. Device 7323
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort+ >SERR- <PERR- INTx-

00:14.0 Audio device: VIA Technologies, Inc. VT1708/A [Azalia HDAC] (VIA
High Definition Audio Controller) (rev 20)
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 51
        Region 0: Memory at f5400000 (64-bit, non-prefetchable) [size=3D1=
6K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [60] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 4199
        Capabilities: [70] Express (v1) Root Complex Integrated
Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend+
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopT=
rans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D=
ff
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=3D04 ComponentID=3D01 EltType=3DConfig=

                Link0:  Desc:   TargetPort=3D00 TargetComponent=3D01
AssocRCRB- LinkType=3DMemMapped LinkValid+
                        Addr:   0000000000000000
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

01:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
Network Adapter (rev 01)
        Subsystem: Askey Computer Corp. Device 7131
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 28
        Region 0: Memory at f5000000 (64-bit, non-prefetchable) [size=3D6=
4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME=
-
        Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] MSI-X: Enable- Count=3D1 Masked-
                Vector table: BAR=3D0 offset=3D00000000
                PBA: BAR=3D0 offset=3D00000000
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP+ Rollover+ Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+
ChkEn-
        Capabilities: [140 v1] Virtual Channel
                Caps:   LPEVC=3D0 RefClk=3D100ns PATEntryBits=3D1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=3DFixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=3D00 MaxTimeSlots=3D1 RejSnoopT=
rans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256-
                        Ctrl:   Enable+ ID=3D0 ArbSelect=3DFixed TC/VC=3D=
ff
                        Status: NegoPending- InProgress-
        Kernel driver in use: ath_pci
        Kernel modules: ath5k, ath_pci

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8040 PCI-E
Fast Ethernet Controller (rev 13)
        Subsystem: Samsung Electronics Co Ltd Device c04e
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 50
        Region 0: Memory at f5100000 (64-bit, non-prefetchable) [size=3D1=
6K]
        Region 2: I/O ports at 5000 [size=3D256]
        Capabilities: [48] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D1 PME=
-
        Capabilities: [5c] MSI: Enable+ Count=3D1/1 Maskable- 64bit+
                Address: 00000000fee0100c  Data: 4181
        Capabilities: [c0] Express (v2) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr+ UnsuppReq+ AuxPwr+
TransPend-
                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 unlimited
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 128 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 1f, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [130 v1] Device Serial Number 2f-e5-e3-ff-ff-77-13-=
00
        Kernel driver in use: sky2
        Kernel modules: sky2

[7.6.] SCSI information (from /proc/scsi/scsi)

[7.7.] Other information that might be relevant to the problem
(please look in /proc and include all information that you
think to be relevant):

[X.] Other notes, patches, fixes, workarounds:
Reverting to 2.6.31-13 resolves the issue

--------------090009080804060700030402
Content-Type: text/plain;
 name="cpuinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cpuinfo"

processor	: 0
vendor_id	: CentaurHauls
cpu family	: 6
model		: 15
model name	: VIA Nano processor U2250@1300+MHz
stepping	: 2
cpu MHz		: 1000.000
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush acpi mmx fxsr sse sse2 ss tm syscall lm constant_tsc up rep_good pni monitor vmx est tm2 ssse3 cx16 xtpr rng rng_en ace ace_en ace2 phe phe_en lahf_lm
bogomips	: 3191.37
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:


--------------090009080804060700030402
Content-Type: text/plain;
 name="modules"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="modules"

wlan_tkip 9974 2 - Live 0xf8017000
hidp 10682 1 - Live 0xf977d000
rfcomm 30509 8 - Live 0xf9767000
sco 7250 2 - Live 0xf9751000
bridge 57721 0 - Live 0xf9733000
stp 1471 1 bridge, Live 0xf9718000
llc 3905 2 bridge,stp, Live 0xf970f000
bnep 8945 2 - Live 0xf9702000
l2cap 29374 21 hidp,rfcomm,bnep, Live 0xf96ed000
btusb 10195 4 - Live 0xf96d8000
fuse 56362 2 - Live 0xf96bb000
nls_iso8859_1 3189 1 - Live 0xf9697000
nls_cp437 4859 1 - Live 0xf968c000
vfat 8165 1 - Live 0xf9681000
fat 45200 1 vfat, Live 0xf9668000
ipt_IFWLOG 1846 7 - Live 0xf95b8000
ipt_psd 43011 1 - Live 0xf95a4000
cls_flow 5931 0 - Live 0xf950a000
cls_fw 3095 0 - Live 0xf94ff000
cls_u32 5254 0 - Live 0xf94f4000
sch_htb 13036 0 - Live 0xf94e6000
sch_hfsc 16069 0 - Live 0xf94d6000
sch_ingress 1366 0 - Live 0xf94c8000
sch_sfq 4699 0 - Live 0xf94be000
xt_time 1745 0 - Live 0xf9468000
xt_connlimit 2560 0 - Live 0xf9451000
xt_realm 686 0 - Live 0xf942d000
iptable_raw 1058 0 - Live 0xf93ae000
xt_comment 660 18 - Live 0xf932b000
xt_recent 7260 0 - Live 0xf927b000
xt_policy 2098 0 - Live 0xf8956000
ipt_ULOG 5150 0 - Live 0xf86e4000
ipt_REJECT 1905 4 - Live 0xf86da000
ipt_REDIRECT 889 0 - Live 0xf86d0000
ipt_NETMAP 881 0 - Live 0xf86bf000
ipt_MASQUERADE 1315 0 - Live 0xf86a5000
ipt_ECN 1477 0 - Live 0xf864b000
ipt_ecn 1093 0 - Live 0xf8632000
ipt_CLUSTERIP 4579 0 - Live 0xf85f0000
ipt_ah 833 0 - Live 0xf85e3000
ipt_addrtype 1507 2 - Live 0xf85cd000
nf_nat_tftp 624 0 - Live 0xf85b5000
nf_nat_snmp_basic 7085 0 - Live 0xf85a5000
nf_nat_sip 5182 0 - Live 0xf852d000
nf_nat_pptp 1860 0 - Live 0xf84f4000
nf_nat_proto_gre 1157 1 nf_nat_pptp, Live 0xf8496000
nf_nat_irc 1032 0 - Live 0xf8456000
nf_nat_h323 4793 0 - Live 0xf83ed000
nf_nat_ftp 1294 0 - Live 0xf83e0000
nf_nat_amanda 786 0 - Live 0xf83c4000
ts_kmp 1537 5 - Live 0xf834b000
nf_conntrack_amanda 2080 1 nf_nat_amanda, Live 0xf8342000
nf_conntrack_sane 3051 0 - Live 0xf8324000
nf_conntrack_tftp 2822 1 nf_nat_tftp, Live 0xf8283000
nf_conntrack_sip 16941 1 nf_nat_sip, Live 0xf8309000
nf_conntrack_proto_sctp 6204 0 - Live 0xf8073000
nf_conntrack_pptp 4179 1 nf_nat_pptp, Live 0xf92fc000
nf_conntrack_proto_gre 3458 1 nf_conntrack_pptp, Live 0xf92f1000
nf_conntrack_netlink 14568 0 - Live 0xf92e3000
nf_conntrack_netbios_ns 1226 0 - Live 0xf928a000
nf_conntrack_irc 3234 1 nf_nat_irc, Live 0xf9284000
nf_conntrack_h323 45216 1 nf_nat_h323, Live 0xf92c6000
nf_conntrack_ftp 5215 1 nf_nat_ftp, Live 0xf8984000
ipt_set 1083 2 - Live 0xf8979000
ipt_SET 1243 0 - Live 0xf892d000
ip_set_nethash 7097 0 - Live 0xf8923000
ip_set_iptreemap 7480 0 - Live 0xf8917000
ip_set_iptree 4577 2 - Live 0xf88f7000
ip_set_ipporthash 6162 0 - Live 0xf88eb000
ip_set_portmap 2850 0 - Live 0xf88da000
ip_set_macipmap 2704 0 - Live 0xf88d0000
ip_set_ipmap 2694 0 - Live 0xf88c0000
ip_set_iphash 5487 0 - Live 0xf88b8000
ip_set 12157 18 ipt_set,ipt_SET,ip_set_nethash,ip_set_iptreemap,ip_set_iptree,ip_set_ipporthash,ip_set_portmap,ip_set_macipmap,ip_set_ipmap,ip_set_iphash, Live 0xf8766000
xt_TPROXY 1137 0 - Live 0xf8752000
nf_tproxy_core 1388 1 xt_TPROXY,[permanent], Live 0xf8743000
xt_tcpmss 1073 0 - Live 0xf8735000
xt_pkttype 788 0 - Live 0xf8728000
xt_physdev 1447 0 - Live 0xf8711000
xt_owner 878 2 - Live 0xf8708000
xt_NFQUEUE 1743 0 - Live 0xf86ff000
xt_NFLOG 813 0 - Live 0xf86eb000
nfnetlink_log 6684 1 xt_NFLOG, Live 0xf86c8000
xt_multiport 2158 6 - Live 0xf86b6000
xt_MARK 683 1 - Live 0xf86ac000
xt_mark 683 0 - Live 0xf869f000
xt_mac 744 0 - Live 0xf8648000
xt_limit 1226 0 - Live 0xf8635000
xt_length 844 0 - Live 0xf8605000
xt_iprange 1265 0 - Live 0xf85f3000
xt_helper 1011 0 - Live 0xf85e6000
xt_hashlimit 7945 0 - Live 0xf85d9000
xt_DSCP 1585 0 - Live 0xf85c2000
xt_dscp 1209 0 - Live 0xf85b2000
xt_dccp 1705 0 - Live 0xf85a2000
xt_conntrack 2178 12 - Live 0xf854b000
xt_CONNMARK 1085 0 - Live 0xf853c000
xt_connmark 893 0 - Live 0xf8523000
xt_CLASSIFY 695 0 - Live 0xf84f1000
ipt_LOG 4418 5 - Live 0xf849a000
xt_tcpudp 1887 18 - Live 0xf845d000
xt_state 1006 6 - Live 0xf8450000
iptable_nat 3488 1 - Live 0xf8441000
nf_nat 14511 12 ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,nf_nat_tftp,nf_nat_sip,nf_nat_pptp,nf_nat_proto_gre,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,iptable_nat, Live 0xf8414000
nf_conntrack_ipv4 10197 21 iptable_nat,nf_nat, Live 0xf83d8000
nf_defrag_ipv4 997 2 xt_TPROXY,nf_conntrack_ipv4, Live 0xf8338000
nf_conntrack 57228 31 xt_connlimit,ipt_MASQUERADE,ipt_CLUSTERIP,nf_nat_tftp,nf_nat_snmp_basic,nf_nat_sip,nf_nat_pptp,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_amanda,nf_conntrack_sane,nf_conntrack_tftp,nf_conntrack_sip,nf_conntrack_proto_sctp,nf_conntrack_pptp,nf_conntrack_proto_gre,nf_conntrack_netlink,nf_conntrack_netbios_ns,nf_conntrack_irc,nf_conntrack_h323,nf_conntrack_ftp,xt_helper,xt_conntrack,xt_CONNMARK,xt_connmark,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4, Live 0xf8655000
iptable_mangle 1267 1 - Live 0xf82f7000
nfnetlink 3068 2 nf_conntrack_netlink,nfnetlink_log, Live 0xf82a6000
wlan_ccmp 5743 0 - Live 0xf8278000
via 37544 0 - Live 0xf8420000
drm 150734 1 via, Live 0xf924e000
iptable_filter 1230 1 - Live 0xf835e000
ip_tables 9709 4 iptable_raw,iptable_nat,iptable_mangle,iptable_filter, Live 0xf8359000
x_tables 12545 51 ipt_IFWLOG,ipt_psd,xt_time,xt_connlimit,xt_realm,iptable_raw,xt_comment,xt_recent,xt_policy,ipt_ULOG,ipt_REJECT,ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,ipt_ECN,ipt_ecn,ipt_CLUSTERIP,ipt_ah,ipt_addrtype,ipt_set,ipt_SET,xt_TPROXY,xt_tcpmss,xt_pkttype,xt_physdev,xt_owner,xt_NFQUEUE,xt_NFLOG,xt_multiport,xt_MARK,xt_mark,xt_mac,xt_limit,xt_length,xt_iprange,xt_helper,xt_hashlimit,xt_DSCP,xt_dscp,xt_dccp,xt_conntrack,xt_CONNMARK,xt_connmark,xt_CLASSIFY,ipt_LOG,xt_tcpudp,xt_state,iptable_nat,iptable_mangle,iptable_filter,ip_tables, Live 0xf832e000
nfsd 229005 11 - Live 0xf928c000
lockd 61561 1 nfsd, Live 0xf860d000
nfs_acl 2073 1 nfsd, Live 0xf827d000
auth_rpcgss 30117 1 nfsd, Live 0xf82d3000
sunrpc 173448 15 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xf8777000
exportfs 3095 1 nfsd, Live 0xf801b000
deflate 1551 0 - Live 0xf8582000
zlib_deflate 18895 1 deflate, Live 0xf854e000
ctr 2913 0 - Live 0xf8536000
twofish 5391 0 - Live 0xf851d000
twofish_common 12699 1 twofish, Live 0xf8502000
camellia 17792 0 - Live 0xf849e000
serpent 17393 0 - Live 0xf8460000
blowfish 7246 0 - Live 0xf8452000
cast5 15452 0 - Live 0xf8444000
des_generic 15835 0 - Live 0xf8437000
cbc 2141 0 - Live 0xf841d000
xcbc 2067 0 - Live 0xf83e7000
rmd160 6276 0 - Live 0xf83dc000
sha512_generic 7128 0 - Live 0xf83c9000
crypto_null 2138 0 - Live 0xf83be000
af_key 25037 2 - Live 0xf8350000
ipcomp 1619 0 - Live 0xf833f000
xfrm_ipcomp 3382 1 ipcomp, Live 0xf8335000
ah4 3983 0 - Live 0xf832b000
tun 12278 0 - Live 0xf82ec000
esp4 4174 0 - Live 0xf82e8000
af_packet 16142 6 - Live 0xf82bb000
wlan_wep 4761 0 - Live 0xf827f000
ipv6 250524 52 - Live 0xf8841000
cpufreq_ondemand 7862 0 - Live 0xf801d000
binfmt_misc 6149 1 - Live 0xf862e000
loop 12269 0 - Live 0xf8600000
dm_mod 57657 0 - Live 0xf8817000
sha256_generic 11131 0 - Live 0xf85c8000
sha1_generic 1691 0 - Live 0xf85bc000
padlock_sha 3113 0 - Live 0xf85af000
padlock_aes 4481 0 - Live 0xf859e000
aes_generic 26456 1 padlock_aes, Live 0xf858c000
nvram 5235 0 - Live 0xf8530000
pcspkr 1426 0 - Live 0xf8527000
acpi_cpufreq 5723 1 - Live 0xf8519000
freq_table 2879 2 cpufreq_ondemand,acpi_cpufreq, Live 0xf84f7000
snd_hda_codec_realtek 211811 1 - Live 0xf8995000
snd_hda_intel 20125 2 - Live 0xf84e7000
snd_hda_codec 77223 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xf855e000
snd_hwdep 4928 1 snd_hda_codec, Live 0xf8467000
ath5k 144420 0 - Live 0xf87a4000
mac80211 141261 1 ath5k, Live 0xf8669000
ath 7554 1 ath5k, Live 0xf8419000
snd_seq_dummy 1246 0 - Live 0xf83ea000
cfg80211 127637 3 ath5k,mac80211,ath, Live 0xf84ad000
snd_seq_oss 24103 0 - Live 0xf83d0000
led_class 2306 1 ath5k, Live 0xf8314000
snd_seq_midi_event 5288 1 snd_seq_oss, Live 0xf82fb000
snd_seq 42291 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 0xf83ad000
wlan_scan_sta 11261 1 - Live 0xf82e3000
snd_seq_device 4977 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xf82c3000
ath_rate_sample 11128 1 - Live 0xf82ac000
snd_pcm_oss 32359 0 - Live 0xf8285000
mmc_block 7270 2 - Live 0xf8079000
ath_pci 181720 0 - Live 0xf8044000
snd_pcm 63284 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf8934000
viafb 74240 0 - Live 0xf8902000
snd_timer 16453 2 snd_seq,snd_pcm, Live 0xf88dc000
snd_mixer_oss 12377 1 snd_pcm_oss, Live 0xf88ca000
wlan 206280 7 wlan_tkip,wlan_ccmp,wlan_wep,wlan_scan_sta,ath_rate_sample,ath_pci, Live 0xf8883000
uvcvideo 53423 0 - Live 0xf8831000
ath_hal 298501 3 ath_rate_sample,ath_pci, Live 0xf87cc000 (P)
videodev 34845 1 uvcvideo, Live 0xf876c000
via_sdmmc 6941 0 - Live 0xf8755000
v4l1_compat 12372 2 uvcvideo,videodev, Live 0xf8746000
i2c_algo_bit 4635 1 viafb, Live 0xf8739000
i2c_viapro 5469 0 - Live 0xf872e000
snd 46843 15 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss, Live 0xf8714000
soundcore 5503 1 snd, Live 0xf86fb000
joydev 8037 0 - Live 0xf86ef000
video 16517 0 - Live 0xf86b8000
fan 2775 0 - Live 0xf86a9000
mmc_core 52156 2 mmc_block,via_sdmmc, Live 0xf8690000
serio_raw 3600 0 - Live 0xf8666000
i2c_core 17433 5 drm,viafb,videodev,i2c_algo_bit,i2c_viapro, Live 0xf864e000
snd_page_alloc 6433 2 snd_hda_intel,snd_pcm, Live 0xf863e000
sky2 42414 0 - Live 0xf8621000
rtc_cmos 7611 0 - Live 0xf8609000
output 1585 1 video, Live 0xf85fd000
evdev 7053 19 - Live 0xf85ec000
ac 2450 0 - Live 0xf85e0000
battery 8230 0 - Live 0xf85d4000
button 4373 0 - Live 0xf85b8000
thermal 10555 0 - Live 0xf85aa000
processor 27136 2 acpi_cpufreq, Live 0xf8595000
bluetooth 45996 10 hidp,rfcomm,sco,bnep,l2cap,btusb, Live 0xf8574000
sg 23907 0 - Live 0xf8556000
rfkill 14087 4 cfg80211,bluetooth, Live 0xf8541000
ide_generic 1059 0 [permanent], Live 0xf8533000
ata_generic 2523 0 - Live 0xf852a000
ide_pci_generic 2338 0 - Live 0xf8520000
pata_acpi 2455 0 - Live 0xf8516000
via82cxxx 5137 0 - Live 0xf850b000
ide_gd_mod 21920 0 - Live 0xf84fa000
ide_core 89121 4 ide_generic,ide_pci_generic,via82cxxx,ide_gd_mod, Live 0xf84cf000
pata_via 7132 4 - Live 0xf84a9000
libata 156138 3 ata_generic,pata_acpi,pata_via, Live 0xf846d000
sd_mod 32355 5 - Live 0xf842d000
scsi_mod 136263 3 sg,libata,sd_mod, Live 0xf83f0000
crc_t10dif 1127 1 sd_mod, Live 0xf83bb000
ext4 230145 3 - Live 0xf8372000
jbd2 47853 1 ext4, Live 0xf8316000
crc16 1219 2 l2cap,ext4, Live 0xf82fe000
uhci_hcd 19251 0 - Live 0xf82f0000
ohci_hcd 20047 0 - Live 0xf82dc000
ehci_hcd 32920 0 - Live 0xf82c8000
usbhid 34465 0 - Live 0xf82b0000
hid 63275 2 hidp,usbhid, Live 0xf8290000
usbcore 126905 7 btusb,uvcvideo,uhci_hcd,ohci_hcd,ehci_hcd,usbhid, Live 0xf8257000

--------------090009080804060700030402
Content-Type: text/plain;
 name="iomem"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iomem"

00000000-0000ffff : reserved
00010000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000ce7ff : Video ROM
  000c0000-000c3fff : PCI Bus 0000:00
  000c4000-000c7fff : PCI Bus 0000:00
  000c8000-000cbfff : PCI Bus 0000:00
000ce800-000cf7ff : Adapter ROM
000dc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-6fecffff : System RAM
  00100000-003be101 : Kernel code
  003be102-0052cf47 : Kernel data
  00599000-00603f83 : Kernel bss
6fed0000-6fee2fff : ACPI Tables
6fee3000-6fee3fff : ACPI Non-volatile Storage
6fee4000-7fffffff : reserved
80000000-ffffffff : reserved
  80000000-fff7ffff : PCI Bus 0000:00
    80000000-801fffff : PCI Bus 0000:01
    80200000-803fffff : PCI Bus 0000:02
    80400000-8040ffff : 0000:00:01.0
    d0000000-dfffffff : 0000:00:01.0
      d0000000-d1ffffff : vesafb
    e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
      e0000000-efffffff : reserved
        e0000000-efffffff : pnp 00:01
    f0000000-f3ffffff : 0000:00:01.0
    f4000000-f4ffffff : 0000:00:01.0
    f5000000-f50fffff : PCI Bus 0000:01
      f5000000-f500ffff : 0000:01:00.0
        f5000000-f500ffff : ath
    f5100000-f51fffff : PCI Bus 0000:02
      f5100000-f5103fff : 0000:02:00.0
        f5100000-f5103fff : sky2
    f5400000-f5403fff : 0000:00:14.0
      f5400000-f5403fff : ICH HD audio
    f5404000-f54047ff : 0000:00:0d.0
      f5404000-f54047ff : via_sdmmc
    f5404800-f54048ff : 0000:00:10.4
      f5404800-f54048ff : ehci_hcd
    fe012000-fe013fff : pnp 00:06
    fec00000-fec0ffff : reserved
      fec00000-fec003ff : IOAPIC 0
    fecc0000-fecc03ff : IOAPIC 1
    fed00000-fed003ff : HPET 0
    fed10000-fed100ff : pnp 00:06
    fee00000-fee00fff : Local APIC
      fee00000-fee00fff : reserved
    ffb00000-ffbfffff : pnp 00:06
    ffee0000-ffefffff : pnp 00:06

--------------090009080804060700030402
Content-Type: text/plain;
 name="scsi"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi"

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: SAMSUNG HM160HI  Rev: HH10
  Type:   Direct-Access                    ANSI  SCSI revision: 05

--------------090009080804060700030402
Content-Type: text/plain;
 name="pm-suspend.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="pm-suspend.log"

SW5pdGlhbCBjb21tYW5kbGluZSBwYXJhbWV0ZXJzOiAtLXF1aXJrLWRwbXMtc3VzcGVuZAot
LXF1aXJrLWRwbXMtb24KLS1xdWlyay12YmVzdGF0ZS1yZXN0b3JlCi0tcXVpcmstdmJlbW9k
ZS1yZXN0b3JlCi0tcXVpcmstdmdhLW1vZGUzCi0tcXVpcmstdmJlLXBvc3QKTW9uIEF1ZyAx
NiAwODoyNzo1MiBCU1QgMjAxMDogUnVubmluZyBob29rcyBmb3Igc3VzcGVuZC4KL3Vzci9s
aWIvcG0tdXRpbHMvc2xlZXAuZC8wMGF1dG8tcXVpcmsgc3VzcGVuZCBzdXNwZW5kOiBzdWNj
ZXNzLgovdXNyL2xpYi9wbS11dGlscy9zbGVlcC5kLzAwbG9nZ2luZyBzdXNwZW5kIHN1c3Bl
bmQ6IExpbnV4IGxvY2FsaG9zdC5sb2NhbGRvbWFpbiAyLjYuMzQuMi10bWItbGFwdG9wLTJt
ZHYgIzEgU01QIFN1biBBdWcgMTUgMTM6NTA6MTggVVRDIDIwMTAgaTY4NiBpNjg2IGkzODYg
R05VL0xpbnV4Ck1vZHVsZSAgICAgICAgICAgICAgICAgIFNpemUgIFVzZWQgYnkKaGlkcCAg
ICAgICAgICAgICAgICAgICAxMDY4MiAgMSAKZnVzZSAgICAgICAgICAgICAgICAgICA1NjM2
MiAgMiAKcmZjb21tICAgICAgICAgICAgICAgICAzMDUwOSAgOCAKc2NvICAgICAgICAgICAg
ICAgICAgICAgNzI1MCAgMiAKYnJpZGdlICAgICAgICAgICAgICAgICA1NzcyMSAgMCAKc3Rw
ICAgICAgICAgICAgICAgICAgICAgMTQ3MSAgMSBicmlkZ2UKbGxjICAgICAgICAgICAgICAg
ICAgICAgMzkwNSAgMiBicmlkZ2Usc3RwCmJuZXAgICAgICAgICAgICAgICAgICAgIDg5NDUg
IDIgCmwyY2FwICAgICAgICAgICAgICAgICAgMjkzNzQgIDIxIGhpZHAscmZjb21tLGJuZXAK
YnR1c2IgICAgICAgICAgICAgICAgICAxMDE5NSAgNCAKbmxzX2lzbzg4NTlfMSAgICAgICAg
ICAgMzE4OSAgMSAKbmxzX2NwNDM3ICAgICAgICAgICAgICAgNDg1OSAgMSAKdmZhdCAgICAg
ICAgICAgICAgICAgICAgODE2NSAgMSAKZmF0ICAgICAgICAgICAgICAgICAgICA0NTIwMCAg
MSB2ZmF0CmlwdF9JRldMT0cgICAgICAgICAgICAgIDE4NDYgIDcgCmlwdF9wc2QgICAgICAg
ICAgICAgICAgNDMwMTEgIDEgCmNsc19mbG93ICAgICAgICAgICAgICAgIDU5MzEgIDAgCmNs
c19mdyAgICAgICAgICAgICAgICAgIDMwOTUgIDAgCmNsc191MzIgICAgICAgICAgICAgICAg
IDUyNTQgIDAgCnNjaF9odGIgICAgICAgICAgICAgICAgMTMwMzYgIDAgCnNjaF9oZnNjICAg
ICAgICAgICAgICAgMTYwNjkgIDAgCnNjaF9pbmdyZXNzICAgICAgICAgICAgIDEzNjYgIDAg
CnNjaF9zZnEgICAgICAgICAgICAgICAgIDQ2OTkgIDAgCnh0X3RpbWUgICAgICAgICAgICAg
ICAgIDE3NDUgIDAgCndsYW5fY2NtcCAgICAgICAgICAgICAgIDU3NDMgIDIgCnh0X2Nvbm5s
aW1pdCAgICAgICAgICAgIDI1NjAgIDAgCnh0X3JlYWxtICAgICAgICAgICAgICAgICA2ODYg
IDAgCmlwdGFibGVfcmF3ICAgICAgICAgICAgIDEwNTggIDAgCnh0X2NvbW1lbnQgICAgICAg
ICAgICAgICA2NjAgIDE4IAp4dF9yZWNlbnQgICAgICAgICAgICAgICA3MjYwICAwIAp4dF9w
b2xpY3kgICAgICAgICAgICAgICAyMDk4ICAwIAppcHRfVUxPRyAgICAgICAgICAgICAgICA1
MTUwICAwIAppcHRfUkVKRUNUICAgICAgICAgICAgICAxOTA1ICA0IAppcHRfUkVESVJFQ1Qg
ICAgICAgICAgICAgODg5ICAwIAppcHRfTkVUTUFQICAgICAgICAgICAgICAgODgxICAwIApp
cHRfTUFTUVVFUkFERSAgICAgICAgICAxMzE1ICAwIAppcHRfRUNOICAgICAgICAgICAgICAg
ICAxNDc3ICAwIAppcHRfZWNuICAgICAgICAgICAgICAgICAxMDkzICAwIAppcHRfQ0xVU1RF
UklQICAgICAgICAgICA0NTc5ICAwIAppcHRfYWggICAgICAgICAgICAgICAgICAgODMzICAw
IAppcHRfYWRkcnR5cGUgICAgICAgICAgICAxNTA3ICAyIApuZl9uYXRfdGZ0cCAgICAgICAg
ICAgICAgNjI0ICAwIApuZl9uYXRfc25tcF9iYXNpYyAgICAgICA3MDg1ICAwIApuZl9uYXRf
c2lwICAgICAgICAgICAgICA1MTgyICAwIApuZl9uYXRfcHB0cCAgICAgICAgICAgICAxODYw
ICAwIApuZl9uYXRfcHJvdG9fZ3JlICAgICAgICAxMTU3ICAxIG5mX25hdF9wcHRwCm5mX25h
dF9pcmMgICAgICAgICAgICAgIDEwMzIgIDAgCm5mX25hdF9oMzIzICAgICAgICAgICAgIDQ3
OTMgIDAgCm5mX25hdF9mdHAgICAgICAgICAgICAgIDEyOTQgIDAgCm5mX25hdF9hbWFuZGEg
ICAgICAgICAgICA3ODYgIDAgCnRzX2ttcCAgICAgICAgICAgICAgICAgIDE1MzcgIDUgCm5m
X2Nvbm50cmFja19hbWFuZGEgICAgIDIwODAgIDEgbmZfbmF0X2FtYW5kYQpuZl9jb25udHJh
Y2tfc2FuZSAgICAgICAzMDUxICAwIApuZl9jb25udHJhY2tfdGZ0cCAgICAgICAyODIyICAx
IG5mX25hdF90ZnRwCm5mX2Nvbm50cmFja19zaXAgICAgICAgMTY5NDEgIDEgbmZfbmF0X3Np
cApuZl9jb25udHJhY2tfcHJvdG9fc2N0cCAgICAgNjIwNCAgMCAKbmZfY29ubnRyYWNrX3Bw
dHAgICAgICAgNDE3OSAgMSBuZl9uYXRfcHB0cApuZl9jb25udHJhY2tfcHJvdG9fZ3JlICAg
ICAzNDU4ICAxIG5mX2Nvbm50cmFja19wcHRwCm5mX2Nvbm50cmFja19uZXRsaW5rICAgIDE0
NTY4ICAwIApuZl9jb25udHJhY2tfbmV0Ymlvc19ucyAgICAgMTIyNiAgMCAKbmZfY29ubnRy
YWNrX2lyYyAgICAgICAgMzIzNCAgMSBuZl9uYXRfaXJjCm5mX2Nvbm50cmFja19oMzIzICAg
ICAgNDUyMTYgIDEgbmZfbmF0X2gzMjMKbmZfY29ubnRyYWNrX2Z0cCAgICAgICAgNTIxNSAg
MSBuZl9uYXRfZnRwCmlwdF9zZXQgICAgICAgICAgICAgICAgIDEwODMgIDIgCmlwdF9TRVQg
ICAgICAgICAgICAgICAgIDEyNDMgIDAgCmlwX3NldF9uZXRoYXNoICAgICAgICAgIDcwOTcg
IDAgCmlwX3NldF9pcHRyZWVtYXAgICAgICAgIDc0ODAgIDAgCmlwX3NldF9pcHRyZWUgICAg
ICAgICAgIDQ1NzcgIDIgCmlwX3NldF9pcHBvcnRoYXNoICAgICAgIDYxNjIgIDAgCmlwX3Nl
dF9wb3J0bWFwICAgICAgICAgIDI4NTAgIDAgCmlwX3NldF9tYWNpcG1hcCAgICAgICAgIDI3
MDQgIDAgCmlwX3NldF9pcG1hcCAgICAgICAgICAgIDI2OTQgIDAgCmlwX3NldF9pcGhhc2gg
ICAgICAgICAgIDU0ODcgIDAgCmlwX3NldCAgICAgICAgICAgICAgICAgMTIxNTcgIDE4IGlw
dF9zZXQsaXB0X1NFVCxpcF9zZXRfbmV0aGFzaCxpcF9zZXRfaXB0cmVlbWFwLGlwX3NldF9p
cHRyZWUsaXBfc2V0X2lwcG9ydGhhc2gsaXBfc2V0X3BvcnRtYXAsaXBfc2V0X21hY2lwbWFw
LGlwX3NldF9pcG1hcCxpcF9zZXRfaXBoYXNoCnh0X1RQUk9YWSAgICAgICAgICAgICAgIDEx
MzcgIDAgCm5mX3Rwcm94eV9jb3JlICAgICAgICAgIDEzODggIDEgeHRfVFBST1hZLFtwZXJt
YW5lbnRdCnh0X3RjcG1zcyAgICAgICAgICAgICAgIDEwNzMgIDAgCnh0X3BrdHR5cGUgICAg
ICAgICAgICAgICA3ODggIDAgCnh0X3BoeXNkZXYgICAgICAgICAgICAgIDE0NDcgIDAgCnh0
X293bmVyICAgICAgICAgICAgICAgICA4NzggIDIgCnh0X05GUVVFVUUgICAgICAgICAgICAg
IDE3NDMgIDAgCnh0X05GTE9HICAgICAgICAgICAgICAgICA4MTMgIDAgCm5mbmV0bGlua19s
b2cgICAgICAgICAgIDY2ODQgIDEgeHRfTkZMT0cKeHRfbXVsdGlwb3J0ICAgICAgICAgICAg
MjE1OCAgNiAKeHRfTUFSSyAgICAgICAgICAgICAgICAgIDY4MyAgMSAKeHRfbWFyayAgICAg
ICAgICAgICAgICAgIDY4MyAgMCAKeHRfbWFjICAgICAgICAgICAgICAgICAgIDc0NCAgMCAK
eHRfbGltaXQgICAgICAgICAgICAgICAgMTIyNiAgMCAKeHRfbGVuZ3RoICAgICAgICAgICAg
ICAgIDg0NCAgMCAKeHRfaXByYW5nZSAgICAgICAgICAgICAgMTI2NSAgMCAKeHRfaGVscGVy
ICAgICAgICAgICAgICAgMTAxMSAgMCAKeHRfaGFzaGxpbWl0ICAgICAgICAgICAgNzk0NSAg
MCAKeHRfRFNDUCAgICAgICAgICAgICAgICAgMTU4NSAgMCAKeHRfZHNjcCAgICAgICAgICAg
ICAgICAgMTIwOSAgMCAKeHRfZGNjcCAgICAgICAgICAgICAgICAgMTcwNSAgMCAKeHRfY29u
bnRyYWNrICAgICAgICAgICAgMjE3OCAgMTIgCnh0X0NPTk5NQVJLICAgICAgICAgICAgIDEw
ODUgIDAgCnh0X2Nvbm5tYXJrICAgICAgICAgICAgICA4OTMgIDAgCnh0X0NMQVNTSUZZICAg
ICAgICAgICAgICA2OTUgIDAgCmlwdF9MT0cgICAgICAgICAgICAgICAgIDQ0MTggIDUgCnh0
X3RjcHVkcCAgICAgICAgICAgICAgIDE4ODcgIDE4IAp4dF9zdGF0ZSAgICAgICAgICAgICAg
ICAxMDA2ICA2IAppcHRhYmxlX25hdCAgICAgICAgICAgICAzNDg4ICAxIApuZl9uYXQgICAg
ICAgICAgICAgICAgIDE0NTExICAxMiBpcHRfUkVESVJFQ1QsaXB0X05FVE1BUCxpcHRfTUFT
UVVFUkFERSxuZl9uYXRfdGZ0cCxuZl9uYXRfc2lwLG5mX25hdF9wcHRwLG5mX25hdF9wcm90
b19ncmUsbmZfbmF0X2lyYyxuZl9uYXRfaDMyMyxuZl9uYXRfZnRwLG5mX25hdF9hbWFuZGEs
aXB0YWJsZV9uYXQKbmZfY29ubnRyYWNrX2lwdjQgICAgICAxMDE5NyAgMjEgaXB0YWJsZV9u
YXQsbmZfbmF0Cm5mX2RlZnJhZ19pcHY0ICAgICAgICAgICA5OTcgIDIgeHRfVFBST1hZLG5m
X2Nvbm50cmFja19pcHY0Cm5mX2Nvbm50cmFjayAgICAgICAgICAgNTcyMjggIDMxIHh0X2Nv
bm5saW1pdCxpcHRfTUFTUVVFUkFERSxpcHRfQ0xVU1RFUklQLG5mX25hdF90ZnRwLG5mX25h
dF9zbm1wX2Jhc2ljLG5mX25hdF9zaXAsbmZfbmF0X3BwdHAsbmZfbmF0X2lyYyxuZl9uYXRf
aDMyMyxuZl9uYXRfZnRwLG5mX25hdF9hbWFuZGEsbmZfY29ubnRyYWNrX2FtYW5kYSxuZl9j
b25udHJhY2tfc2FuZSxuZl9jb25udHJhY2tfdGZ0cCxuZl9jb25udHJhY2tfc2lwLG5mX2Nv
bm50cmFja19wcm90b19zY3RwLG5mX2Nvbm50cmFja19wcHRwLG5mX2Nvbm50cmFja19wcm90
b19ncmUsbmZfY29ubnRyYWNrX25ldGxpbmssbmZfY29ubnRyYWNrX25ldGJpb3NfbnMsbmZf
Y29ubnRyYWNrX2lyYyxuZl9jb25udHJhY2tfaDMyMyxuZl9jb25udHJhY2tfZnRwLHh0X2hl
bHBlcix4dF9jb25udHJhY2sseHRfQ09OTk1BUksseHRfY29ubm1hcmsseHRfc3RhdGUsaXB0
YWJsZV9uYXQsbmZfbmF0LG5mX2Nvbm50cmFja19pcHY0CmlwdGFibGVfbWFuZ2xlICAgICAg
ICAgIDEyNjcgIDEgCm5mbmV0bGluayAgICAgICAgICAgICAgIDMwNjggIDIgbmZfY29ubnRy
YWNrX25ldGxpbmssbmZuZXRsaW5rX2xvZwp2aWEgICAgICAgICAgICAgICAgICAgIDM3NTQ0
ICAwIApkcm0gICAgICAgICAgICAgICAgICAgMTUwNzM0ICAxIHZpYQppcHRhYmxlX2ZpbHRl
ciAgICAgICAgICAxMjMwICAxIAppcF90YWJsZXMgICAgICAgICAgICAgICA5NzA5ICA0IGlw
dGFibGVfcmF3LGlwdGFibGVfbmF0LGlwdGFibGVfbWFuZ2xlLGlwdGFibGVfZmlsdGVyCnhf
dGFibGVzICAgICAgICAgICAgICAgMTI1NDUgIDUxIGlwdF9JRldMT0csaXB0X3BzZCx4dF90
aW1lLHh0X2Nvbm5saW1pdCx4dF9yZWFsbSxpcHRhYmxlX3Jhdyx4dF9jb21tZW50LHh0X3Jl
Y2VudCx4dF9wb2xpY3ksaXB0X1VMT0csaXB0X1JFSkVDVCxpcHRfUkVESVJFQ1QsaXB0X05F
VE1BUCxpcHRfTUFTUVVFUkFERSxpcHRfRUNOLGlwdF9lY24saXB0X0NMVVNURVJJUCxpcHRf
YWgsaXB0X2FkZHJ0eXBlLGlwdF9zZXQsaXB0X1NFVCx4dF9UUFJPWFkseHRfdGNwbXNzLHh0
X3BrdHR5cGUseHRfcGh5c2Rldix4dF9vd25lcix4dF9ORlFVRVVFLHh0X05GTE9HLHh0X211
bHRpcG9ydCx4dF9NQVJLLHh0X21hcmsseHRfbWFjLHh0X2xpbWl0LHh0X2xlbmd0aCx4dF9p
cHJhbmdlLHh0X2hlbHBlcix4dF9oYXNobGltaXQseHRfRFNDUCx4dF9kc2NwLHh0X2RjY3As
eHRfY29ubnRyYWNrLHh0X0NPTk5NQVJLLHh0X2Nvbm5tYXJrLHh0X0NMQVNTSUZZLGlwdF9M
T0cseHRfdGNwdWRwLHh0X3N0YXRlLGlwdGFibGVfbmF0LGlwdGFibGVfbWFuZ2xlLGlwdGFi
bGVfZmlsdGVyLGlwX3RhYmxlcwpuZnNkICAgICAgICAgICAgICAgICAgMjI5MDA1ICAxMSAK
bG9ja2QgICAgICAgICAgICAgICAgICA2MTU2MSAgMSBuZnNkCm5mc19hY2wgICAgICAgICAg
ICAgICAgIDIwNzMgIDEgbmZzZAphdXRoX3JwY2dzcyAgICAgICAgICAgIDMwMTE3ICAxIG5m
c2QKc3VucnBjICAgICAgICAgICAgICAgIDE3MzQ0OCAgMTUgbmZzZCxsb2NrZCxuZnNfYWNs
LGF1dGhfcnBjZ3NzCmV4cG9ydGZzICAgICAgICAgICAgICAgIDMwOTUgIDEgbmZzZApkZWZs
YXRlICAgICAgICAgICAgICAgICAxNTUxICAwIAp6bGliX2RlZmxhdGUgICAgICAgICAgIDE4
ODk1ICAxIGRlZmxhdGUKY3RyICAgICAgICAgICAgICAgICAgICAgMjkxMyAgMCAKdHdvZmlz
aCAgICAgICAgICAgICAgICAgNTM5MSAgMCAKdHdvZmlzaF9jb21tb24gICAgICAgICAxMjY5
OSAgMSB0d29maXNoCmNhbWVsbGlhICAgICAgICAgICAgICAgMTc3OTIgIDAgCnNlcnBlbnQg
ICAgICAgICAgICAgICAgMTczOTMgIDAgCmJsb3dmaXNoICAgICAgICAgICAgICAgIDcyNDYg
IDAgCmNhc3Q1ICAgICAgICAgICAgICAgICAgMTU0NTIgIDAgCmRlc19nZW5lcmljICAgICAg
ICAgICAgMTU4MzUgIDAgCmNiYyAgICAgICAgICAgICAgICAgICAgIDIxNDEgIDAgCnhjYmMg
ICAgICAgICAgICAgICAgICAgIDIwNjcgIDAgCnJtZDE2MCAgICAgICAgICAgICAgICAgIDYy
NzYgIDAgCnNoYTUxMl9nZW5lcmljICAgICAgICAgIDcxMjggIDAgCmNyeXB0b19udWxsICAg
ICAgICAgICAgIDIxMzggIDAgCmFmX2tleSAgICAgICAgICAgICAgICAgMjUwMzcgIDIgCmlw
Y29tcCAgICAgICAgICAgICAgICAgIDE2MTkgIDAgCnhmcm1faXBjb21wICAgICAgICAgICAg
IDMzODIgIDEgaXBjb21wCnR1biAgICAgICAgICAgICAgICAgICAgMTIyNzggIDAgCmFoNCAg
ICAgICAgICAgICAgICAgICAgIDM5ODMgIDAgCmVzcDQgICAgICAgICAgICAgICAgICAgIDQx
NzQgIDAgCmFmX3BhY2tldCAgICAgICAgICAgICAgMTYxNDIgIDYgCndsYW5fd2VwICAgICAg
ICAgICAgICAgIDQ3NjEgIDAgCmlwdjYgICAgICAgICAgICAgICAgICAyNTA1MjQgIDQ4IApj
cHVmcmVxX29uZGVtYW5kICAgICAgICA3ODYyICAwIAp3bGFuX3NjYW5fc3RhICAgICAgICAg
IDExMjYxICAxIAphdGhfcmF0ZV9zYW1wbGUgICAgICAgIDExMTI4ICAxIAphdGhfcGNpICAg
ICAgICAgICAgICAgMTgxNzIwICAwIAp3bGFuICAgICAgICAgICAgICAgICAgMjA2MjgwICA2
IHdsYW5fY2NtcCx3bGFuX3dlcCx3bGFuX3NjYW5fc3RhLGF0aF9yYXRlX3NhbXBsZSxhdGhf
cGNpCmF0aF9oYWwgICAgICAgICAgICAgICAyOTg1MDEgIDMgYXRoX3JhdGVfc2FtcGxlLGF0
aF9wY2kKYmluZm10X21pc2MgICAgICAgICAgICAgNjE0OSAgMSAKbG9vcCAgICAgICAgICAg
ICAgICAgICAxMjI2OSAgMCAKZG1fbW9kICAgICAgICAgICAgICAgICA1NzY1NyAgMCAKc2hh
MjU2X2dlbmVyaWMgICAgICAgICAxMTEzMSAgMCAKc2hhMV9nZW5lcmljICAgICAgICAgICAg
MTY5MSAgMCAKcGFkbG9ja19zaGEgICAgICAgICAgICAgMzExMyAgMCAKcGFkbG9ja19hZXMg
ICAgICAgICAgICAgNDQ4MSAgMCAKYWVzX2dlbmVyaWMgICAgICAgICAgICAyNjQ1NiAgMSBw
YWRsb2NrX2FlcwpudnJhbSAgICAgICAgICAgICAgICAgICA1MjM1ICAwIApwY3Nwa3IgICAg
ICAgICAgICAgICAgICAxNDI2ICAwIAphY3BpX2NwdWZyZXEgICAgICAgICAgICA1NzIzICAx
IApmcmVxX3RhYmxlICAgICAgICAgICAgICAyODc5ICAyIGNwdWZyZXFfb25kZW1hbmQsYWNw
aV9jcHVmcmVxCnNuZF9oZGFfY29kZWNfcmVhbHRlayAgIDIxMTgxMSAgMSAKc25kX2hkYV9p
bnRlbCAgICAgICAgICAyMDEyNSAgMiAKc25kX2hkYV9jb2RlYyAgICAgICAgICA3NzIyMyAg
MiBzbmRfaGRhX2NvZGVjX3JlYWx0ZWssc25kX2hkYV9pbnRlbApzbmRfaHdkZXAgICAgICAg
ICAgICAgICA0OTI4ICAxIHNuZF9oZGFfY29kZWMKc25kX3NlcV9kdW1teSAgICAgICAgICAg
MTI0NiAgMCAKc25kX3NlcV9vc3MgICAgICAgICAgICAyNDEwMyAgMCAKc25kX3NlcV9taWRp
X2V2ZW50ICAgICAgNTI4OCAgMSBzbmRfc2VxX29zcwpzbmRfc2VxICAgICAgICAgICAgICAg
IDQyMjkxICA1IHNuZF9zZXFfZHVtbXksc25kX3NlcV9vc3Msc25kX3NlcV9taWRpX2V2ZW50
CnNuZF9zZXFfZGV2aWNlICAgICAgICAgIDQ5NzcgIDMgc25kX3NlcV9kdW1teSxzbmRfc2Vx
X29zcyxzbmRfc2VxCnNuZF9wY21fb3NzICAgICAgICAgICAgMzIzNTkgIDAgCnNuZF9wY20g
ICAgICAgICAgICAgICAgNjMyODQgIDMgc25kX2hkYV9pbnRlbCxzbmRfaGRhX2NvZGVjLHNu
ZF9wY21fb3NzCnNuZF90aW1lciAgICAgICAgICAgICAgMTY0NTMgIDIgc25kX3NlcSxzbmRf
cGNtCm1tY19ibG9jayAgICAgICAgICAgICAgIDcyNzAgIDIgCnV2Y3ZpZGVvICAgICAgICAg
ICAgICAgNTM0MjMgIDAgCnZpZGVvZGV2ICAgICAgICAgICAgICAgMzQ4NDUgIDEgdXZjdmlk
ZW8Kc25kX21peGVyX29zcyAgICAgICAgICAxMjM3NyAgMSBzbmRfcGNtX29zcwp2aWFmYiAg
ICAgICAgICAgICAgICAgIDc0MjQwICAwIAppMmNfYWxnb19iaXQgICAgICAgICAgICA0NjM1
ICAxIHZpYWZiCnNuZCAgICAgICAgICAgICAgICAgICAgNDY4NDMgIDE1IHNuZF9oZGFfY29k
ZWNfcmVhbHRlayxzbmRfaGRhX2ludGVsLHNuZF9oZGFfY29kZWMsc25kX2h3ZGVwLHNuZF9z
ZXFfb3NzLHNuZF9zZXEsc25kX3NlcV9kZXZpY2Usc25kX3BjbV9vc3Msc25kX3BjbSxzbmRf
dGltZXIsc25kX21peGVyX29zcwpibHVldG9vdGggICAgICAgICAgICAgIDQ1OTk2ICAxMCBo
aWRwLHJmY29tbSxzY28sYm5lcCxsMmNhcCxidHVzYgpqb3lkZXYgICAgICAgICAgICAgICAg
ICA4MDM3ICAwIAp2aWFfc2RtbWMgICAgICAgICAgICAgICA2OTQxICAwIApzb3VuZGNvcmUg
ICAgICAgICAgICAgICA1NTAzICAxIHNuZAppMmNfdmlhcHJvICAgICAgICAgICAgICA1NDY5
ICAwIApmYW4gICAgICAgICAgICAgICAgICAgICAyNzc1ICAwIAp2NGwxX2NvbXBhdCAgICAg
ICAgICAgIDEyMzcyICAyIHV2Y3ZpZGVvLHZpZGVvZGV2CnZpZGVvICAgICAgICAgICAgICAg
ICAgMTY1MTcgIDAgCnNuZF9wYWdlX2FsbG9jICAgICAgICAgIDY0MzMgIDIgc25kX2hkYV9p
bnRlbCxzbmRfcGNtCnJ0Y19jbW9zICAgICAgICAgICAgICAgIDc2MTEgIDAgCm1tY19jb3Jl
ICAgICAgICAgICAgICAgNTIxNTYgIDIgbW1jX2Jsb2NrLHZpYV9zZG1tYwppMmNfY29yZSAg
ICAgICAgICAgICAgIDE3NDMzICA1IGRybSx2aWRlb2Rldix2aWFmYixpMmNfYWxnb19iaXQs
aTJjX3ZpYXBybwpyZmtpbGwgICAgICAgICAgICAgICAgIDE0MDg3ICAzIGJsdWV0b290aAph
YyAgICAgICAgICAgICAgICAgICAgICAyNDUwICAwIApza3kyICAgICAgICAgICAgICAgICAg
IDQyNDE0ICAwIApvdXRwdXQgICAgICAgICAgICAgICAgICAxNTg1ICAxIHZpZGVvCmV2ZGV2
ICAgICAgICAgICAgICAgICAgIDcwNTMgIDE1IApiYXR0ZXJ5ICAgICAgICAgICAgICAgICA4
MjMwICAwIAp0aGVybWFsICAgICAgICAgICAgICAgIDEwNTU1ICAwIApzZyAgICAgICAgICAg
ICAgICAgICAgIDIzOTA3ICAwIApzZXJpb19yYXcgICAgICAgICAgICAgICAzNjAwICAwIApi
dXR0b24gICAgICAgICAgICAgICAgICA0MzczICAwIApwcm9jZXNzb3IgICAgICAgICAgICAg
IDI3MTM2ICAyIGFjcGlfY3B1ZnJlcQppZGVfZ2VuZXJpYyAgICAgICAgICAgICAxMDU5ICAw
IFtwZXJtYW5lbnRdCmF0YV9nZW5lcmljICAgICAgICAgICAgIDI1MjMgIDAgCmlkZV9wY2lf
Z2VuZXJpYyAgICAgICAgIDIzMzggIDAgCnBhdGFfYWNwaSAgICAgICAgICAgICAgIDI0NTUg
IDAgCnZpYTgyY3h4eCAgICAgICAgICAgICAgIDUxMzcgIDAgCmlkZV9nZF9tb2QgICAgICAg
ICAgICAgMjE5MjAgIDAgCmlkZV9jb3JlICAgICAgICAgICAgICAgODkxMjEgIDQgaWRlX2dl
bmVyaWMsaWRlX3BjaV9nZW5lcmljLHZpYTgyY3h4eCxpZGVfZ2RfbW9kCnBhdGFfdmlhICAg
ICAgICAgICAgICAgIDcxMzIgIDQgCmxpYmF0YSAgICAgICAgICAgICAgICAxNTYxMzggIDMg
YXRhX2dlbmVyaWMscGF0YV9hY3BpLHBhdGFfdmlhCnNkX21vZCAgICAgICAgICAgICAgICAg
MzIzNTUgIDUgCnNjc2lfbW9kICAgICAgICAgICAgICAxMzYyNjMgIDMgc2csbGliYXRhLHNk
X21vZApjcmNfdDEwZGlmICAgICAgICAgICAgICAxMTI3ICAxIHNkX21vZApleHQ0ICAgICAg
ICAgICAgICAgICAgMjMwMTQ1ICAzIApqYmQyICAgICAgICAgICAgICAgICAgIDQ3ODUzICAx
IGV4dDQKY3JjMTYgICAgICAgICAgICAgICAgICAgMTIxOSAgMiBsMmNhcCxleHQ0CnVoY2lf
aGNkICAgICAgICAgICAgICAgMTkyNTEgIDAgCm9oY2lfaGNkICAgICAgICAgICAgICAgMjAw
NDcgIDAgCmVoY2lfaGNkICAgICAgICAgICAgICAgMzI5MjAgIDAgCnVzYmhpZCAgICAgICAg
ICAgICAgICAgMzQ0NjUgIDAgCmhpZCAgICAgICAgICAgICAgICAgICAgNjMyNzUgIDIgaGlk
cCx1c2JoaWQKdXNiY29yZSAgICAgICAgICAgICAgIDEyNjkwNSAgNyBidHVzYix1dmN2aWRl
byx1aGNpX2hjZCxvaGNpX2hjZCxlaGNpX2hjZCx1c2JoaWQKICAgICAgICAgICAgIHRvdGFs
ICAgICAgIHVzZWQgICAgICAgZnJlZSAgICAgc2hhcmVkICAgIGJ1ZmZlcnMgICAgIGNhY2hl
ZApNZW06ICAgICAgIDE4MTMzODAgICAgMTI3ODMzNiAgICAgNTM1MDQ0ICAgICAgICAgIDAg
ICAgICA3MzE5MiAgICAgODQ1NjA4Ci0vKyBidWZmZXJzL2NhY2hlOiAgICAgMzU5NTM2ICAg
IDE0NTM4NDQKU3dhcDogICAgICAyMDQ3NzE2ICAgICAgICAgIDAgICAgMjA0NzcxNgpzdWNj
ZXNzLgovdXNyL2xpYi9wbS11dGlscy9zbGVlcC5kLzAwcG93ZXJzYXZlIHN1c3BlbmQgc3Vz
cGVuZDogc3VjY2Vzcy4KL3Vzci9saWIvcG0tdXRpbHMvc2xlZXAuZC8wMWJvb3Rsb2FkZXIg
c3VzcGVuZCBzdXNwZW5kOiBzdWNjZXNzLgovdXNyL2xpYi9wbS11dGlscy9zbGVlcC5kLzA2
bXlzcWxkIHN1c3BlbmQgc3VzcGVuZDogWyAgT0sgIF0NU2h1dHRpbmcgZG93biBNeVNRTDog
Li4uLi5bICBPSyAgXQ0Kc3VjY2Vzcy4KL3Vzci9saWIvcG0tdXRpbHMvc2xlZXAuZC8xMG5l
dHdvcmsgc3VzcGVuZCBzdXNwZW5kOiBDb25maWd1cmVkIENJRlMgbW91bnRwb2ludHM6IAov
bW50L09TWC1EQVRBCkNhbm5vdCBmaW5kIG5mcyBzZXJ2aWNlCkNvbmZpZ3VyZWQgZGV2aWNl
czoKbG8gYXRoMCBldGgwIHBwcDAgdXNiMgpDdXJyZW50bHkgYWN0aXZlIGRldmljZXM6Cmxv
IGV0aDAgd2lmaTAgYXRoMCBwYW4wClNodXR0aW5nIGRvd24gaW50ZXJmYWNlIGF0aDA6ICBS
ZWxvYWRpbmcgdm5zdGF0ZCBjb25maWd1cmF0aW9uOiBbICBPSyAgXQ0KWyAgT0sgIF0NClNo
dXR0aW5nIGRvd24gaW50ZXJmYWNlIGV0aDA6ICBSZWxvYWRpbmcgdm5zdGF0ZCBjb25maWd1
cmF0aW9uOiBbICBPSyAgXQ0KWyAgT0sgIF0NClNodXR0aW5nIGRvd24gbG9vcGJhY2sgaW50
ZXJmYWNlOiAgWyAgT0sgIF0NCkRpc2FibGluZyBJUHY0IHBhY2tldCBmb3J3YXJkaW5nOiAg
WyAgT0sgIF0NCnN1Y2Nlc3MuCi91c3IvbGliL3BtLXV0aWxzL3NsZWVwLmQvMTVzb3VuZCBz
dXNwZW5kIHN1c3BlbmQ6IHN1Y2Nlc3MuCi91c3IvbGliL3BtLXV0aWxzL3NsZWVwLmQvMzBw
Y21jaWEgc3VzcGVuZCBzdXNwZW5kOiBzdWNjZXNzLgovdXNyL2xpYi9wbS11dGlscy9zbGVl
cC5kLzQweGxvY2sgc3VzcGVuZCBzdXNwZW5kOiBzdWNjZXNzLgovdXNyL2xpYi9wbS11dGls
cy9zbGVlcC5kLzQ5Ymx1ZXRvb3RoIHN1c3BlbmQgc3VzcGVuZDogbm90IGFwcGxpY2FibGUu
Ci91c3IvbGliL3BtLXV0aWxzL3NsZWVwLmQvNTVOZXR3b3JrTWFuYWdlciBzdXNwZW5kIHN1
c3BlbmQ6IHN1Y2Nlc3MuCi91c3IvbGliL3BtLXV0aWxzL3NsZWVwLmQvNzVtb2R1bGVzIHN1
c3BlbmQgc3VzcGVuZDogc3VjY2Vzcy4KL3Vzci9saWIvcG0tdXRpbHMvc2xlZXAuZC85MGNs
b2NrIHN1c3BlbmQgc3VzcGVuZDogbm90IGFwcGxpY2FibGUuCi91c3IvbGliL3BtLXV0aWxz
L3NsZWVwLmQvOTFsYXB0b3AtbW9kZSBzdXNwZW5kIHN1c3BlbmQ6IHN1Y2Nlc3MuCi91c3Iv
bGliL3BtLXV0aWxzL3NsZWVwLmQvOTJkaXNrIHN1c3BlbmQgc3VzcGVuZDogc3VjY2Vzcy4K
L3Vzci9saWIvcG0tdXRpbHMvc2xlZXAuZC85NGNwdWZyZXEgc3VzcGVuZCBzdXNwZW5kOiBz
dWNjZXNzLgovdXNyL2xpYi9wbS11dGlscy9zbGVlcC5kLzk1bGVkIHN1c3BlbmQgc3VzcGVu
ZDogbm90IGFwcGxpY2FibGUuCi91c3IvbGliL3BtLXV0aWxzL3NsZWVwLmQvOThzbWFydC1r
ZXJuZWwtdmlkZW8gc3VzcGVuZCBzdXNwZW5kOiBub3QgYXBwbGljYWJsZS4KL3Vzci9saWIv
cG0tdXRpbHMvc2xlZXAuZC85OWxhcHRvcC1tb2RlIHN1c3BlbmQgc3VzcGVuZDogc3VjY2Vz
cy4KL3Vzci9saWIvcG0tdXRpbHMvc2xlZXAuZC85OXZpZGVvIHN1c3BlbmQgc3VzcGVuZDog
QWxsb2NhdGVkIGJ1ZmZlciBhdCAweDIwMTAgKGJhc2UgaXMgMHgwKQpFUzogMHgwMjAxIEVC
WDogMHgwMDAwCnN1Y2Nlc3MuCk1vbiBBdWcgMTYgMDg6Mjg6MTkgQlNUIDIwMTA6IHBlcmZv
cm1pbmcgc3VzcGVuZAo=
--------------090009080804060700030402--
