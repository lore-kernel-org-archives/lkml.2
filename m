Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1GPMx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:53:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55210 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1GPMxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:53:54 -0400
Date: Sat, 16 Jul 2011 22:53:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: manual merge of the staging tree with the trivial tree
Message-Id: <20110716225343.4a0a0472fb944c9ba79f9590@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_22_53_43_+1000_iyqGDLw7cQPIJN3t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_22_53_43_+1000_iyqGDLw7cQPIJN3t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/generic_serial/ser_a2232.c between commit 28f65c11f2ff
("treewide: Convert uses of struct resource to resource_size(ptr)") from
the trivial tree and commit bb2a97e9ccd5 ("Staging: delete generic_serial
drivers") from the staging tree.

The latter removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_22_53_43_+1000_iyqGDLw7cQPIJN3t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIYnXAAoJEDMEi1NhKgbs6AYIAJj5/Z/7QrWpt7qpbNGSkjwv
b3JGPcuatpca4X+7jfpvEVo2JEs/D960nPJZOdj3RJt/oZBR5yymrIDk5gcSLhFG
/uiSdl1uTe2qBVwDknRDszg6k6+Y0Q+bO844L8xT0L3HApptWGmNJ02KzNsD8HYq
wm12bEbLH85t/eyK75yGwge5o2dbydEvYCD5krHvITBX4fV5dHBqhkuYJ+gg28dv
rSLOxeZrkPRbe+RkfxlCk74pkP0QfneyzII5jIrDavHPko8uRNGUiiksYZ1rxINJ
QqgiOUl+dw96txCx7AnoxdLqzG8tnn0VCQI1azGNCizTMrZvrRGqV4tBRh1GnDo=
=ARfK
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_22_53_43_+1000_iyqGDLw7cQPIJN3t--
