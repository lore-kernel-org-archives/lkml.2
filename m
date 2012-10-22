Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2JVAXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:23:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:7057 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2JVAXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,627,1344236400"; 
   d="asc'?scan'208";a="158731789"
Message-ID: <1350865421.2213.25.camel@jtkirshe-mobl>
Subject: Re: [PATCH] ixgbe: Use is_valid_ether_addr
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 21 Oct 2012 17:23:41 -0700
In-Reply-To: <1350750159.10791.3.camel@joe-AO722>
References: <1350750159.10791.3.camel@joe-AO722>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-953l/TXGfymRTlcP7H7j"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-953l/TXGfymRTlcP7H7j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-10-20 at 09:22 -0700, Joe Perches wrote:
> Use the normal kernel test instead of a module specific one.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> found when doing that larger style conversion,
> might as well submit it.
>=20
>  drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c  |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 27
> +------------------------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.h |  1 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |  9 ---------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c   |  2 +-
>  6 files changed, 4 insertions(+), 39 deletions(-)=20

Thanks, I will add this to the queue.

--=-953l/TXGfymRTlcP7H7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQhJINAAoJEOVv75VaS+3OOn4P/1Wgf89gBPREwPPDkErPDHMZ
VmiHRCqJ92esGTRtHjuhdE5aDmY1sS0ozy3E4RKTVS7mtFxknf3cG7tFcfMKQVae
+d/U1FYLPgnPJBUO9s1ayj0uRJwbPtcIwUx1iU6QxSHM/lUHMlUdfD4eqwkA4YMd
VCWrc46+UyAZ3qCfLoKBTm+nSoJWEW9oBPveW8rZUIkR9MrdcuSZSYOq2GCviVas
7rw3SK/b1WHkSqfGCec6yVRrpO9mhvLDLmgo21E9a6AwBhToIzlWnTu5MnEPxrDo
7KtykB6KrbY1o6B76lIRLXcEhHvgCXMXM+oUmR5wI8H8KwJAUVUcQ6oF3aB3kCtt
ysuK1oDh4r9Yebp8ebjJWneyVbRyEMHRHsrI5WJRUmGtA82oe8a5OSeKtfO880Ev
eyWiyHC28ON8s4f+NDXzs/z1lYg0Atc8OrIB17jXIAdzQDcizmPhZ5Z8g4W7j39G
5vpnLguvZjIPm6h0Zj0tG/yeYDUicPMor5JysJS2+WK9KmEW4DFbjqdTolHVJ6Bx
GtlzlzZJPUDuqAxJsCqrOxb2i/snajK/dVb0GvpMSqPsMOhbXPn11I/g1FRmC7CR
eIBf4cxNWHTztpcdSWpY0WqyA3jbrTgPsaYpFDaYC+AIFm/2F1hVIKBS7TaPU/bb
8Gn/LILnL4gnjRU52T9P
=kXT/
-----END PGP SIGNATURE-----

--=-953l/TXGfymRTlcP7H7j--

