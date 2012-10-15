Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2JOFwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:52:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:5859 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab2JOFwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:52:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="asc'?scan'208";a="205648170"
Message-ID: <1350280341.2152.12.camel@jtkirshe-mobl>
Subject: Re: [E1000-devel] [PATCH] RX initialization sequence fixed - enable
 RX after corresponding ring initialization only
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Dmitry Fleytman <dmitry@daynix.com>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>
Date: Sun, 14 Oct 2012 22:52:21 -0700
In-Reply-To: <1350235151-11146-2-git-send-email-dmitry@daynix.com>
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
	 <1350235151-11146-2-git-send-email-dmitry@daynix.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WsIkhSiBuc2R8tFyVF8H"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WsIkhSiBuc2R8tFyVF8H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-10-14 at 19:19 +0200, Dmitry Fleytman wrote:
> Reported-by: Chris Webb <chris.webb@elastichosts.com>
> Reported-by: Richard Davies <richard.davies@elastichosts.com>
>=20
> Signed-off-by: Dmitry Fleytman <dmitry@daynix.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
>  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18
> ++++++++++++++++--
>  2 files changed, 21 insertions(+), 6 deletions(-)=20

I will add it to my queue.  Thanks!

--=-WsIkhSiBuc2R8tFyVF8H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQe6SVAAoJEOVv75VaS+3OMCUP/js0i74Snzsvd+vhSM0BRmg0
OaEqE5LlTIQXA/h1bQ8qLyq2ivebw9pWQE4apZy8K6TsGfzFvMgRKHMGsdIUAqkO
o13fkIGSPa01Son86BDlPLC7i7qs/DJs/JqXdx/2oUo7nfcskXHSizURw514P7t2
rxstvR2Q7WfALkNGFadT0PkWk65eDe4pGtnjcc0KKtjr0f/M/HoyruTvPDHO6FRt
zGlKAW28eGK7VpmMF5sWgWblQZi4z5aUTD7ydJnLPJNxMlVN5y29zQoiqg4KrI8B
tlV+zBKHUWBpeLosw+hdMqS32TaNfE7TNIHBOaejsqvrPCrSw9Rz+q85tmPmeXK3
gg0GSCHmWEaV//S3rCZBMKaMdHsnvmARvJGBhuLI7vyA+YgFE3Rbt5c1XOsoraz6
JEYoIjAAQy9KFGBmw7U9yLBiTiFWQ047KksjWttj3nmRB+xC9jDDRcZSazf4guEp
65O/XGi0XtN/hZC+OB/qfMNvWpxvvmYtvYMw08PCUPGnzF1n9ho4ViGzYLlzbTpx
w1m2cbUuIGGfh0RiLgwmtsCwHSKSxlzyoC/tGYt7Ca1MRqedUFSR7zI4AkZAv7WV
ZwYOAgzvxZhYla9smqafrkKvsFTGq+DrzDVZzkY0j1VWAHzZrgf51nZhLE61pCjk
AcMRLqoSEIeZl0s3cE5Y
=Mq0U
-----END PGP SIGNATURE-----

--=-WsIkhSiBuc2R8tFyVF8H--

