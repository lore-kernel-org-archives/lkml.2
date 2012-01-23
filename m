Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2AWEAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 23:00:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:52318 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2AWEAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 23:00:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="59002873"
Message-ID: <1327291230.2412.2.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH] [trivial] ixgbe : Fix typo in
 ixgbe_common.h
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Masanari Iida <standby24x7@gmail.com>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Jan 2012 20:00:30 -0800
In-Reply-To: <1327153774-2092-1-git-send-email-standby24x7@gmail.com>
References: <1327153774-2092-1-git-send-email-standby24x7@gmail.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-8ncX2673fNb1+63Ia/GJ"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8ncX2673fNb1+63Ia/GJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-01-21 at 22:49 +0900, Masanari Iida wrote:
> Correct spelling "packtetbuf_num" to "packetbuf_num" in
> drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
>=20
> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_common.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h b/drivers/ne=
t/ethernet/intel/ixgbe/ixgbe_common.h
> index 863f9c1..4c9a4c8 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
> @@ -75,7 +75,7 @@ s32 ixgbe_update_mc_addr_list_generic(struct ixgbe_hw *=
hw,
>  s32 ixgbe_enable_mc_generic(struct ixgbe_hw *hw);
>  s32 ixgbe_disable_mc_generic(struct ixgbe_hw *hw);
>  s32 ixgbe_enable_rx_dma_generic(struct ixgbe_hw *hw, u32 regval);
> -s32 ixgbe_fc_enable_generic(struct ixgbe_hw *hw, s32 packtetbuf_num);
> +s32 ixgbe_fc_enable_generic(struct ixgbe_hw *hw, s32 packetbuf_num);
>  s32 ixgbe_fc_autoneg(struct ixgbe_hw *hw);
> =20
>  s32 ixgbe_validate_mac_addr(u8 *mac_addr);

Thanks! I have added the patch to my queue.

--=-8ncX2673fNb1+63Ia/GJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJPHNteAAoJEOVv75VaS+3Ond8P/2atnuBScobgs1d/L2hRlK8f
011wJmVu2it3nqBtEB08RNrGOeQJqK8laRxWW0x/OcjY+Y8fxb95ftmcF4yI2Wld
9TMXQsFMWSvXPnx1wf/IG+sCH3hDGNOS7y8sXnM1Bo7JuQVZ4mJqrG7u7uob57uL
8iE9f2pn0dXglCnLY9Ln77AvIEt6f6ez9hZ5K+UvNU2UFKb7CU7/gYah/B74Zcpr
GzFLe7mAGWQZ/iUWSOKQz2XUm4H/uRh4/KTevrImGRy/z6lbx3fsh/7l87GHDz4L
3DPifZGyh5B68d4Waq89azhs3ooMiBEIC0g5dN9pqYAlQoPHBH+hYf91Yr+xrd7O
x0a0JOMEkXj2EdbiGcgLunfkHSfkM3aHoryOgAZLoiVMajfb1+Rmtl4bisGbzeeU
dLDBCcK7QJICO7DAwx/AHbak69u0LxBEILm9xDneaVrmdwz3ZrJDhT+k1u9i/ThY
wmZi5vcd5DybYgJ5SuDhPs67Eu62zrTvwWlfhqqRtGffQbssONNt7ET6E6cxMaoq
8atPhw+9qLOX00xVGpOemPr0Tp+y6YnNZH0W8ZUrho3U5xoGpRz1/1L+BmiJniPP
s38MHYmrVm+UIPtSgRo0+mOxFl8h1Y6gnrG/HD5R8OJhxagHQHrJQP9jav3dojPB
dCSGHvsuFc7sNFBwvBwJ
=NpA5
-----END PGP SIGNATURE-----

--=-8ncX2673fNb1+63Ia/GJ--

