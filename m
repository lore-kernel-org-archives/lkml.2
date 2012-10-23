Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2JWJWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:22:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36994 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768Ab2JWJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:22:48 -0400
Date: Tue, 23 Oct 2012 10:22:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kelvin Cheung <keguang.zhang@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
Message-ID: <20121023092245.GR4477@opensource.wolfsonmicro.com>
References: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAJhJPsV0rnE+K-9bWFy85T36H+PfbibrsGQ_mN_miqttyQJNhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMqNd2jlyJQcupG/"
Content-Disposition: inline
In-Reply-To: <CAJhJPsV0rnE+K-9bWFy85T36H+PfbibrsGQ_mN_miqttyQJNhw@mail.gmail.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMqNd2jlyJQcupG/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 10:10:09AM +0800, Kelvin Cheung wrote:
> Hi Mark,

Don't top post!

> But the common clock infrastructure of Loongson1 has been implemented and
> enabled in previous patches.
> http://patchwork.linux-mips.org/patch/4268/
> Please remove this arch from your patch.

Done.

--gMqNd2jlyJQcupG/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhmG4AAoJELSic+t+oim92SUP/3Nb6fOaMW5uFKSJMifluBPG
jBC+4sUNF6OyC9zF6GQcw9+EasY9J0drkWlmsJnau8KzGPDTonCnBjBXk2rVAG6t
vqnmMuK7R+ErO7/DOCiyKxZ73JaRCNHOMPB2sAsYFiUI8MZElyZZJ48BdqndD1EV
4lIJ404Sc4GHFoLNb2ELVCmFhe6FH1Wr0v2vqhCx7FvKLvwLNJAv0eT9355hEPdg
Mhe4tJC8eFnmIM14OoOgUDuv8izHUst7ak+tYZy2fuZmScccHGUGbMurqCmJhEmf
F56fcT4VajWHbPI6euEAsYdJHg677hWn6cMGMT2wN2cRSjOKzb+Tu4oeRWSpSgTZ
z5iYU2q+hFDCDk6FKBN9vmPurCn3yCjUfSHFaw1fJhjRzv1pAKNIH6egLGamYpBA
Xu7PBwcMFHB0yA8JJEaKy/l59IBJoVxCkhRS/hvwja1WFAjgdEzobepRLgvRoa13
gbXxnvlEi6yheaF6P2Bue3Yw7xDIvnwk8MzMbhBJlT+uX6IGOG5Sszk88AoxT7JS
SUBWj+gu4FCGq+4Bh9tD2aT/S8UoCkO97mCIOGR+6QR64U33dKfU7tzfkPShpSWM
SiVHXzJmvFQ+XLQu97Fwmu20J0TXbvbUnNjIf4Dtn37b1OUIS2LdYvtDYPbMmzAw
SZ32wAM5iAE62WIvyGm4
=VZg6
-----END PGP SIGNATURE-----

--gMqNd2jlyJQcupG/--
