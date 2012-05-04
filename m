Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab2EDRiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:38:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:63487 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab2EDRiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:38:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="140184639"
Message-ID: <1336153306.23481.33.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/3] do not use s_dirt in JFFS2
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: MTD Maling List <linux-mtd@lists.infradead.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 04 May 2012 20:41:46 +0300
In-Reply-To: <1336152428-24242-1-git-send-email-dedekind1@gmail.com>
References: <1336152428-24242-1-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-egIkzZ2fsrgLKGGFYCwP"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-egIkzZ2fsrgLKGGFYCwP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-04 at 20:27 +0300, Artem Bityutskiy wrote:
> This patch-set makes JFFS2 file-system stop using the VFS '->write_supers=
()'
> call-back because I plan to remove it once all users are gone.

I'd really appreciate if someone on the MTD list tested these patches.

--=20
Best Regards,
Artem Bityutskiy

--=-egIkzZ2fsrgLKGGFYCwP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPpBTaAAoJECmIfjd9wqK0EYIP/jHRSU1Kx22XWDmPvkKrMewT
gRn7LDDjMEp/XLd2F5LvMGxIuGSagNQNUIO3Tp+93+TpYwd+kTuz+zAoEeEtezyd
OdtH9yXT3ybLuOLC9sY3KtIAY61piLUoNWCN369FPc8aiKtEldJi3dknqTxPWFkR
6myEjpQJi10I0TXo2pC4mYx6rrLaAaDeQCHsIvKz5FE1xz2J60h8oWenoGcqUrAh
dI0BJ87f7knbRLOGs2mkGzyspKqRcewzUaLu1tAgLqlo5PrxN5cA0MldwFR+Tnf0
43xnnPUtuaLbSiHxCdPuoulJFpaf2uxCjqGwDzDiGdAcc/Zb2egfUTNOuQRWd7y7
n/w8/ct5EIgOwKBidxPfPvnFXdjkixqubtS+qSPmtSy7+haIsTQuip6xDH164XnB
mR/aI7ddjm9LlV8JAb/Cx1y8kjL5NWVObuh0lEp45YrPjjihI3TvWdzXhZ4+PCA4
rDfV9BIlwsejuEF6+NPV51u6wYBXfNuByMMdTG3jF6aw2oDIUfUHPrcAexJasdsy
BUUiGR2mwmJyVMLAIjtk8KAdl4u9qb9pkiwhvxUa3il6/EJCkWlBs/UXNJGsx9OW
xr+6BAp+ORlQULOOVcB/OvNSgje0qmnMcp3MDEGM+yOCCJfzsCt4vHMv8j2YHmKM
IGRwmTm2iMGYVcB2UFn+
=BS5m
-----END PGP SIGNATURE-----

--=-egIkzZ2fsrgLKGGFYCwP--

