Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab2CUQLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:11:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38251 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757073Ab2CUQLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:11:51 -0400
Date: Wed, 21 Mar 2012 16:11:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v8] sound/soc/lapis: add machine driver for ML7213
 Carrier Board
Message-ID: <20120321161148.GG3226@opensource.wolfsonmicro.com>
References: <1332292517-3411-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhYGnrYv1PEJ5gA2"
Content-Disposition: inline
In-Reply-To: <1332292517-3411-1-git-send-email-tomoya.rohm@gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nhYGnrYv1PEJ5gA2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 10:15:17AM +0900, Tomoya MORINAGA wrote:

> This machine driver is for
> LAPIS Semiconductor ML7213 Carrier Board + ML26124 Reference Board

This looks good but obviously needs the platform before it can be
merged.  One fairly minor thing:

> +	mclkfs = clk / params_rate(hw_params);

> +		bclkfs = 32;

You no longer use either mclkfs or bclkfs so you could just delete the
code that calculates them - the DAI drivers will work this stuff out for
you now so the machine driver doesn't need to.

--nhYGnrYv1PEJ5gA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaf2/AAoJEBus8iNuMP3dZ8UQAJ6hVNFoEAi3IELDXPXoQ/RU
lsNbZezgKUPNqI6WhIt6tYWfndCqS+M12qBFUXx3m8eo9FIsgVlt+NwLC1N07ZYI
pw2RbLT0/AXDJlPQ/NDG03EJf0CbmD4j5VIgidnB4hEGCDdveJKw0GQHBKOWSsXQ
SbW9MnGJASG+7HC9GLnMrmMwr68rJefLlkApIi7X03kJyp8LaVVUbcUatjfe4eCk
rfKWpsSsNBGm+uZmdZtkRbII1UdInHQ3Pol8Q/yBfcLnMKOOrERwIV0lrGqPHSfl
2wesMhhDgPf+NH7s+49fXg8q75J9I3P81526r+JhZ2PkHBAY/rg711S9SXx2j3ge
jIubUfqDoqPlawTAHn9uLXsV+7seyiFVyrtNyrkc+q6N3+qoqbxODRhcBnIEOHhf
Ldtt0d1Ad4F188M97csiVEXnWNCUrPOlh7/4nj1uIdFmcerZ6uSqKfSS/3kdY/Ru
cHHaDTW95DSyzNl5x2i9x3WJSMCXku9s/cezA48+KTEhPGRSTp8FqBtia7PgjspD
0Lv2DDTTfeeskLFcXgRtWHeRBZxY0HZneYaL/XQzuP8hiO9X8FgUWDvnndgpLR3y
Z64Kutlk41hSSx0h5mSiBoppgtVIsLF6++aYbBX9VcJ9oXz60e0+1R2sIiSNYsVn
lrEV7mAQ8XCT6wrVr1fC
=jnuo
-----END PGP SIGNATURE-----

--nhYGnrYv1PEJ5gA2--
