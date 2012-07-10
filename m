Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2GJWnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:43:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:44049 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab2GJWnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="170117808"
Message-ID: <1341960208.3336.43.camel@jtkirshe-mobl>
Subject: Re: [trivial PATCH 2/7] ixgbe: remove unused #define
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Jon Mason <jdmason@kudzu.us>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>, netdev <netdev@vger.kernel.org>
Date: Tue, 10 Jul 2012 15:43:28 -0700
In-Reply-To: <1341959492-31389-2-git-send-email-jdmason@kudzu.us>
References: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
	 <1341959492-31389-2-git-send-email-jdmason@kudzu.us>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nh10J2jWcd8YKmbJknqJ"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nh10J2jWcd8YKmbJknqJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-10 at 15:31 -0700, Jon Mason wrote:
> Remove unused IXGBE_INTEL_VENDOR_ID #define
>=20
> Signed-off-by: Jon Mason <jdmason@kudzu.us>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Bruce Allan <bruce.w.allan@intel.com>
> Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>
> Cc: Don Skidmore <donald.c.skidmore@intel.com>
> Cc: Greg Rose <gregory.v.rose@intel.com>
> Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> Cc: Alex Duyck <alexander.h.duyck@intel.com>
> Cc: John Ronciak <john.ronciak@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |    3 ---
>  1 file changed, 3 deletions(-)

This should also go through David Miller's networking tree's.  Adding
netdev mailing list.

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

>=20
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/=
ethernet/intel/ixgbe/ixgbe_type.h
> index 204848d..c8d8040 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> @@ -32,9 +32,6 @@
>  #include <linux/mdio.h>
>  #include <linux/netdevice.h>
> =20
> -/* Vendor ID */
> -#define IXGBE_INTEL_VENDOR_ID   0x8086
> -
>  /* Device IDs */
>  #define IXGBE_DEV_ID_82598               0x10B6
>  #define IXGBE_DEV_ID_82598_BX            0x1508



--=-nh10J2jWcd8YKmbJknqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJP/LAQAAoJEOVv75VaS+3OEG8P/An8AAcBPEMJ6sPzjdrmqn+6
rLUseT98PXJ/z1t2uO+k1Jjf3hTiXdwVtGtYaogAvtYoEHLJB1Zgef5BmXHg7+om
fkALZcQSDIVHll5bTwNu1E7lU5O1kzPMlFM6JNp6dKEVj3EoWbitriaf6nFDVlIY
L6isFnohHmR8tE5HPSrvrN11zqmuxOK5INGQJ27MMPrL2YEuyik7mNPwiw0hnmf7
MS2jAhk/mncMk/Pi5O+cdW4UJMeu3OV8shDiH3QEzggIMknQCCyZ2xMobIw52vVy
ky3T102rHLUtI9gOjf2lTJowFQo6BreVKi/4WEwRJYKg9/suvUqBk69G8PfAyOXk
FlTpY1MmeYjoE0Z4Z35s/ASkrugpGwrMJgavWLn2JaaQ6aEGKLWxM+ppwOdTbIJs
42+eBbm0Pxkot3MVgNJSgFa6qlVuxw27yrYMGLF1sjPY1NZeXwRJdxbItc5NDJMU
WJYkNjsoxl93Xv9DY7p3e0yP5u+O7w6GtAHzZo5Ovf7ifFWm80dyMI7jcQlaybAU
OTHQa3ybEA/ahDiwqxcVj9S3vtPVOYazQ8wE/VmFyRV9WhwHyyo++9sTgFaFtdYw
Zq5ay0+/GB03iG/Dq411Io9H58KwmWEO6hBkBdgv/9MYtrG0QwIEXF8Ddlcz3qdQ
IKs5DyBhrno4uK6/cnPA
=UGm1
-----END PGP SIGNATURE-----

--=-nh10J2jWcd8YKmbJknqJ--

