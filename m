Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2HaLwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:52:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:56244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab2HaLwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:52:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,346,1344236400"; 
   d="asc'?scan'208";a="216651041"
Message-ID: <1346414255.9709.46.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/2] mtd/nand/omap2: fix omap_nand_remove segfault
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Andreas =?ISO-8859-1?Q?Bie=DFmann?= <andreas@biessmann.de>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Fri, 31 Aug 2012 14:57:35 +0300
In-Reply-To: <1346412942-4015-2-git-send-email-andreas@biessmann.de>
References: <1346412942-4015-1-git-send-email-andreas@biessmann.de>
	 <1346412942-4015-2-git-send-email-andreas@biessmann.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KtaGsJYjTBS7yDjIXg8R"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KtaGsJYjTBS7yDjIXg8R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-31 at 13:35 +0200, Andreas Bie=C3=9Fmann wrote:
> Do not kfree() the mtd_info, it is handled in the mtd subsystem and alrea=
dy
> freed by nand_release(). Instead kfree() the struct omap_nand_info alloca=
ted in
> omap_nand_probe which was not kfree()ed before.
>=20
> This patch fixes following error when unloading the omap2 module:

Added "Cc: stable@vger.kernel.org" to both patches and pushed to
l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-KtaGsJYjTBS7yDjIXg8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQQKavAAoJECmIfjd9wqK0c+4P/0FMKVZMEcG01eJoNVofSLT5
LcjkPBboCXCOErDfH528VRS4F4hnhW49pYm3DfUGooXGDgMGTUv4OiYWKiNUABJ0
bPz6hL94Q43ax8xS6QmUqBFiyDeWIoPDa8hxpnjz3I9pvE8ksyT7hR5lGxeN8clh
pjaQ/AvoIYVI470/HRPuiXkokKWiOFOunANeL3UpbzFGth/DBMtFpQsJue+8YHkW
56YGPEjnWdn3ECOVsNqfo0zmUDhQdXZRSHb8kPcBC/4utBHyhG3RjAImNZl6PsI3
myU/Hopqu4kXMRxfh0tDGzh/nfzo7WB7BJ9hC5Z2YlZejdhzEV4ooRKOhBa/bzDl
sY9OQW40ikEo6q6HUH6SL/3G3Q0yt0LhHnJSePy9PTxOyJyxYtOxOZPwZ5Jj1+U1
ohhrDDnOIe7yqQOn7H6+Q5dsGFa9BbjdouEvfwjKZtNR11y7LajmoxNjYqyNf3fD
gLXR+dX44+3yOn8LedZal7uJPUjTliWocITRkCvCSLQtZA0XwT2qpCTzm3bH/TdL
zMoHvB520xIa/oUBsfSXJlDM0tkeItV6rfTGI8GtPzx7Nn/COlNAHapykZWJMEzU
HetPUwlGK/PDuU1zYcDyw2Enm8BNxXrh/MAzQV0EqnZ564IvkFQBYXLAeGmEQiag
OVnkCcbZui4ufffXGUkW
=TSh3
-----END PGP SIGNATURE-----

--=-KtaGsJYjTBS7yDjIXg8R--

