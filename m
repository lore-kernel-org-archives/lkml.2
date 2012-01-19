Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2ASACE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:02:04 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:41534 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2ASACC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:02:02 -0500
Date: Thu, 19 Jan 2012 11:01:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build failure after merge of the cifs tree
Message-Id: <20120119110153.7ffa3312b2943386750ac7ed@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jan_2012_11_01_53_+1100_LjsflH7aNU1bec2/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jan_2012_11_01_53_+1100_LjsflH7aNU1bec2/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/cifs/connect.c: In function 'cifs_set_vol_auth':
fs/cifs/connect.c:3843:17: error: 'CIFSSEC_MUST_LANMAN' undeclared (first u=
se in this function)
fs/cifs/connect.c:3843:17: note: each undeclared identifier is reported onl=
y once for each function it appears in

Caused by commit 8a8798a5ff90 ("cifs: fetch credentials out of keyring
for non-krb5 auth multiuser mounts").

I have used the cifs tree from next-20120118 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Jan_2012_11_01_53_+1100_LjsflH7aNU1bec2/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPF11xAAoJEECxmPOUX5FEUmoQAIBZIam4rhfZmxkzmOxINfgz
oH/LrvY4YIRInibFqFnorSRCmLD1oy/zwKWqKw5bHJHxe2QVFVHMhlTB+Z10SWyk
xP93T0Ik3S8gIXoDwBXPItZKe74xbv4jkxnbJTc3W1dl4W9GfNMLUeFymFjRQtHi
w1k0cJl9Yua6fT9Y3ftLl5BEDQMi3BtY5wP+DDpWJjymsJPUqBbUHHlDIDJQBpty
2PuHASnza/aaV8jSPYh7Ylv2+OvMNbCwRDC2bbVKlDKqhmnqJ4pktPWe8gvHToXe
exDiKF9gWXkcROgndbdOudgkaAdVjq37z4AymfK58RbzoC2AyFSqw28g73zQwS5N
VR+kdYRdFskuBgEU9V+m2p6H7qYTFDuMTSoIG68yluKd2ynmOgNjHpP47Xz0/P0l
cFMFnRng3YvM7pDwUPqOPwMujTmx7otJrqHEJ8rn8W1hUIvxHzH6zG+7Lh0/F3n+
QwHB9Dhe0c8AdqSUyJx7Wom5tYZ2cDSCLAjXZm1tdjhM/zrqKbUkn5T+qvNGUFBL
hXCT4t/i2i7QMlbQUxClTOJRtl+xGPuijlJaqrcIcYY8KMd5tgpY7Js1v/X28QIa
QWnhVy48t0VuPmKhCiq+QUqaS6qmdWo3+dVNQbs8MewknfCYb/a9vkw3Jwm0M7/x
aUsbblcPTv9jsv83DFGl
=nkk3
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jan_2012_11_01_53_+1100_LjsflH7aNU1bec2/--
