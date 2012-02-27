Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2B0OS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:18:29 -0500
Received: from mail.4lin.net ([46.4.210.97]:40065 "EHLO mail.4lin.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab2B0OS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:18:26 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Feb 2012 09:18:26 EST
From: Denny Schierz <linuxmail@4lin.net>
Content-Type: multipart/signed; boundary="Apple-Mail=_097385D0-A55A-4874-9035-1D0839B2A60A"; protocol="application/pgp-signature"; micalg=pgp-sha1
Subject: Don't get Sun SPARC T2000 Enterprise booting with any(?) kernel
Date: Mon, 27 Feb 2012 15:07:43 +0100
Message-Id: <73F85A3B-453F-4213-8B33-41061BA31F1B@4lin.net>
Cc: linuxmail@4lin.net
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1257)
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_097385D0-A55A-4874-9035-1D0839B2A60A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

hi @all,

(please CC: me)

I have a Sun Enterprise T2000 and I try to get Debian onto the disks, =
but it fails with kernel 2.6.32, 2.6.39, 3.2, the latest stable kernel =
and 3.3.0-rc5. I have build for my Sunfire v245 a NFS rescue system and =
I was 3 or 4 times able to boot into my NFS root from the T2000. But in =
most cases it fails:

[   60.554011] IP-Config: Got DHCP answer from 192.168.1.1, my address =
is 192.168.1.12
[   61.137949] IP-Config: Complete:
[   61.138047]      device=3Deth3, addr=3D192.168.1.12, =
mask=3D255.255.255.0, gw=3D192.168.1.1,
[   61.138243]      host=3De01, domain=3Dfoo, nis-domain=3D(none),
[   61.138428]      bootserver=3D192.168.1.1, rootserver=3D192.168.1.1, =
rootpath=3D/srv/fai-sparc/nfsroot
[   61.138774] Warning: unable to open an initial console.
[   61.144119] Kernel panic - not syncing: Attempted to kill init!
[   61.144242] Call Trace:
[   61.144294]  [000000000045b8f8] do_exit+0xa8/0x6bc
[   61.144344]  [000000000045bf7c] do_group_exit+0x70/0xa8
[   61.144405]  [000000000045bfcc] SyS_exit_group+0x18/0x28
[   61.144472]  [0000000000405fd4] linux_sparc_syscall32+0x34/0x40
[   61.144583] Press Stop-A (L1-A) to return to the boot prom

[   83.503215] rtc-sun4v rtc-sun4v: setting system clock to 2012-02-25 =
11:06:56 UTC (1330168016)
[   85.678958] e1000e: eth3 NIC Link is Up 100 Mbps Full Duplex, Flow =
Control: Rx/Tx
[   85.679152] e1000e 0001:07:00.1: eth3: 10/100 speed: disabling TSO
[   85.693972] Sending DHCP requests ., OK
[   87.202052] IP-Config: Got DHCP answer from 192.168.1.1, my address =
is 192.168.1.12
[   87.786547] IP-Config: Complete:
[   87.786669]      device=3Deth3, addr=3D192.168.1.12, =
mask=3D255.255.255.0, gw=3D192.168.1.1,
[   87.786865]      host=3De01, domain=3Dfoo, nis-domain=3D(none),
[   87.786950]      bootserver=3D192.168.1.1, rootserver=3D192.168.1.1, =
rootpath=3D/srv/fai-sparc/nfsroot
[   87.787123] Warning: unable to open an initial console.
[   87.792121] Kernel panic - not syncing: Attempted to kill init!
[   87.792197] Call Trace:
[   87.792249]  [000000000045b8f8] do_exit+0xa8/0x6bc
[   87.792299]  [000000000045bf7c] do_group_exit+0x70/0xa8
[   87.792360]  [000000000045bfcc] SyS_exit_group+0x18/0x28
[   87.792427]  [0000000000405fd4] linux_sparc_syscall32+0x34/0x40
[   87.792539] Press Stop-A (L1-A) to return to the boot prom

Complete boot dmesg 2.6.39  : http://pastebin.com/NWp79bG3
Kernel Config: https://www.pug.org/mediawiki/images/4/4e/Config-fai.txt

Complete boot dmesg 3.3.0-rc5  : http://pastebin.com/7kKZKWpk


I also tried different Debian installer, but older Lenny images and new =
Squeeze, fails:

=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4 Loading additional =
components =
=E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
=E2=94=82                                                                =
         =E2=94=82
=E2=94=82                                   16%                          =
         =E2=94=82
=E2=94=82                                                                =
         =E2=94=82
=E2=94=82 [ 1753.931851] Unable to handle kernel paging request at =
virtual address 000000f203204000
[ 1753.932033] tsk->{mm,active_mm}->context =3D 000000000000018d         =
     =E2=94=82
[ 1753.932134] tsk->{mm,active_mm}->pgd =3D =
fffff801fd52a000=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98
[ 1753.932670] Kernel panic - not syncing: Aiee, killing interrupt =
handler!
[ 1753.933114] Press Stop-A (L1-A) to return to the boot prom

Mostly accessing the hardware/ or detection from it.

So, I need some suggestions to get it working. Most problem: I have only =
9.4-9.5MB for the kernel + initrd image, otherwise, the OpenBoot =
Firmware doesn't load it.

If it helps, I can make this host public for some people, to try out, =
what is the problem.

Also, I put the latest firmware on it, but it helps only a few times to =
get booting into the NFSroot.

Additional infos:

SPARC-Enterprise-T2000 System Firmware 6.7.12  2011/07/06 20:03

Host flash versions:
   OBP 4.30.4.d 2011/07/06 14:29
   Hypervisor 1.7.3.c 2010/07/09 15:14
   POST 4.30.4.b 2010/07/09 14:24=20

sc> showsc version -v

Advanced Lights Out Manager CMT v1.7.11
SC Firmware version: CMT 1.7.11
SC Bootmon version: CMT 1.7.11

VBSC 1.7.3.d
VBSC firmware built Jul  6 2011, 19:27:17

SC Bootmon Build Release: 01
SC bootmon checksum: 4CB78FC8
SC Bootmon built Jul  6 2011, 19:37:05

SC Build Release: 01
SC firmware checksum: C41F3325

SC firmware built Jul  6 2011, 19:37:18
SC firmware flashupdate SAT FEB 25 23:51:16 2012

SC System Memory Size: 32 MB
SC NVRAM Version =3D 14
SC hardware type: 4

FPGA Version: 4.2.4.7



cu denny=

--Apple-Mail=_097385D0-A55A-4874-9035-1D0839B2A60A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)

iEYEARECAAYFAk9Lji8ACgkQKlzhkqt9P+DLAgCffTswxeGcIuvwGafgZfAv5nBs
+pYAoIkCiGI1BUiVL46TKyIKGyKOjOMw
=v2Ca
-----END PGP SIGNATURE-----

--Apple-Mail=_097385D0-A55A-4874-9035-1D0839B2A60A--
