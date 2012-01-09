Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2AIOE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:04:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:10801 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab2AIOE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:04:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="105070181"
Message-ID: <1326118036.6755.101.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI/UBIFS changes for v3.3
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Jan 2012 16:07:16 +0200
Organization: Intel OTC
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-EbR7Ewg5EgJ6ZhUSB2dC"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EbR7Ewg5EgJ6ZhUSB2dC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull UBI and UBIFS changes for v3.3.

The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37=
:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (1):
      UBI: fix use-after-free on error path

Bhavesh Parekh (1):
      UBI: fix missing scrub when there is a bit-flip

Thomas Meyer (1):
      UBIFS: Use kmemdup rather than duplicating its implementation

 drivers/mtd/ubi/eba.c |    6 ++++--
 drivers/mtd/ubi/ubi.h |    2 ++
 drivers/mtd/ubi/wl.c  |   12 ++++++++----
 fs/ubifs/lpt.c        |    6 ++----
 fs/ubifs/tnc.c        |    3 +--
 fs/ubifs/xattr.c      |    6 ++----
 6 files changed, 19 insertions(+), 16 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-EbR7Ewg5EgJ6ZhUSB2dC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPCvSUAAoJECmIfjd9wqK0VjEP+QHyu+8Sb82nbZvsozUNmJRA
A0hivGuZafARdRMiqZ/sTH11gdl0+n7AXNYjyCurlNSvxb1golbJt+P/H7GbZpFg
Hf21M1iRM79sgwDtK/s6Z4SnAd4N4lJSy1Q1lpp6U8IZ783dVBtzjgV+Y9Bgh2ox
CA/ZSOdL9YdkIDA82V/P+5NIqBAiNYPqXPa8m9G6oXwXF07qzeURPvOfsu53/ywm
1qYT0yDWv6HdSYX8ZUflDu0dtk04dddxsx7slo/0p91kp02Z6WOoz6XTZUj5Qp7S
iUO5VDUnKoub7cJ/JogzorBFjtJj2WctvDLOo/CBCctQQZJOE/kG6ApSy8uP6ErU
t10z4KPzJGe0WkCLRha8fQBxW14KwXNNVSTE6oO4Z/OmQnWVtTDR7bUgfVfNADQ0
4gnSybRiMmwBLOXyVbZqdgaR4Nc37qIqAYSZjddb4ut95bJwVp9iaAPa+CaYLFW+
UKZnzTJqXQtSGZNNjVU5FTZ2jJE5/2OAe0jgYz93bgbYzBOf1FBLI2le75IYjAr4
bmOK3AhMqyA5Z479ZcCJjyxrqmClR/jBUdIgedHKlJf7SDoWG8qxMUA1a1oZBLcw
VkFzm6WJjCLAzlbWiR6AmC1QVw5ZI/J3RlCV2MEJJw24FD6jlTELIfq7HjV26wU8
TDfigQkvwQo6F1iaTarM
=rO+1
-----END PGP SIGNATURE-----

--=-EbR7Ewg5EgJ6ZhUSB2dC--

