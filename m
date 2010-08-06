Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280Ab0HGAgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 20:36:21 -0400
Received: from uucp.gnuu.de ([83.246.114.63]:2653 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0HGAgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 20:36:18 -0400
X-Greylist: delayed 1275 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2010 20:36:17 EDT
Date: Sat, 7 Aug 2010 01:31:57 +0200
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Oops in trace_hardirqs_on (powerpc)
Message-ID: <20100806233157.GA7117@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've built my 2.6.35 with tracing support and now, I'm getting
continuously oops'. It seems to happen on high process activity.

[   52.336371] device eth0 entered promiscuous mode
[   52.347616] device eth0 left promiscuous mode
[   55.240663] Unable to handle kernel paging request for data at address 0=
xbfaf4a24
[   55.248289] Faulting instruction address: 0xc00aad98
[   55.255562] Oops: Kernel access of bad area, sig: 11 [#1]
[   55.262588] PowerMac
[   55.269606] last sysfs file: /sys/devices/pci0000:00/0000:00:10.0/graphi=
cs/fb0/radeonbl0/brightness
[   55.277111] Modules linked in: fuse snd_powermac option usb_wwan usbseri=
al ecb b43 snd_aoa_i2sbus snd_pcm_oss=20
[   55.302368] NIP: c00aad98 LR: c001771c CTR: c003dba0
[   55.310738] REGS: e3211e70 TRAP: 0300   Not tainted  (2.6.35)
[   55.319122] MSR: 00001032 <ME,IR,DR>  CR: 22f88f42  XER: 20000000
[   55.327650] DAR: bfaf4a24, DSISR: 40000000
[   55.335954] TASK =3D e3245bc0[1929] 'sh' THREAD: e3210000
[   55.336144] GPR00: 00000000 e3211f20 e3245bc0 e3245bc0 c000b944 00000000=
 003a1040 00000000=20
[   55.344859] GPR08: bfaf4a20 c05e0000 c0614d18 c0610000 00000000 10033368=
 10018520 10007c2c=20
[   55.353723] GPR16: 10007c30 00000000 00000000 00000000 bfecaa10 101d8304=
 10019c28 bfecbfab=20
[   55.362438] GPR24: bfecaa08 10019c58 000006d1 00000000 c063be80 bfeca9a0=
 0ffebff4 e3211f20=20
[   55.378913] NIP [c00aad98] trace_hardirqs_on+0x5c/0x124
[   55.386856] LR [c001771c] restore+0x10/0x6c
[   55.394527] Call Trace:
[   55.401878] [e3211f20] [10019c58] 0x10019c58 (unreliable)
[   55.409437] [e3211f40] [c001771c] restore+0x10/0x6c
[   55.417065] --- Exception: c00 at 0xff23c88
[   55.417071]     LR =3D 0xff23c54
[   55.432267] Instruction dump:
[   55.439808] 800a005c 70090002 418200c8 7c0000a6 70008000 408200bc 3d20c0=
5e 838a0058=20
[   55.447730] 81096f98 2f880000 811f0000 81080000 <83680004> 41be009c 816b=
4d18 90096f98=20
[   55.455722] ---[ end trace 547f1189532873f7 ]---
[  390.022834] EXT4-fs (dm-0): mounted filesystem with ordered data mode. O=
pts: (null)

[  507.793120] lo: Disabled Privacy Extensions
[  518.228969] eth0: no IPv6 routers present
[  737.593898] Unable to handle kernel paging request for data at address 0=
x00000004
[  737.593927] Faulting instruction address: 0xc00aad98
[  737.593957] Oops: Kernel access of bad area, sig: 11 [#2]
[  737.593967] PowerMac
[  737.593976] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scalin=
g_governor
[  737.593992] Modules linked in: ppp_async crc_ccitt ipv6 ppp_generic slhc=
 fuse snd_powermac option usb_wwan usb
[  737.594132] NIP: c00aad98 LR: c001771c CTR: c003dba0
[  737.594148] REGS: e685de70 TRAP: 0300   Tainted: G      D      (2.6.35)
[  737.594159] MSR: 00001032 <ME,IR,DR>  CR: 24000042  XER: 20000000
[  737.594187] DAR: 00000004, DSISR: 40000000
[  737.594198] TASK =3D e30b3780[3322] 'zsh-beta' THREAD: e685c000
[  737.594208] GPR00: 00000000 e685df20 e30b3780 e30b3780 c000b944 00000000=
 003e5f00 00000000=20
[  737.594240] GPR08: 00000000 c05e0000 c0614d18 c0610000 00000000 100b4ee8=
 10092dec 00000000=20
[  737.594271] GPR16: 100bb400 100916fc 00000000 bfbda1b0 bfbda4ec 00000000=
 00000000 00000000=20
[  737.594303] GPR24: 100b0000 100bae50 00000cea 00000000 c063be80 bfbd9e60=
 0fe64ff4 e685df20=20
[  737.594362] NIP [c00aad98] trace_hardirqs_on+0x5c/0x124
[  737.594379] LR [c001771c] restore+0x10/0x6c
[  737.594388] Call Trace:
[  737.594402] [e685df20] [100bae50] 0x100bae50 (unreliable)
[  737.594421] [e685df40] [c001771c] restore+0x10/0x6c
[  737.594432] Instruction dump:
[  737.594442] 800a005c 70090002 418200c8 7c0000a6 70008000 408200bc 3d20c0=
5e 838a0058=20
[  737.594473] 81096f98 2f880000 811f0000 81080000 <83680004> 41be009c 816b=
4d18 90096f98=20
[  737.594514] ---[ end trace 547f1189532873f8 ]---
[  737.919108] Unable to handle kernel paging request for data at address 0=
x00000003
[  737.919137] Faulting instruction address: 0xc00aad98
[  737.919168] Oops: Kernel access of bad area, sig: 11 [#3]
[  737.919179] PowerMac
[  737.919187] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scalin=
g_governor
[  737.919203] Modules linked in: ppp_async crc_ccitt ipv6 ppp_generic slhc=
 fuse snd_powermac option usb_wwan usb
[  737.919342] NIP: c00aad98 LR: c001771c CTR: 00000000
[  737.919358] REGS: e6d15e70 TRAP: 0300   Tainted: G      D      (2.6.35)
[  737.919369] MSR: 00001032 <ME,IR,DR>  CR: 24ffff42  XER: 00000000
[  737.919397] DAR: 00000003, DSISR: 40000000
[  737.919409] TASK =3D e30b3780[3350] 'zsh-beta' THREAD: e6d14000
[  737.919419] GPR00: 00000000 e6d15f20 e30b3780 e30b3780 c000b944 00000000=
 0065df00 00000008=20
[  737.919451] GPR08: ffffffff c05e0000 c0614d18 c0610000 ffffffff 100b4ee8=
 100ad1e8 00000004=20
[  737.919483] GPR16: 100bb400 100916fc 00000000 bfbdad70 bfbdb0a8 10091e04=
 10091e08 100ad314=20
[  737.919515] GPR24: 100b0000 100bae50 00000cea 00000000 c063be80 bfbdaa20=
 0fe64ff4 e6d15f20=20
[  737.919576] NIP [c00aad98] trace_hardirqs_on+0x5c/0x124
[  737.919593] LR [c001771c] restore+0x10/0x6c
[  737.919602] Call Trace:
[  737.919616] [e6d15f20] [100bae50] 0x100bae50 (unreliable)
[  737.919635] [e6d15f40] [c001771c] restore+0x10/0x6c
[  737.919646] Instruction dump:
[  737.919657] 800a005c 70090002 418200c8 7c0000a6 70008000 408200bc 3d20c0=
5e 838a0058=20
[  737.919688] 81096f98 2f880000 811f0000 81080000 <83680004> 41be009c 816b=
4d18 90096f98=20
[  737.919728] ---[ end trace 547f1189532873f9 ]---

% uname -a
Linux ibook 2.6.35 #33 Fri Aug 6 21:44:01 CEST 2010 ppc GNU/Linux

% cat /proc/cpuinfo
processor	: 0
cpu		: 7455, altivec supported
clock		: 606.000000MHz
revision	: 3.3 (pvr 8001 0303)
bogomips	: 36.86
timebase	: 18432000
platform	: PowerMac
model		: PowerBook6,3
machine		: PowerBook6,3
motherboard	: PowerBook6,3 MacRISC3 Power Macintosh
detected as	: 287 (iBook G4)
pmac flags	: 0000001b
L2 cache	: 256K unified
pmac-generation	: NewWorld
Memory		: 640 MB

My config is at <http://alioth.debian.org/~jo-guest/config-2.6.35>. With
the version 2.6.35-rc6 and the former config I didn't have this problem.

http://alioth.debian.org/~jo-guest/config-2.6.35-rc6
http://alioth.debian.org/~jo-guest/kern.log

(gdb) disassemble trace_hardirqs_on
Dump of assembler code for function trace_hardirqs_on:
   0xc00aad3c <+0>:     stwu    r1,-32(r1)
   0xc00aad40 <+4>:     mflr    r0
   0xc00aad44 <+8>:     stw     r0,36(r1)
   0xc00aad48 <+12>:    stw     r27,12(r1)
   0xc00aad4c <+16>:    stw     r28,16(r1)
   0xc00aad50 <+20>:    stw     r29,20(r1)
   0xc00aad54 <+24>:    stw     r30,24(r1)
   0xc00aad58 <+28>:    stw     r31,28(r1)
   0xc00aad5c <+32>:    mr      r31,r1
   0xc00aad60 <+36>:    lis     r11,-16287
   0xc00aad64 <+40>:    addi    r10,r11,19736
   0xc00aad68 <+44>:    lwz     r0,92(r10)
   0xc00aad6c <+48>:    andi.   r9,r0,2
   0xc00aad70 <+52>:    beq     0xc00aae38 <trace_hardirqs_on+252>
   0xc00aad74 <+56>:    mfmsr   r0
   0xc00aad78 <+60>:    andi.   r0,r0,32768
   0xc00aad7c <+64>:    bne     0xc00aae38 <trace_hardirqs_on+252>
   0xc00aad80 <+68>:    lis     r9,-16290
   0xc00aad84 <+72>:    lwz     r28,88(r10)
   0xc00aad88 <+76>:    lwz     r8,28568(r9)
   0xc00aad8c <+80>:    cmpwi   cr7,r8,0
   0xc00aad90 <+84>:    lwz     r8,0(r31)
   0xc00aad94 <+88>:    lwz     r8,0(r8)
   0xc00aad98 <+92>:    lwz     r27,4(r8)
   0xc00aad9c <+96>:    beq     cr7,0xc00aae38 <trace_hardirqs_on+252>
   0xc00aada0 <+100>:   lwz     r11,19736(r11)
   0xc00aada4 <+104>:   stw     r0,28568(r9)
   0xc00aada8 <+108>:   cmpwi   cr7,r11,0
   0xc00aadac <+112>:   beq     cr7,0xc00aae38 <trace_hardirqs_on+252>
   0xc00aadb0 <+116>:   lwz     r30,28(r28)
   0xc00aadb4 <+120>:   cmpwi   cr7,r30,0
   0xc00aadb8 <+124>:   beq     cr7,0xc00aae38 <trace_hardirqs_on+252>
   0xc00aadbc <+128>:   lwz     r0,12(r30)
   0xc00aadc0 <+132>:   cmpwi   cr7,r0,0
   0xc00aadc4 <+136>:   beq     cr7,0xc00aae38 <trace_hardirqs_on+252>
   0xc00aadc8 <+140>:   lwz     r0,0(r30)
   0xc00aadcc <+144>:   cmpwi   cr7,r0,0
   0xc00aadd0 <+148>:   bne     cr7,0xc00aae38 <trace_hardirqs_on+252>
   0xc00aadd4 <+152>:   mflr    r29
   0xc00aadd8 <+156>:   lwarx   r0,0,r30
   0xc00aaddc <+160>:   addic   r0,r0,1

Bye, J=F6rg.
--=20
Two types have compatible type if their types are the same.
[ANSI C, 6.2.7]

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxcm2wACgkQwe0mZwH1VICiPQCglRxiIsq2+qGZ79YwS1ccqJyZ
IIYAnjYJJNRu1Sw9T2TCa5oZT/gxhpf4
=j5Bl
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
