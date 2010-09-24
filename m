Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0IXDst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 23:48:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46796 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab0IXDsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 23:48:46 -0400
Date: Fri, 24 Sep 2010 13:48:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: build warning after merge of the cifs tree
Message-Id: <20100924134841.161d18d3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/dir.c: In function 'cifs_new_fileinfo':
fs/cifs/dir.c:140: warning: unused variable 'cifs_sb'

Introduced by commit 9a6124e7e18fa30d8693055e6a4526afb4c3fabc ("cifs:
have cifs_new_fileinfo take a tcon arg").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnB+ZAAoJEDMEi1NhKgbszJoH/1R1TKoqSM+bGlQm4lsmtyuj
G3oI09Npk03pXldQdrVJ0QwH0iKoiSPI98YEPV/sH4qIwJSzwHRjmeFmFcw+Wtwf
RBdab/JEoqy+KQA6pOBSD/Be3SrZdE7R495BvmAORJQJCbY/zLyEF0921yvMKpVi
B908Cz0lFeT+lzFy4QQcM9nRuBC0IppWvYqffi1lRxkbCVLFr0G1efx5YPR/wuD7
g3OyziH1DUnCU/Dw12WjqiPe46uGH6B7tNI58jnu4cV1sFfIiekxdU0qxfr+6uaK
SFbij9Go/ReXorx/5DhfnoI1dcAdzH8r269MGAzDo5J2rDhAfmkVK+RefwrICO8=
=Wu6R
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo--
