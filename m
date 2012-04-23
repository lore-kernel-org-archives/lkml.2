Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2DWXSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:18:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:35905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab2DWXSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:18:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="135858542"
Message-ID: <1335223095.2783.12.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH 1/2] e1000e: Disable ASPM L1 on 82574
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Chris Boot <bootc@bootc.net>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        nix@esperi.org.uk, linux-kernel@vger.kernel.org
Date: Mon, 23 Apr 2012 16:18:15 -0700
In-Reply-To: <1335216578-21542-2-git-send-email-bootc@bootc.net>
References: <1335216578-21542-1-git-send-email-bootc@bootc.net>
	 <1335216578-21542-2-git-send-email-bootc@bootc.net>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Xk+shQirvZbQrZEHQliK"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xk+shQirvZbQrZEHQliK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-23 at 22:29 +0100, Chris Boot wrote:
>=20
> ASPM on the 82574 causes trouble. Currently the driver disables L0s
> for
> this NIC but only disables L1 if the MTU is >1500. This patch simply
> causes L1 to be disabled regardless of the MTU setting.
>=20
> Signed-off-by: Chris Boot <bootc@bootc.net>
> Cc: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
> Cc: Nix <nix@esperi.org.uk>
> Link: https://lkml.org/lkml/2012/3/19/362
> ---
>  drivers/net/ethernet/intel/e1000e/82571.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)=20

I have added the patch to my queue, thanks Chris!

--=-Xk+shQirvZbQrZEHQliK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJPleM3AAoJEOVv75VaS+3ON4kP/16r+EnFpESXHKRXrCCvmKsm
Jr/ICtvj6GC9nWKt1ZU0hxWwUtA/ycNNolTMuqfK/gxhtPR+qDMXfQLjD1NWNP8B
wBD2gM5HyLUXYYoYFCx+6o62Pw76GbPx9qzYGusXKGxmSpjrTm1qGhn9VJ540ZAo
YCSQetmBcTcm1Yiq6aywZ+nsTUqx5iTYjO+Ee8QUlTmvriE43SCDQ5FmV3ckLQN7
ceuwg0PHgLLx4RDEurPu/9qDAEMp5Luic9o/3qEMDDYCitQTbEmi6UB2kFo5muzT
+LqRm+egRQDL0SVnhRVzRB+7/vUL5kc7pjsSYAYFwRsxzwcZH5HvclVaqtf9Axv0
Xnjf8M+aUn7mMdX7zMBJtjMJLdXSTGoIw8aDt/PtAkOdXqXtPoKDxoSQH3Q8vXvt
dpumsloZmP3gaPevIG+XlSjYOyPXNG2Gn/OCsI1FXZPzY9w7ppD1AH/MeH7rq/u0
1jbpLR3KgAyElyJdQZqJBUfp4rK5zo6Z71LXcU4nHViWkzBYmcb9/zNCvcYkYmK0
AemXp+lvgb2lvTvdkXJSiflO2Nj/XW3guhxhVXk4sLXx3JWegydvEoUOE/TyCiW2
a6nEqLRi78WO3y/tVKFUvgnLnzwGIBcImBbm5Fz79LFACAa45DG8aP/RHyT00X85
y/bVyg9HU9B6lkNcH/f7
=7Vpi
-----END PGP SIGNATURE-----

--=-Xk+shQirvZbQrZEHQliK--

