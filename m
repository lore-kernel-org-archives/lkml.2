Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2AXAFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:05:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57068 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab2AXAFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:05:05 -0500
Date: Tue, 24 Jan 2012 11:04:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unable to fetch the oprofile tree
Message-Id: <20120124110455.519021de79b6fef5ad383ec2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Jan_2012_11_04_55_+1100_UINw/N8ndqIOAH6v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jan_2012_11_04_55_+1100_UINw/N8ndqIOAH6v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robert,

Trying to fetch the oprofile tree produced this error for the past few
days:

fatal: unable to connect to amd64.org:
amd64.org[0: 217.160.130.188]: errno=3DConnection timed out

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__24_Jan_2012_11_04_55_+1100_UINw/N8ndqIOAH6v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHfWnAAoJEECxmPOUX5FEML0QAJ7v9pVO546Lmgx0DRYiHxoV
Q/9VPYL67N43AZ9sgxuNbq9nbDZFBCdUt+TFA6UuHpHJGcZRio0g0A81zRT0c2N8
CKw5TXb9uRrQA53IR1vbp4BLQa4qy1O2ZGjKruLAwIzSf0AUi76qua2c62Cq4TsH
W+U6yHx/kyNeiTp7qSubjM3jsgGCbDmHnjHbfrGVdMzfOAN2HZ8QQgU3yTgr6BkJ
lFsCxCnkSloCJuklfL+b8a0xob9m2guXL7nL4mvq6YAT+IhecUgpFXPIXoKuh6sJ
rFDJGVMvoV7zc88iXX+hJ7JAj/166u1GUEidkbF4+AYfgF9TYXcd+mi/SXh/TGjM
HiMZDYnQoVfOkYmnQwyJHlByAhr1Vu9i/xmNf59LaqC8zbcCaewamDR0kID9qMjx
2DK5zu3t2rgDtbUL4ev1o2Sp0QIn5QRm16rBL9XQnsv6SXHqZHZXBIWupSX3/q3S
EyRNKRkZGpJRtiinH/gVrCu5NUDYEZUW0OBl+9SPhvKMwSd4299kiCSaQ44J7wIh
tssDL2Fqv4a6eDk15b+OAtR2emNzOfh/9Qe9DFsYnSuE/+QP/O9xyr3sqWGvQXp9
nYqeDfKuvyxKtEF7yIBo/Lmm+y2a19gf0Go/XWFR1Rch0acC6Y2yu+yLHThZPDPE
xMuxeMl8K7+513zDuQE7
=SGxQ
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jan_2012_11_04_55_+1100_UINw/N8ndqIOAH6v--
