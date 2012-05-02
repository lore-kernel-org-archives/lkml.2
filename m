Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2EBJLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:11:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37070 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab2EBJLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:11:33 -0400
Date: Wed, 2 May 2012 10:11:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] twl-regulator: make TWL4030_ALLOW_UNSUPPORTED more
 configurable.
Message-ID: <20120502091130.GG4075@opensource.wolfsonmicro.com>
References: <20120501204259.27026.40156.stgit@notabene.brown>
 <20120501204450.27026.40239.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
In-Reply-To: <20120501204450.27026.40239.stgit@notabene.brown>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 02, 2012 at 06:44:50AM +1000, NeilBrown wrote:
> The regulators in the twl4030 can provide some voltage settings
> that are not offically supported.

This looks basically OK but depends on the previous patch so it'll have
to wait for now.  Once more, please always use subject lines appropriate
for the subsystem you're submitting against.

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoPobAAoJEBus8iNuMP3dX2AP/jnA5Y1NP9zBeg886oacaarP
dICEn/exkylgvDQfM/FnFW4fh5UPW0RdU/QzlKg4RIFK468n/4Oy3tmYNleQVV/V
/FLLR/HAdw4CxSTgBvSBUHGiGEn0N54GAtRNgMDsHs7YpCU1+JScvGFRrmAxHcOm
d+nsZnDjeJ0a79NLTDmfQmzdTeDHNri74rZlj8+DKHHARejD+EaUTRHEaVWlS2bq
V+F6QymaTCZ/oWtFsVuKvsv7DLy0YbUKwb8MkYOUpRZCNZTxnXXtqbq0jCApqJlO
wWWzQ3vgCLRmPGK6wMkpx2/VJEgiE8UiN1XJ8CUVoW8f5gKP0XEQnK0Mw9huoTtd
6fUxt001slUd8rfB11+E/LCStA3sQmPExt3Wnd10kzyxpj8fiBboTCZeM2nM3nHy
q3EKcZDnYLzwQAEMAfhqrL/GzrEHIBa04UUAyvRmM4s5ftY5K6Fke0ptAb3JKDwS
2vvYoMEMIn6xxaYkedEbAdDw7DLMJUp1ekaauu/62D2nXYJqp63aZJDcC3BC3r+U
FA2lzjXFqh0XW7l8uoNGovrPv5Tkm77HsHV1+f9frKeiuNpU3UOewX1i2vcwny9P
Y6u/i6gCZcGrtB5AcoheySVeARqgwuHCt5TLcKNCtb1blblMb41S2dDMnshleU3V
wVYZChgT/cViRCB/9uQm
=p0Az
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
