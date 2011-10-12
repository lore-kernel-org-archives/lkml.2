Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1JLW4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:56:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:4737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab1JLW4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:56:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="62376634"
Subject: Re: [PATCH net-next 0/5] intel: Logging cleanups
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Oct 2011 15:56:21 -0700
In-Reply-To: <cover.1318436085.git.joe@perches.com>
References: <cover.1318436085.git.joe@perches.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AcewzO/0y3crV2Fc/8tc"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1318460181.15319.11.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AcewzO/0y3crV2Fc/8tc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-10-12 at 09:18 -0700, Joe Perches wrote:
> Just some conversions of printks to pr_<level>
> and some trivial defect corrections.
>=20
> Joe Perches (5):
>   e1000e: Convert printks to pr_<level>
>   ixgbevf: Convert printks to pr_<level>
>   igbvf: Convert printks to pr_<level>
>   igb: Convert printks to pr_<level>
>   igb: Convert bare printk to pr_notice
>=20
>  drivers/net/ethernet/intel/e1000e/netdev.c        |  232 +++++++++------=
------
>  drivers/net/ethernet/intel/igb/e1000_82575.c      |    5 +-
>  drivers/net/ethernet/intel/igb/igb_main.c         |  155 +++++++--------
>  drivers/net/ethernet/intel/igbvf/netdev.c         |   14 +-
>  drivers/net/ethernet/intel/ixgbevf/ethtool.c      |    6 +-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   26 ++--
>  6 files changed, 201 insertions(+), 237 deletions(-)
>=20

Thanks Joe.  I will add these to my queue of patches.

--=-AcewzO/0y3crV2Fc/8tc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOlhsVAAoJEOVv75VaS+3OdFcP/1JkwHu8t9ckGDKtBgNeZLi0
eCv2NUAdUg7EeSp9pmgQIZgEhv5hSMgmLpn/qZebkR11MEEeEwrfZiFKCn6Z91bK
lOxQq8JIf8stasg1TadlOBg7b1JgxCpdqJng4MAeVubWBzkiGP7IGQ8pcZnvX5/u
QzeeWtzDieCtpT5TSADZuZ5Yc7vuA0AvCX1q2CwyzS1HhKNUBhpUMwAFd9bSGTgj
80XDluZ5IzYE/k8eQQgymzFYm2ZZ1q03RPEJcS2gsi9BJJAGabE6ppBi1chCqvmR
Qy06k33gkhpiwNFPPi4jnFg7Uz0y1RYgfwzvhn6ZeuRpo4faPhgeMEBotvyOR5E6
n6u+p9ckWVNprazC8LQ44FMsohFSvez2rBBEIlM22WYAby6Qw8f4N2Mhperf7Wcu
ES9qO1LWuU0/jqhOlV3I+NLLoptzrC9HplOeiV5y+nG0PDss5CSh2xto1jQ76e3S
p9VVz4ndWbxqtrnZRVgFLIFj5DSR+3YWeIA4Uj+W6s5Hd8EprYgerAa0gyTrFzcO
8W0iEWcI7eDRp31QbeZxoXy6jiUVYg4OD7PkqV0eg/E2AT6STm6ttMz+12Nb6bdR
Cm8kbhk7cshJNU87OfMxrX359IsCRPCroyHEc96V9qq8CvZSOucEc3ownp2kWB11
ASPc3XUAzrSCyNcjUhro
=GajS
-----END PGP SIGNATURE-----

--=-AcewzO/0y3crV2Fc/8tc--

