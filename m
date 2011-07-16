Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1GPM4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:56:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35650 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1GPM4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:56:50 -0400
Date: Sat, 16 Jul 2011 22:56:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaliy Ivanov <vitalivanov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: manual merge of the staging tree with the trivial tree
Message-Id: <20110716225643.426f99dafa7fcebab4cd9be8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_22_56_43_+1000_9q/_3xgVD1mz/G/d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_22_56_43_+1000_9q/_3xgVD1mz/G/d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbrid=
ge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
drivers/staging/westbridge/astoria/gadget/cyasgadget.h between commit
e44ba033c565 ("treewide: remove duplicate includes") from the trivial
tree and commit 78f23926dff9 ("Staging: delete westbridge code") from the
staging tree.

The latter removes the files, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_22_56_43_+1000_9q/_3xgVD1mz/G/d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIYqLAAoJEDMEi1NhKgbsiN4H/j2oC60IZCr5wPGjORmwzvMn
4C3F8LadoOUayPDdcM34eMFffb1smE3Gp7urrUUVuNdzfMFmrtn3bno+Onv0D9Zi
jkoS5S3ev9Uu+wS3msr4EHYo19ANZDkN2qs1M1TTruok2q1nqaO1aT+Q2TI2kgr6
e7DNfWO0EzyxJ5UNX9PBfEPRIi1zGWqOgXeNRWjSpqRTjdEDk/orhaQdHHbfNEc+
m8RM3l1N0rVEiejmf0EJb/hyELG/Zjformb4PGoOpqID/eUWizGBiql8wXWluNAh
IT0GDKSG6kSWdNW45bQR16+rMxzjMGFcM24LiCmTyw3zFWmvgOXUo3YFYSvCFf4=
=KdcM
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_22_56_43_+1000_9q/_3xgVD1mz/G/d--
