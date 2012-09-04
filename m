Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2IDGud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:50:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:45440 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab2IDGub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:50:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,365,1344236400"; 
   d="asc'?scan'208";a="217458929"
Message-ID: <1346741717.12610.2.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI fix for v3.6-rc5
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Tue, 04 Sep 2012 09:55:17 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YJrQSloZuBECx7+4bhOT"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YJrQSloZuBECx7+4bhOT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d=
:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.6-rc5

for you to fetch changes up to 78b495c39add820ab66ab897af9bd77a5f2e91f6:

  UBI: fix a horrible memory deallocation bug (2012-09-04 09:40:26 +0300)

----------------------------------------------------------------
A single small fix for memory deallocation: we allocated memory using
'kmem_cache_alloc()' but were freeing it using 'kfree()' in some cases.
Now we fix this by using 'kmem_cache_free()' instead.

----------------------------------------------------------------
Artem Bityutskiy (1):
      UBI: fix a horrible memory deallocation bug

 drivers/mtd/ubi/vtbl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-YJrQSloZuBECx7+4bhOT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQRaXVAAoJECmIfjd9wqK0tmgP/2PPgUGK+4Mk5SZ/rVkAJZ/2
ZYMIdl3Z10CIkJFTfBk1gZPjNde3bureMlG0PyqUK7a3ZCNJAR63fljg+fNxWdVi
vWiRynYhhETje+c3pOXO90ib5BiZ7MeWpOaq1JmyKXbhidzGtTjkCBAvuaKU2HeT
Ca7buy6kpdEbW9sWmvAWNcgnH97jKihVCfqui4t+20B080TGA0NiHesEfz6Ldu2w
GtmPbTLbl6flR2Lc40qi8JzSuuPHfwqkGb3Ry8M3SyhEq2M1RP9JRZDi/hx+z8j8
WVAE8ekDoCstX+ZXyr/2e2obhUqo2znBtAvDwLROWUN/GObyft438xe3C3SQCipD
2l7WXa1jrUfgF3WHqORKw3YXLjJsJMkht6L6bxYtAoZ84eyaHj+5b2V1PbM/N03a
YKlKcM18JthUg+xBtcAtDmfazYSVeH12Bv/YTAcy30UG6pfMCIiMqQolmp77591w
qevdvMUFYI76fFCDyaQfDFaI8r6K1WyMgZ0G0FDG85XtTtXQGmSexZOsap1yweCC
dhzDuFILdjR+sKfU9YQ51QW8M2BpcPY8sdVu6FaEgXuHtIiKgYiEvSmqqazAnhQG
knRXnVDBGsldPHziuir+DexQMT9iinVCLA0+XUjTAPaf9SpRGXkPGVHiyPHyymuR
ZBRGDkUjX0Ikq5ZyC7TO
=LIkx
-----END PGP SIGNATURE-----

--=-YJrQSloZuBECx7+4bhOT--

