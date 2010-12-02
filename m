Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0LBCXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:23:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54922 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440Ab0LBCXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:23:04 -0500
Date: Thu, 2 Dec 2010 13:22:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20101202132254.93e019c7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Dec_2010_13_22_54_+1100_GQNFI/pvFTSo5R5j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Dec_2010_13_22_54_+1100_GQNFI/pvFTSo5R5j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/winbond/sysdef.h between commit
412dc7f368bf10a8049a8a4c41abbfd0108742e7 ("staging: fix winbond build,
needs delay.h") from the staging.current tree and commit
ddee7e28e7d5e4ba2b8537c6a59b035745c250bb ("Staging: w35und: Remove empty
sysdef.h header") from the staging tree.

I removed the file.  I wonder if
drivers/staging/winbond/phy_calibration.c and
drivers/staging/winbond/reg.c now need their own includes of
linux/delay.h ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Dec_2010_13_22_54_+1100_GQNFI/pvFTSo5R5j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM9wL+AAoJEDMEi1NhKgbs3QcH/2XTfShOmo0IAYhnX/xBrNG9
j1oFeIUVy2rCuV+EhH+Odrv6EpNe0iItRXpQDpuZ5BjtWD8alZoehyiJnUbYbVWS
60QPb4pVpuLulKRJnXUjbAZ3EKXV4NPmNPnez0R8BxQqHvqXoH0S8c2OHg+mDj7N
YBJQ7V8QJYmC9IcenQOUdx/T8UE/LKD8yJVYVqooC5P+LXXj3lODtkcjlWJ4oGCZ
Pb271UMu0YY4sGTFXGcn97FaiSIDt9gyeXSNJfXLpNYtu1Q/5Pgja6UnJuSdFH6I
kVcVsVn7fyEHDyK1mKiH7AWmeqxG8dHDAZRsGpziyRkNdxgkX1qldtgL96Vk71w=
=54LG
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Dec_2010_13_22_54_+1100_GQNFI/pvFTSo5R5j--
