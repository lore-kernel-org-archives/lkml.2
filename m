Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab2C1Lii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:38:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55285 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932285Ab2C1Lih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:38:37 -0400
Date: Wed, 28 Mar 2012 12:38:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        mika.westerberg@iki.fi, lrg@ti.com, perex@perex.cz, tiwai@suse.de
Subject: Re: [PATCH] ASoC: ep93xx-ac97: use devm_* helpers to cleanup probe
Message-ID: <20120328113811.GN3232@opensource.wolfsonmicro.com>
References: <201203261600.09454.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AA9g+nFNFPYNJKiL"
Content-Disposition: inline
In-Reply-To: <201203261600.09454.hartleys@visionengravers.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AA9g+nFNFPYNJKiL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 04:00:08PM -0700, H Hartley Sweeten wrote:
> Use the devm_* helpers to cleanup the probe routine. This also eliminates
> having to carry the mem and irq values in the private data for the remove.

> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> CC: Takashi Iwai <tiwai@suse.de>

Applied, but please:

 - Think more about your CC list.
 - Try to avoid putting it in the body of the e-mail.

--AA9g+nFNFPYNJKiL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcvfbAAoJEBus8iNuMP3dHJsP/3UKtNyTkgbFo3rIuSWJT0g3
NvCpXWI5d7P39QZF1xSohcbf2uIjpHa7/KbgqNm2v18hDLmVNeoF0zQMxg4lsZCs
BABTJJAQcEHXn6fi3ifV9sNn227akHszqFdoyVmd3ayqCp8yegdn8Jqnt8la6MG9
N1W5f9Vc63nynbbSJXnUkD3fObAkLxxM+uLDX2CDGW9oPiNVLcTwmi9y4/WiF3l9
cYsG6Pdx2ZNHLbwHmkWYaI0vlMScYpE4ah25CxfBRKg+RIF1hvILhCwRMHvwxKjS
eh/Lf/Y+AyCgbeU/zqafK0Nj8w1bL1thzNgLVVNxaZIWst2RVPsydW6AFkQhNIrr
j4flpVh5PVtCwhqVsgzSvb4HcqVxcPPY7YEBwmq4XhTKq+RZ41MpFlBoMb92uy8d
YdMcXh3leVESUmk1CAnJkfRwYMHb7fAk2C+2Mt98nQwd7QnqZimNphon1rMDr0zl
qGIXKR0yPdDFsnRp3JaVcy7dYxJsPArLnb+STXoyLA/lqQCvZmAqmkHFItoBjRYc
dlczftj3lnP5Mi4Wmk/MWUyBag3OP4FBeT0q2x3AvcIJjqkZb/GLYmQTmmUtye8x
jdU1vHVQs6lscwHuEuZp+dnc2JFdRJwd/vfeX/FXKYuMllJGqQeNmQM2Eb88iRRa
Ko7yvrBIMsudrERkTXZz
=qx3B
-----END PGP SIGNATURE-----

--AA9g+nFNFPYNJKiL--
