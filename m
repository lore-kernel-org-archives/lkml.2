Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2BIUJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 15:09:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:2559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab2BIUJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 15:09:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="105795722"
Message-ID: <1328818164.3639.15.camel@jtkirshe-mobl>
Subject: Re: [PATCH v2 0/2] Part 1: handle addr_assign_type for random
 addresses
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        e1000-devel@lists.sourceforge.net, Neil Horman <nhorman@tuxdriver.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Hemminger <shemminger@vyatta.com>
Date: Thu, 09 Feb 2012 12:09:24 -0800
In-Reply-To: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
References: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mFZkc5zcZS20KZWL9YHM"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mFZkc5zcZS20KZWL9YHM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-09 at 20:48 +0100, Danny Kukawka wrote:
> This is an updated and split up version of my patch series to
> fix the handling of addr_assign_type for random MAC addresses.
>=20
> The first part contains the basic changes in etherdevice.h
> and eth.c incl. needed adaptations in the existing code
>=20
> Danny Kukawka (2):
>   eth: reset addr_assign_type if eth_mac_addr() called
>   rename dev_hw_addr_random and remove redundant second
>=20
>  drivers/net/ethernet/intel/igbvf/netdev.c         |   11 +++++---
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   28 ++++++++++++---=
-----
>  include/linux/etherdevice.h                       |   13 +++++----
>  net/ethernet/eth.c                                |    2 +
>  4 files changed, 33 insertions(+), 21 deletions(-)
>=20

Thanks Danny, I will add both patches to my queue so that we can
validate the changes for ixgbevf and igbvf.

--=-mFZkc5zcZS20KZWL9YHM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJPNCf0AAoJEOVv75VaS+3OUAMQAJ0eMnzEZ9MY1r9GhWvKiGC1
LacyFg9KzTypNtj5ptYzGhfyLsacOkdE0Ys8/rly56oX5YqS6C/KWK4V68rWSOF0
Nc4VWEua93LYjqjVr9b2uZpe7YQV3g61R3C6Tk0YuFeug+/FP77SHDbjohcGSHhY
74W3m6Mp42mhgINKkdxCu+kwH7Td9RS3LItklQfWKuPzDvxI1uv44kkwzPyOthwg
hmNcHu7/WsSSLe3qo9Pp9nEFoPxdoJv1Kzq9eSDM9E3Pw/QOyZVWuGb5YKGhh6us
Zyu5XPkmNPApgzPzPfUWdeoPEWN3T75ynoSU6/Nz8zqoPRXyXFksqNmOSsSLvsL9
6436gyOaXDSH4mOh9NG6ET3egZuvPr0xRsBNmugv/+204Fa+y3gWl+rHizskVb3H
S4ObdOTzsQmiRzmxsRgW0q8IEEZ/z8zJrK/G1aUCIwS+m4i3RqyQg/BBCDYCO6J+
s1IW01t+CeQCanym+Ci/7Ed3vQ2DE10FihvVHwBfV4isMMwm14W2CVDHUlg2AubH
3/23HWmXYJen+wEUcHJt7AG/EjLy8dUUwJNl5E4LF8ZwnrZiOAyabnVIrQkcJiRY
0WoZFMmjMkRiclA6gIHZhmaeBNuQyuLfIVf575HXsSDjFbsp19q/d7zvmgCS1kTO
HGMKs6v4WBLqmTZ4HODC
=Yb6x
-----END PGP SIGNATURE-----

--=-mFZkc5zcZS20KZWL9YHM--

