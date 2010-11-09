Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab0KIDvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:51:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35831 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0KIDvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:51:38 -0500
Date: Tue, 9 Nov 2010 14:51:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: linux-next: build warning after merge of the finaltree
Message-Id: <20101109145126.b658e4b4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Nov_2010_14_51_26_+1100_ak/R7MVRQm9GL.+4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Nov_2010_14_51_26_+1100_ak/R7MVRQm9GL.+4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

In file included from drivers/gpu/stub/poulsbo.c:15:
include/acpi/video.h:22: warning: 'struct acpi_device' declared inside para=
meter list
include/acpi/video.h:22: warning: its scope is only this definition or decl=
aration, which is probably not what you want

Introduced by commit e26fd1199ebab0d469fc3e037da5932d382f0669 ("gpu: Add
Intel GMA500(Poulsbo) Stub Driver").  Maybe this driver only needs to be
built on x86?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Nov_2010_14_51_26_+1100_ak/R7MVRQm9GL.+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2MU+AAoJEDMEi1NhKgbsr9cH/0iyIQ/VM8oicfGJZ38spICF
dPNuM2z07JH/n6m1IHZlgdD4i3d7r3v77b/s8jmjiqy9+vAyzFQHw5My/YNQ+1Q6
Dk8G0lSkLCfOSP9YbVd+kRXhhtwm+Urruj5FY9B8aaqUqfAASqn34gCLw3IozMZW
+/TBfuPadgAN8lTsvt0MDnWf4QgZBntIbvVDEp3kfkwBlSh4hwuiV86C64iNeYAu
eItmzS9BcE1pjxhU/EQ96FG6EounNcruitQZm/Gn7ULRZeupLjv2Btclx/9jneS3
tofFkKaLIPafZPaYr7f18Z7uoYHS6vc9UITpd6elQNzS/o/iZTV+qF06LNAArhM=
=NKaW
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Nov_2010_14_51_26_+1100_ak/R7MVRQm9GL.+4--
