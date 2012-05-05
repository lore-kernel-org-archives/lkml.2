Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2EEQUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 12:20:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60028 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab2EEQUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 12:20:18 -0400
X-Envelope-From: stefan@lucke.in-berlin.de
Message-ID: <20120505182016.18488a9xt3ql33uo@webmail.in-berlin.de>
Date: Sat, 05 May 2012 18:20:16 +0200
From: "Stefan Lucke" <stefan@lucke.in-berlin.de>
To: linux-kernel@vger.kernel.org
Cc: stefan@lucke.in-berlin.de
Subject: drm:i915_hangcheck_elapsed with kernel 3.3.4
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_7ggm6kwbefy7"
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) 4.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--=_7ggm6kwbefy7
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I'm experinencing a serious issue when trying to get hardware assisted
video decoding to work.
Trouble starts with:
May  5 13:14:32 jarada kernel: [  501.788377] =20
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
May  5 13:14:32 jarada kernel: [  501.788386] [drm] capturing error =20
event; look for more information in /debug/dri/0/i915_error_state
May  5 13:14:32 jarada kernel: [  501.794113] [drm:i915_wait_request] =20
*ERROR* i915_wait_request returns -11 (awaiting 158166 at 0, next =20
158169)

Display goes black and keyboard input is ignored for a while.

CPU:i3-2120
MB:Asrock H67M-GE/HT
libva 0.34 (Intel i965 driver - 1.0.16.pre1)

from Xorg0.log:
X.Org X Server 1.12.0
Release Date: 2012-03-04
[    26.100] X Protocol Version 11, Revision 0
[    26.100] Build Operating System: Linux 3.3.4-gt-2 x86_64 Gentoo

[    26.609] (II) intel(0): Integrated Graphics Chipset: Intel(R) =20
Sandybridge Desktop (GT1)
[    26.609] (--) intel(0): Chipset: "Sandybridge Desktop (GT1)"

[    28.923] (II) intel(0): SNA initialized with SandyBridge backend


This happens direct after start of the video decoding application.
Is this a known or already fixed issue with newer 3.4.x kernel?
Should I provide more infos or ask on another list?

Discussion thread (in german) with log examples:
http://www.vdr-portal.de/board17-developer/board21-vdr-plugins/112606-softhd=
device-segfault-bei-hd-sendern/

My last post:
http://www.vdr-portal.de/board17-developer/board21-vdr-plugins/p1069913-soft=
hddevice-segfault-bei-hd-sendern/#post1069913

Please cc me in replays as I'm not subscribed to this list

Greetings
Stefan Lucke
--=_7ggm6kwbefy7
Content-Type: text/plain;
	charset=ISO-8859-1;
	name="start_of_i915_error_state.txt"
Content-Disposition: attachment;
	filename="start_of_i915_error_state.txt"
Content-Transfer-Encoding: quoted-printable


PCI ID: 0x0102
EIR: 0x00000000
PGTBL_ER: 0x00000000
ERROR: 0x00000000
Blitter command stream:
  ACTHD:    0x37210330
  IPEIR:    0x00000000
  IPEHR:    0x01000000
  INSTDONE: 0xfffffffe
  seqno:    0x001411e3
Video (BSD) command stream:
  ACTHD:    0x0765f448
  IPEIR:    0x00000008
  IPEHR:    0x73280003
  INSTDONE: 0xffa5ce7f
  seqno:    0x0014119a
Render command stream:
  ACTHD: 0x91a05218
  IPEIR: 0x00000000
  IPEHR: 0x7a000003
  INSTDONE: 0xfffffffe
  INSTDONE1: 0xffffffff
  INSTPS: 0x00000000
  INSTPM: 0x00000080
  seqno: 0x001411e1
  fence[0] =3D 2c3603b0240a001
  fence[1] =3D e8a802f0e0c0001
  fence[2] =3D f0fa0230e912001
  fence[3] =3D fe1302f0f7c0001
  fence[4] =3D 453103b03bc3001
  fence[5] =3D c06e02f0ba1b001
  fence[6] =3D a6c30130a404001
  fence[7] =3D 8cac01308c30001
  fence[8] =3D 8bdf01f08b60001
  fence[9] =3D 87c100f0874a001
  fence[10] =3D 6a1f033065f6001
  fence[11] =3D 14db0130121c001
  fence[12] =3D d92d0130d82e001
  fence[13] =3D 169b01f015dc001
  fence[14] =3D c11000f0c071001
  fence[15] =3D 543202305042001
Active [12]:
  0765f000   524288 0009 0000 001411ad purgeable bsd snooped (LLC)
  0c3e2000   131072 0011 0000 001411ad dirty purgeable bsd snooped (LLC)
  0c2ae000   524288 0009 0000 001411c0 purgeable bsd snooped (LLC)
  15243000   786432 0010 0000 001411c0 Y dirty bsd snooped (LLC)
  0c35a000    24576 0050 0000 001411c0 dirty bsd snooped (LLC)
  01045000    36864 0010 0000 001411e2 dirty render snooped (LLC)
  1530f000   786432 0010 0000 001411e3 Y dirty bsd snooped (LLC)
  04870000     8192 0010 0000 001411e3 dirty purgeable bsd snooped (LLC)
  0c32e000     8192 0010 0000 001411e3 dirty purgeable bsd snooped (LLC)
  074d5000   786432 0010 0000 001411e3 Y dirty bsd snooped (LLC)
  047b0000   786432 0010 0000 001411e3 Y dirty bsd snooped (LLC)
  15303000     8192 0010 0000 001411e3 dirty bsd snooped (LLC)
Pinned [9]:
  00000000     4096 0001 0001 00000000 P snooped (LLC)
  00001000   131072 0001 0001 00000000 P snooped (LLC)
  00021000     4096 0001 0001 00000000 P snooped (LLC)
  00022000     4096 0001 0001 00000000 P snooped (LLC)
  00023000   131072 0001 0001 00000000 P snooped (LLC)
  00043000     4096 0001 0001 00000000 P snooped (LLC)
  00044000   131072 0001 0001 00000000 P snooped (LLC)
  00064000  8294400 0041 0000 00000000 P uncached (name: 1)
  03bc3000  9891840 0002 0000 00000000 P X dirty uncached (name: 78) (fence:=
 4)
gen6 bsd ring --- gtt_offset =3D 0x0765f000
00000000 :  13000082
00000004 :  00000000
00000008 :  00000000
0000000c :  00000000
00000010 :  70000002
00000014 :  00000100
00000018 :  00000041
0000001c :  00000000
00000020 :  70010004
00000024 :  00000000
00000028 :  11f8b3c0
0000002c :  480017fb
00000030 :  00000240
00000034 :  00000000
00000038 :  70020016
0000003c :  047b0000
00000040 :  00000000
00000044 :  00000000
00000048 :  00000000
0000004c :  00000000
00000050 :  00000000
00000054 :  00000000
00000058 :  00000000
0000005c :  00000000
00000060 :  00000000
00000064 :  00000000
00000068 :  00000000
0000006c :  00000000
00000070 :  00000000
00000074 :  00000000
00000078 :  00000000
0000007c :  00000000
00000080 :  00000000
00000084 :  00000000
00000088 :  00000000
0000008c :  00000000
00000090 :  00000000
00000094 :  00000000
00000098 :  70040002
0000009c :  0c32e000
000000a0 :  00000000
000000a4 :  00000000
000000a8 :  73000002
000000ac :  ffff39c0
000000b0 :  00000200
000000b4 :  0024002d
000000b8 :  73010010
000000bc :  00000000
000000c0 :  16131008
000000c4 :  221d1b1a
000000c8 :  18161010
000000cc :  25221d1b
000000d0 :  1b1a1613
000000d4 :  2622221d
000000d8 :  1b1a1616
000000dc :  2825221d
000000e0 :  1d1b1a16
000000e4 :  30282320
000000e8 :  201d1b1a
000000ec :  3a302823
000000f0 :  221d1b1a
000000f4 :  45382e26
000000f8 :  26231d1b
000000fc :  5345382e
00000100 :  73010010
00000104 :  00000001
00000108 :  19151111
0000010c :  30272220
00000110 :  1d191211
00000114 :  37302722
00000118 :  22201915
0000011c :  3b323027
00000120 :  24211b19
00000124 :  41393229
00000128 :  2924211b
0000012c :  5241362f
00000130 :  2f292421
00000134 :  68524136
00000138 :  352b26
  0:         56          0          0          0   IO-APIC-edge      timer
  1:          3          0          0          0   IO-APIC-edge      i8042
  8:       3938          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          4          0          0          0   IO-APIC-edge      i8042
 16:        113          0          0          0   IO-APIC-fasteoi   firewir=
e_ohci, ehci_hcd:usb5
 23:     609823          0          0          0   IO-APIC-fasteoi   ehci_hc=
d:usb6
 40:          0          0          0          0   PCI-MSI-edge      PCIe PM=
E
 41:          0          0          0          0   PCI-MSI-edge      PCIe PM=
E
 42:          0          0          0          0   PCI-MSI-edge      PCIe PM=
E
 43:          0          0          0          0   PCI-MSI-edge      PCIe PM=
E
 44:      67684          0          0          0   PCI-MSI-edge      ahci
 45:         12          0          0          0   PCI-MSI-edge      mei
 46:      16708          0          0          0   PCI-MSI-edge      snd_hda=
_intel
 47:     384752          0          0          0   PCI-MSI-edge      eth0
 48:       1227          0          0          0   PCI-MSI-edge      xhci_hc=
d
 49:          0          0          0          0   PCI-MSI-edge      xhci_hc=
d
 50:     237169          0          0          0   PCI-MSI-edge      i915@pc=
i:0000:00:02.0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     435999     384397     324955     291350   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring in=
terrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          2          0          0          0   APIC ICR read retries
RES:      56357      35363      16309       5787   Rescheduling interrupts
CAL:         71        120        121        135   Function call interrupts
TLB:      13906      16496       8641       6773   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:         15         15         15         15   Machine check polls
ERR:          0
MIS:          0

bogomips        : 6585.53
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz
stepping        : 7
microcode       : 0x6
cpu MHz         : 3292.769
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca c=
mov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdt=
scp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonst
op_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16=
 xtpr pdcm pcid sse4_1 sse4_2 popcnt tsc_deadline_timer xsave avx lahf_lm ar=
at epb xsaveopt pln pts dts tpr_shadow vnmi flexpriority ept vpid
bogomips        : 6585.53
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:



=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD
cpu0 12588 964 5930 367566 4720 0 310 0 0 0
cpu1 15113 1033 5239 370871 1323 0 10 0 0 0
cpu2 4325 755 1824 385625 1017 0 1 0 0 0
cpu3 5148 524 1941 384866 1129 0 0 0 0 0
intr 2933665 56 3 0
..
--=_7ggm6kwbefy7--

