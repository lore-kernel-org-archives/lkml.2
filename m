Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab3ABDL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 22:11:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48425 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3ABDL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 22:11:27 -0500
Date: Wed, 2 Jan 2013 14:11:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the signal tree with the mips tree
Message-Id: <20130102141116.a93c916fe9f20110a4ca668c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Jan_2013_14_11_16_+1100_iurPDHNzP7vxpERR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jan_2013_14_11_16_+1100_iurPDHNzP7vxpERR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/mips/kernel/syscall.c between commit 12890d0f61fc ("MIPS: sysmips:
Rewrite to use SYSCALL_DEFINE3()") from the mips tree and commit
cc524ca3714b ("mips: kill sysmips() wrapper, switch to SYSCALL_DEFINE")
from the signal tree.

These patches are doing the same thing. I fixed it up (using the mips
tree version, which no longer passes regs to mips_atomic_set()) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__2_Jan_2013_14_11_16_+1100_iurPDHNzP7vxpERR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ46VUAAoJEECxmPOUX5FEHQ4P/3oWZrUUfWH6lFM8l9wxwK6h
RG47w3zGHq2cSypgDrL/JM+pAd83AmjGVFLsD2ABd3utnYJtuIp/e94WFk4yuBdN
IqN2ALF6zjjHO0Bha3YDi/93ce9YTOAG8QEXFIX+MdpOSVYVnk5clc5o9bEo7s6U
ZzKD8qJT3YxmOY5D7a0KZUT5sbCWJP7JX+shk7W+TvojFWIPtj82w0ZNHz4YXnST
LzWRitlPjPQzXvA8KenDQXT0vcHpNC3+O/IU9638TlFNSorL6u3lV9aR39KUbgpb
K/47Zh9hi8cJiK4s3ScEklfwuckVlMrAbR0W0J4CoH0x2E6pzpRLlv+5f4nBr5o4
7Tm3Pr/WGJz1hcmIHhW4iW1YvA0t21HiYLbk4OwubQKHxiZLhtBFD5sU7mG6V9eV
UYosmF7DwJoFFnNBjR+NfcvaIrapQw7NBjoxdvku50YvD+Xz9Jd0ISwhu9mKdfA9
PEQ0jHb/J0tiyCsoYeQx57t7CKy+fbhqMupNKz6FOrvzO8SC+SnnfCUd3sM9pNyE
Ug403dlF/Rvw65oJq4G50Ee3gbWJk3j6KVNhIfT/wa/fj7hqf+aASfNhgeeZZfJw
7d9VM95QHqNgFRAx2y8i4npxkq90iVc6W/UEtI8o9BPWoj9PcNUqGktlCDHiPt0i
NajfEHG33lg/RT59+Hxp
=EyOi
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jan_2013_14_11_16_+1100_iurPDHNzP7vxpERR--
