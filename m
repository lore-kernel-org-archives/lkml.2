Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab1LUDyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:54:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46549 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947Ab1LUDyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:54:43 -0500
Message-ID: <1324439664.2844.184.camel@deadeye>
Subject: [PATCH] firmware: Refer to the co-maintained linux-firmware.git
 repository
From: Ben Hutchings <ben@decadent.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 03:54:24 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-K9skWnssBZfj1f24dLPs"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-K9skWnssBZfj1f24dLPs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

David and I are sharing maintenance of this repository.  Patches
should be sent to both of us.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/README.AddingFirmware |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/firmware/README.AddingFirmware b/firmware/README.AddingFirmwar=
e
index e24cd89..ea78c3a 100644
--- a/firmware/README.AddingFirmware
+++ b/firmware/README.AddingFirmware
@@ -12,7 +12,7 @@ here.
 This directory is _NOT_ for adding arbitrary new firmware images. The
 place to add those is the separate linux-firmware repository:
=20
-    git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
+    git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.=
git
=20
 That repository contains all these firmware images which have been
 extracted from older drivers, as well various new firmware images which
@@ -22,6 +22,7 @@ been permitted to redistribute under separate cover.
 To submit firmware to that repository, please send either a git binary
 diff or preferably a git pull request to:
       David Woodhouse <dwmw2@infradead.org>
+      Ben Hutchings <ben@decadent.org.uk>
=20
 Your commit should include an update to the WHENCE file clearly
 identifying the licence under which the firmware is available, and
--=20
1.7.7.3



--=-K9skWnssBZfj1f24dLPs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATvFYcOe/yOyVhhEJAQqwuA//W0vVhnYBQvTB0Tlm8Z6ltcJClxSLVlg1
ycR49Rt631P2PxSKPr8us7YUktiSna+l07tLrYhFTikxsGEmlkiPPaOe54yTw0Rc
g5elH7KDh128HSqhFZ9/DM6Iab5Ak1TMhfgsrbo+H6VBjkYkZD7Q/+OdQ4z+Mumy
LFGi9MrEwu39umBJNVgZaiXGWVDc3j9/ujXz8HzkbkQQu4ONkli3/lh5nkbRBMSW
IrMULBTdF+8swu0j4tATsaxwSoqlAo3HsKlQAHym3qh3m+2WkAybz4KFiq1BPUq4
uOpYkiTJIRCuQ4+9H6KdciLGHSbjqWYV5kWDoIrl17cSgKJfP2MDxhjRfhBOF0Aa
J7hDNpwQrb2a+O0Y24dBF6pBq1rk4dZzOKHwGqmlUK2xi9aFP//8PIIDgtMoGwzk
WlBJ6kvWAK8liXP+QGxrJt5tH6i0lYGOPstSdhh6WH+Br2CWdj0orFeSeZlM0KMo
z7jq2BvX9ARlMtJVLSzryD4lSy49bnQa8b/VZ5tNA5YKbGNgTfYeh21mlGjPnwgW
jgcPoSN443qCZ8aC88mak5cybesOBk8de0No2x30RvvFtxIABRRQqUsw3pZ4jgyL
a8yAst+EMS5mENNvzihv1cFQCstaDKh9o3GncvIzTmomlWKhXj+17aU6PAfmLI3w
1bIfyuzLeO8=
=i+5b
-----END PGP SIGNATURE-----

--=-K9skWnssBZfj1f24dLPs--
