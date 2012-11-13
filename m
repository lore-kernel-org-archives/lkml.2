Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2KMIcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:32:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49608 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625Ab2KMIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:32:30 -0500
Date: Tue, 13 Nov 2012 17:32:23 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tero Kristo <t-kristo@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/13] MFD: twl-core: Convert to use regmap for I/O
Message-ID: <20121113083222.GQ18224@opensource.wolfsonmicro.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
 <1352795334-7406-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJ8inJ6ig7iY3YX9"
Content-Disposition: inline
In-Reply-To: <1352795334-7406-4-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJ8inJ6ig7iY3YX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 09:28:44AM +0100, Peter Ujfalusi wrote:
> Remove the custom code to do I/O and replace it with standard regmap call=
s.
>=20
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--rJ8inJ6ig7iY3YX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQogWJAAoJELSic+t+oim9VdUP/0PPz7bZam2L+nwbVsze+imO
6hxO53FNukm+GZolqXifUaFhTKnrGJPhD8vZPMzZAuF7VM+gz5dMSKuFQD8mhaBr
K1l71bNWLp7kvLK9oTBTdB87yuc2BM7hcvyuNoliAWA2TvFq0z72uPeyPE8X+/9z
KJDPdlFW4KmLPJShO8tsVNsB6MAgPlrlNZhLpqHAU08gD8vlbXlvbWqhnytyJFIw
NcVqNV/zCwliPSvhL6Z6kdeo4yXezHUH3NJIOMUz4prr8D9f76zfuSYuLKDm9SP3
IGmVyvbtPBM11f8MkCtbQhByzRNjUsHcOqK7RK3+vCao4Gik2usKaNTLsZEZKEJG
XCAJ1uXYrNQUqk+ZkWMaubCU226BfJL/N6TRyBuWS6MCjrb3Uw/iK89j5QRpXa67
GiswiL56ghWaBVT4otH+HtunmhFmiwZSuCY7abGF6CMRdf1lcs7vZAVlcdSk+hQY
DYcZHnYk3JywDfjs7kS5Cc1UdiOlMb/9RupY5UwxIg+PyV4TDWS+Zz4/yPQJETju
SINuY1X2eqE6dANOCM2Pvt/fe+mKaLIHAKtR7tGDRKKcpG4dAsb7QxnouEkI+7bM
yl0lJWvDb6OdyYKv8bSBLStA6wV5Hgb1A1iHTMb5mgTYOa58nCb6+0GasFReEBgb
rg1R8HZ2K79TUWws983E
=axQW
-----END PGP SIGNATURE-----

--rJ8inJ6ig7iY3YX9--
