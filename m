Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1JDG5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:57:30 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38540 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab1JDG52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:57:28 -0400
Date: Tue, 4 Oct 2011 17:57:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the  tree
Message-Id: <20111004175724.b253f03270f1067531e5d95d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_17_57_24_+1100_Z8lDrzcNT4t5VkBw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_17_57_24_+1100_Z8lDrzcNT4t5VkBw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/staging/iio/industrialio-ring.c between commit 14555b14455f
("staging:iio: replacing term ring with buffer in the IIO core") from the
staging tree and commit 4903058fe223 ("staging: Add export.h for
THIS_MODULE/EXPORT_SYMBOL to drivers/staging users") from the moduleh
tree.

The former renamed the file modified by the latter.  The new file is
drivers/staging/iio/industrialio-buffer.c and will need to include
export.h.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Oct 2011 17:48:56 +1100
Subject: [PATCH] staging: Add export.h for EXPORT_SYMBOL to
 drivers/staging/iio/industrialio-buffer.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/iio/industrialio-buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/industrialio-buffer.c b/drivers/staging/ii=
o/industrialio-buffer.c
index 4ce101a..628aa69 100644
--- a/drivers/staging/iio/industrialio-buffer.c
+++ b/drivers/staging/iio/industrialio-buffer.c
@@ -14,6 +14,7 @@
  * - Alternative access techniques?
  */
 #include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/cdev.h>
--=20
1.7.6.3


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_17_57_24_+1100_Z8lDrzcNT4t5VkBw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOiq5UAAoJEECxmPOUX5FELbAP/ibj7BF2b9ZStSt45pUgqjIJ
gINsAfQXeV9wvMtY3RaQDvTBWg8ZQvN3XzresHjVKksms/YFnEfJ9vwKfmk8Lam8
b+kbUOidHAZBdj9LMo/VwySwyGnyCX7QLDXZmWiTuS1pKNlN60SKzQnUl05yfGgO
vLjDMqiD3ypKfkoPW8LP7o+EKu+/T5ira32UndiRSwWW2ZUK+0wYQV21PLIZ0Ovl
k7t1cvY+ELW9XCOiGXvvylkQSaez3L+4y/IP585aKQ+VwgT+DoOl0X7hw0mQIltV
r3JYGxRJRiY3LrJ4b5E42D4HBGuKdgK5hHpfs45gKVd9pxFKFNA7jHs7IoHfSyL/
N5uGMz/Ji1v4OZWmWJQfPEp77qKZj5HeMWnpCXCUVb4YyUKCsG/dSYIDzTBP9e6x
7hVX0+02JwG2PN95OVt13sRh9HKB6mDEIg1hqMYXYUsNdsi9C3q5XIY4t5M4My1O
Z5E6VdsXThBUwpxGtvM5E57sj7ncDoU04fiTJmPxmB54wt6YB7pSVtQDrc9vG7M9
wvm5rvNKoYFhx3VoLefy0bVgtASXjMGnFC/mu6UpVonXpuP5eNAhrB3aMZGg054Z
sC8uQMPgE9rNf4Qtm5KOvOazBJpFZKEC9cdcFthkY4nB2ZWvsjUUSZALK/0qWvV+
yKI3yJtOnbeHZR0QSJA3
=+9PI
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_17_57_24_+1100_Z8lDrzcNT4t5VkBw--
