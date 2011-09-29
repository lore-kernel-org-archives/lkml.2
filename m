Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1I2F4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 01:56:05 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:56598 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1I2F4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 01:56:03 -0400
Date: Thu, 29 Sep 2011 15:55:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the staging tree
Message-Id: <20110929155557.1baa18a46e6dc142a97cf1d0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Sep_2011_15_55_57_+1000_UWpkYBieKfXx5GYd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Sep_2011_15_55_57_+1000_UWpkYBieKfXx5GYd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/staging/iio/accel/adis16220_core.c between commits 7991029a55fa
("staging:iio:accel:adis16220 iio_chan_spec conversion") and 6f4ebab56870
("staging: iio: adis16220_core.c: add module.h") from the staging tree
and commit 6eee8b750254 ("staging: Add module.h to more drivers
implicitly using it") from the moduleh tree.

The staging commits are a superset of the part of the moduleh commit that
affects this file, so I dropped the moduleh change (module.h was added in
different places).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Sep_2011_15_55_57_+1000_UWpkYBieKfXx5GYd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhAhtAAoJEDMEi1NhKgbsDxIH/R0Es7fzFSLpoUQiCykRS+8u
7JauUmMgqBW5o2iJ+qoJijIIWEndF4f7ZASrpglq9hFOXTzo7BXS+ju/Vx3TPET7
GpnRDijOx/F1xQ1MMTBHIiEfxJPJ/EqWfnPPhoaHM4jZdrTgV/3jBGeMy+ezxWSo
rZ3YFmVHztJsU1W4sp7fqVh1g6cuh6ZOnvXNPkJ7lO718GgNUEc+MoE4RVDwADmp
Ydim/ZfJMINRrzotKYcrYW4AXkBqAUiUw2QJuHO3J+YclecKqp+2OgxSG3b4r2/d
NtyI+bgNqOS0AivwQkSs6ifE/qOJ9zDVvMBTarI/MwA1VR6+eLSh5ZqbEW6TPhs=
=5jSU
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Sep_2011_15_55_57_+1000_UWpkYBieKfXx5GYd--
