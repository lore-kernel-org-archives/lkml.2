Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030655Ab2CNDAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 23:00:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030539Ab2CNDAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 23:00:19 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=BeB3AtMZUVW8hXIvcoiw0Q==:17 a=ROzGFTdGdk0A:10 a=bKlB5my3KvLQvmLKERUA:9 a=0cBRs67dssKQ8gGX-h4A:7 a=QEXdDO2ut3YA:10 a=IVebr5fEeLZ2Ja3fIzoA:9 a=BeB3AtMZUVW8hXIvcoiw0Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.255.82.72
Message-ID: <1331694008.2293.10.camel@firefly>
Subject: Oops with kernel 3.3-rc7
From: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 13 Mar 2012 23:00:08 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4Vd5qP4t/Lj4gacz1bzq"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Vd5qP4t/Lj4gacz1bzq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello All,
	I have had another oops to report.  I am using btrfs as my root file
system.  It was originally ext4 that I converted to btrfs.  I also
had /home on a separate partition but deleted it and extended my root
partition then grew the root file system with "btrfs filesystem resize"
My /boot partition is ext2.  Please feel free to email me with any
questions. =20

TIA -- Nate

[   12.678120] hub 4-0:1.0: port 1, status 0100, change 0000, 12 Mb/s
[   12.678126] usb 4-1: USB disconnect, device number 2
[   12.678130] usb 4-1: unregistering device
[   12.678134] usb 4-1: unregistering interface 4-1:1.0
[   12.680983] scsi 3:0:0:2: killing request
[   12.681625] BUG: unable to handle kernel NULL pointer dereference at 000=
00004
[   12.682009] IP: [<c1425553>] sd_revalidate_disk+0x13/0x1fa0
[   12.682717] *pde =3D 00000000=20
[   12.683765] Oops: 0000 [#1] SMP=20
[   12.684850] Modules linked in: ehci_hcd
[   12.684850]=20
[   12.684850] Pid: 1120, comm: blkid Not tainted 3.3.0-rc7 #1 HP Pavilion =
061 DM170A-ABA A350N/'P4SD-LA'
[   12.684850] EIP: 0060:[<c1425553>] EFLAGS: 00010292 CPU: 0
[   12.684850] EIP is at sd_revalidate_disk+0x13/0x1fa0
[   12.684850] EAX: f4452200 EBX: f5020800 ECX: 00000001 EDX: 00000000
[   12.684850] ESI: f4452200 EDI: ffffff85 EBP: 00000000 ESP: f4677d1c
[   12.684850]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   12.684850] Process blkid (pid: 1120, ti=3Df4676000 task=3Df55b61c0 task=
.ti=3Df4676000)
[   12.684850] Stack:
[   12.684850]  f458d400 c10ca9e5 c142576f f6688180 c10e3822 f5f4d310 c10fa=
e20 f445223c
[   12.684850]  f5f4d310 f5444800 c10fae20 c10e44a4 f4677d70 f4452200 f4452=
23c 00000000
[   12.684850]  ffffff85 f4452200 c10d1315 f5020800 f5020884 f50208cc c10e3=
f52 f5020800
[   12.684850] Call Trace:
[   12.684850]  [<c10ca9e5>] ? kfree+0xc5/0xf0
[   12.684850]  [<c142576f>] ? sd_revalidate_disk+0x22f/0x1fa0
[   12.684850]  [<c10e3822>] ? find_inode+0x52/0x90
[   12.684850]  [<c10fae20>] ? I_BDEV+0x10/0x10
[   12.684850]  [<c10fae20>] ? I_BDEV+0x10/0x10
[   12.684850]  [<c10e44a4>] ? iget5_locked+0x74/0x190
[   12.684850]  [<c10d1315>] ? get_super+0x15/0xa0
[   12.684850]  [<c10e3f52>] ? iput+0x32/0x1a0
[   12.684850]  [<c127447c>] ? rescan_partitions+0x8c/0x2c0
[   12.684850]  [<c127c597>] ? kobject_release+0x37/0x90
[   12.684850]  [<c14238e1>] ? scsi_disk_put+0x21/0x40
[   12.684850]  [<c10fc43e>] ? __blkdev_get+0x22e/0x330
[   12.684850]  [<c10fc587>] ? blkdev_get+0x47/0x2d0
[   12.684850]  [<c10fb54e>] ? bdget+0xee/0x100
[   12.684850]  [<c10fae30>] ? bdev_test+0x10/0x10
[   12.684850]  [<c10fb5e8>] ? bd_acquire+0x88/0xc0
[   12.684850]  [<c10ccc8c>] ? __dentry_open.clone.15+0x1bc/0x2f0
[   12.684850]  [<c10cddb2>] ? nameidata_to_filp+0x52/0x60
[   12.684850]  [<c10fc810>] ? blkdev_get+0x2d0/0x2d0
[   12.684850]  [<c10da079>] ? do_last.clone.37+0xa9/0x720
[   12.684850]  [<c10db844>] ? path_openat+0xa4/0x350
[   12.684850]  [<c10dbbe4>] ? do_filp_open+0x34/0x90
[   12.684850]  [<c10e5d25>] ? alloc_fd+0x35/0xe0
[   12.684850]  [<c10cdeb0>] ? do_sys_open+0xf0/0x1c0
[   12.684850]  [<c10cdfb0>] ? sys_open+0x30/0x40
[   12.684850]  [<c15fa790>] ? sysenter_do_call+0x12/0x26
[   12.684850] Code: c1 89 54 24 04 c7 04 24 dd e9 6d c1 e8 a7 82 fd ff e9 =
1a f6 ff ff 66 90 55 31 d2 57 56 53 83 ec 68 8b a8 40 01 00 00 89 44 24 34 =
<8b> 45 04 89 44 24 30 8b 80 5c 02 00 00 83 f8 04 0f 95 c2 83 f8=20
[   12.684850] EIP: [<c1425553>] sd_revalidate_disk+0x13/0x1fa0 SS:ESP 0068=
:f4677d1c
[   12.684850] CR2: 0000000000000004
[   12.720873] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 16, ph=
ase 8, 17 us
[   12.725280] ---[ end trace 264203d6be4b7bd0 ]---
[   12.727629] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 0  ACK=
 POWER sig=3Dj CSC CONNECT
[   12.728405] hub 5-0:1.0: port 1: status 0501 change 0001
[   12.729759] ehci_hcd 0000:00:1d.7: GetStatus port:7 status 001803 0  ACK=
 POWER sig=3Dj CSC CONNECT
[   12.730582] hub 5-0:1.0: port 7: status 0501 change 0001
[   12.731444] usb 4-1: usb_disable_device nuking all URBs
[   12.732501] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   12.733367] uhci_hcd 0000:00:1d.0: port 1 portsc 008a,00



--=-4Vd5qP4t/Lj4gacz1bzq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPYAm4AAoJEOUCa8Z9qnav/lwP/2wd0CNlpbC28jNvPoc9g08r
sGT20mENePHQ4IWdA6wmoTqZk0Wj7voY/QQb77LBMlZsr5tAC6+LbxcdYeY9+d5F
V+DkgEtFyBjzogt7ain0dlQm3VtLkOcaILF4tUclkFkaCFg73lNpBo7cj1DdTscD
7KmZ77wRpLC5ruYbDkSZMOSqKyuGNKrMpnmNAHVte1Tx/w6FKmff4TV9TExJoEXY
hn/vG1ivTvTwVzeqyB7n15r4bsNcIhPbqEWQbiQJihaKVu1lYg5uycG8wMS4PEv5
kTcrkSA1cK4mxCI7U6lBjBgpG5km899V0X+ovseQyHnp4ilXPnMfXEL3okn/fqcn
rLNtIFi53oSvKDKjkVD21vocmHz1gsuwTaublx7IdZ75sNb/9npWIQW4wl0mpfZ/
UHUiCvs0XzBoIQfoZjF0N/fVRO5RZCwHcUCCmzwjnpFePKrwTku3JGuu198uq+X9
u3DFco6msL7kKOKJ05BCA0ue9kdYv/mDBf3xKb/lX/2vUuopy10bq3uLqE4INRjF
qqFFh8DBYdjfcbJkQitmvbGBYUfuXfjO8ISi4jl/GFlNrqHqXyOuvpsWNMliuJD7
ro685AXTee7j8yd2bjP07P2h3viZU2Xor0HAfU9lSlgb8yxoE2leg7h2KwrlyGD1
8myU0+oTsS3CYJ7WmXcF
=Jf44
-----END PGP SIGNATURE-----

--=-4Vd5qP4t/Lj4gacz1bzq--

