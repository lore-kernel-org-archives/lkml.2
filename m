Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2LTIK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:10:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:13642 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2LTIKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:10:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="asc'?scan'208";a="234404305"
Message-ID: <1355991091.4106.64.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI changes for 3.8-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Dec 2012 10:11:31 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-idqWTdFJ4Wz2A44gfrt5"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-idqWTdFJ4Wz2A44gfrt5
Content-Type: multipart/mixed; boundary="=-iCT7nJabTiKRDAkOsVlT"


--=-iCT7nJabTiKRDAkOsVlT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please, pull UBI changes.

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556=
:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.8-rc1

for you to fetch changes up to eab737722ed6a5638f6251e83f0d293c2ffe549f:

  UBI: embed ubi_debug_info field in ubi_device struct (2012-12-10 13:38:59=
 +0200)

----------------------------------------------------------------
Nothing exciting, just clean-ups and nicification. Oh, and one small
optimization which makes UBI to use less RAM.

----------------------------------------------------------------
Artem Bityutskiy (1):
      UBI: do not allocate the memory unnecessarily

Ezequiel Garcia (5):
      UBI: gluebi: rename misleading variables
      UBI: remove spurious comment
      UBI: replace memcpy with struct assignment
      UBI: introduce helpers dbg_chk_{io, gen}
      UBI: embed ubi_debug_info field in ubi_device struct

Wei Yongjun (1):
      UBI: use list_move_tail instead of list_del/list_add_tail

 drivers/mtd/ubi/attach.c  |   23 +++++++++--------------
 drivers/mtd/ubi/build.c   |   12 ++----------
 drivers/mtd/ubi/debug.c   |   34 ++++------------------------------
 drivers/mtd/ubi/debug.h   |   57 +++++++++++++----------------------------=
----------------
 drivers/mtd/ubi/fastmap.c |    6 ++----
 drivers/mtd/ubi/gluebi.c  |   28 ++++++++++++++--------------
 drivers/mtd/ubi/io.c      |   14 +++++++-------
 drivers/mtd/ubi/ubi.h     |   40 +++++++++++++++++++++++++++++++++++++++-
 drivers/mtd/ubi/upd.c     |    6 ++----
 drivers/mtd/ubi/vmt.c     |    4 ++--
 drivers/mtd/ubi/vtbl.c    |    2 +-
 drivers/mtd/ubi/wl.c      |    7 +++----
 12 files changed, 98 insertions(+), 135 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-iCT7nJabTiKRDAkOsVlT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: base64

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQpM
aW51eCBNVEQgZGlzY3Vzc2lvbiBtYWlsaW5nIGxpc3QNCmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQu
b3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbXRkLw0K


--=-iCT7nJabTiKRDAkOsVlT--

--=-idqWTdFJ4Wz2A44gfrt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ0sgzAAoJECmIfjd9wqK0lCIQAKyll3GsxQHb5YqKcFihaf3C
MHsKQ0OSfMnzIZxqKe+rqSxf+uV0v8HZgvKbw9K/zM6l3Eo22PxtqRlN1YEXbo4u
WVQ82mCD/vBmWKCKifFuu7x7wO8rPuaAtCR62RsJECRH2hg/JPCpurNyDLUQGH95
4URUwHMz2H8fB5FvMdpA9AUoFfTaC+TZjBOB4nQl/XmP7JWxKzEiaIDsA+w/C6N6
fBNhdNYmPlC5tuluRMdu3/JEiRfapwFxlPVd6Njs5TG+9hMf9li7uyx3oZbvK2mY
loNGnwQefuTJnsWeVhzBnUhHguR8nNlS+Qmq/KXyoUVafwOLZxCRvOGbU0qhhfxD
Y26DvOuNzBaKvrZy8MkwB91vvokwmndduts6mvRzOZYLYcSpw3KIhBVvKDKl1ag6
ylPGJ+cTiFmx+PKyX0DzsZh5z3LXuzoFuo55TT+QxNmjZ3ujoEXXrCRAr5HeRX4P
NLrXxc/9O1m3phydbRuxw5l0X4W084Ty4IPrxoIaiu+hadZ1kJoeheddqFEKwEEi
Yy2BsLYTx8PBB2BiFEGNzJZnCmDbb9Myn6y/MNl1YBKz4U8fBYeqHmVQmZIfdCge
dBLK08O6wGzltv4eTekR7Lf1jljYb4U+SXMFMjfthDUNRZIlXNULhEbg7rMSUha/
Ax/OCKU6+IzpEKjR7T6z
=BJMn
-----END PGP SIGNATURE-----

--=-idqWTdFJ4Wz2A44gfrt5--

