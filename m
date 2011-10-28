Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab1J1U7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:59:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:55347 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754Ab1J1U7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,420,1315206000"; 
   d="asc'?scan'208";a="79090427"
Subject: Re: [PATCH] i825xx: Fix incorrect dependency for BVME6000_NET
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Oct 2011 13:59:43 -0700
In-Reply-To: <1319835212-19473-1-git-send-email-geert@linux-m68k.org>
References: <1319835212-19473-1-git-send-email-geert@linux-m68k.org>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8HDf5rpDQEnJ6HlDZLj+"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319835584.10258.159.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8HDf5rpDQEnJ6HlDZLj+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-10-28 at 13:53 -0700, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/net/ethernet/i825xx/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/i825xx/Kconfig b/drivers/net/ethernet/i=
825xx/Kconfig
> index 2be4698..ca1ae98 100644
> --- a/drivers/net/ethernet/i825xx/Kconfig
> +++ b/drivers/net/ethernet/i825xx/Kconfig
> @@ -85,7 +85,7 @@ config APRICOT
> =20
>  config BVME6000_NET
>  	tristate "BVME6000 Ethernet support"
> -	depends on BVME6000MVME16x
> +	depends on BVME6000
>  	---help---
>  	  This is the driver for the Ethernet interface on BVME4000 and
>  	  BVME6000 VME boards.  Say Y here to include the driver for this chip

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--=-8HDf5rpDQEnJ6HlDZLj+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOqxe/AAoJEOVv75VaS+3O9EgQAKUSmrrm17K6UWLBy3tqLiAQ
BvfENVj/ZpcFEVRHSA2HV2ItyXlkOjA5fWQFCnMOVMAsHGyX+6N4TJ6inRfniPyw
Aot7lpHt/XftMuqR86ggXT/Q0pTemewFQpAXJilIStKPByVh1nPyPS+A1d3jYUXk
0fjkLWt8cQ1s+hc9aT9LCOQcmORJv6+xAM73aWd25I8cMo8FUKV63bAyFCQZ4PQl
lw2axNf3payF2v1dRYcRubBfwN3SrXL4ZbvZTtafx453xCnnZoc3vuKQ/tO9TfMd
bccjIaAoEzscheEoR+UkyFKphlo/9qg2/mrksv0mWVO01Ai+UepffmD6svyB3EfT
7KtjFD7cDNPS3pSjP2U9TV0lexwpGMXP1pFokML9QBg0t8SkTFHJFK/JTtkSsfub
KJN5YVn+vw/0J2qXkGwNSvPb//37dgiZBbg1xiyukSk091t/oiBYXyiqLG/Rt3+X
zoRr9dxLTV0Pz0Cc7Gh6zb08zeQAlzE7Crr2LyaE+4A0dLoeCigAWlVFODBehRKM
03UMQ7C/aQ0h3dUrN5guwDF7tCzLHXuWCqX4Sx+Ku81BSUg1KI2EmcufJ77mVe5m
S4xj3fN7+b5fgslvMnXCsZ/R0lJYD6i61cZs9wlC7VahGRee6HxxpvJu2roqBjhv
3Kbtpz3Nc6xX+5PfXd1L
=5mew
-----END PGP SIGNATURE-----

--=-8HDf5rpDQEnJ6HlDZLj+--

