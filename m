Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2AYCcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 21:32:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40805 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab2AYCcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 21:32:12 -0500
Date: Wed, 25 Jan 2012 13:32:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tyler Hicks <tyhicks@canonical.com>
Subject: linux-next: manual merge of the kmap_atomic tree with the ecryptfs
 tree
Message-Id: <20120125133201.faa14529e7f872d38a714fb5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Jan_2012_13_32_01_+1100_I2=/mfBDAuHuC9qx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jan_2012_13_32_01_+1100_I2=/mfBDAuHuC9qx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
fs/ecryptfs/read_write.c between commit f28b7904d455 ("eCryptfs: Remove
unused ecryptfs_read()") from the ecryptfs tree and commit 27de090e3326
("ecryptfs: remove the second argument of k[un]map_atomic()") from the
kmap_atomic tree.

The former just removed the entire ecryptfs_read() function that was
modified as part of the latter, so I did that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Jan_2012_13_32_01_+1100_I2=/mfBDAuHuC9qx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPH2mhAAoJEECxmPOUX5FEMyMP/A6DX80NKZeozZ+Yk8WFOTuF
kN8hhMzE47KkmXpN1882+wC2jCsC1GmBHRelhWwzTApkvOCwS2vjwZQeYnIwxmg6
+2+d2N23D5iZJLF++ntNEQQFQMas8GoKexHHULLR6S94psLfQYs7UiK3wXlcHf/C
qiK/SY5e3cKcdostCvB9I5icD6pIo3liVEXja7MRKvYRhC70JSFRZi3LXcsFbhtb
xvBzRSmUsbGCIiMOi55lrNQjPbaLWgphc1kzjCGlpFJT3lJ6GQKYsQqU8wa7ssBi
UQlAKPNzl4YP90FJHkbyPTzQEWQZU65FeRJQ1ItgCaIgSlRGTywJC1iNfhz7y4d3
igVepc1pZ0NCidIU6h2QeeS28KP7sJhXay0X0Y5kSgZ/XyYsOu+lQioQ1CbV/5jk
MSG+23vaxXU/SP4YgEN1panfUi3FjslbLT/WRto0Wx0s5mSaYRCZ4mCftRUN8eMc
PAZyOiynjBvtOGt1qg2Lu7xI153T44iWUTMb1WBqyqs6aOjf7loIGakIzui5RSWO
g7cD9pYjSJeX6ZXrj+hH31NUT0ymA344El8qa/OY71TvkYops55AuDiUV62VOJEX
BuRMcVlCrJF1S6BhI6Q15kSDB2SSx6PNLZDpku3drsxBTB8E58G0YQUXqOa3aVLW
gKP0mnNefVBc82vaL6+o
=NmOT
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jan_2012_13_32_01_+1100_I2=/mfBDAuHuC9qx--
