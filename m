Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab2GBJ4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:56:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44745 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754482Ab2GBJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:56:08 -0400
Date: Mon, 2 Jul 2012 10:56:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com, lars@metafoo.de,
        swarren@nvidia.com, perex@perex.cz, clemens@ladisch.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ASoC: tegra: use sound pcm library for substream dma
 buffer
Message-ID: <20120702095606.GB25093@opensource.wolfsonmicro.com>
References: <1341219273-7439-1-git-send-email-ldewangan@nvidia.com>
 <1341219273-7439-3-git-send-email-ldewangan@nvidia.com>
 <s5hehouv81c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <s5hehouv81c.wl%tiwai@suse.de>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 11:14:55AM +0200, Takashi Iwai wrote:
> Laxman Dewangan wrote:

> > -	if (!card->dev->dma_mask)
> > -		card->dev->dma_mask = &tegra_dma_mask;
> > -	if (!card->dev->coherent_dma_mask)
> > -		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);

> The mask setup is still required even if you use the preallocation
> helper.

Though that code is at least notionally buggy anyway, it should be the
DMA controller device that's used to obtain the DMA mask rather than the
card device which is basically unconnected with DMA.

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8XArAAoJEBus8iNuMP3d0GcP/juy+KjjowfRcD0fujfsEhbh
abBRaq1KnHqdZY6xtDA9sYhy/raKAV8w4sigRJR+ItLBmxPv+PrsRAcTVEdkVzk2
0Iej5OJy53l3o2uqrgdzuC7YdP2ExOJMfHh/rcKV27NldNhHZogIdKeBAeBOcXc7
xcqkom45yV4WHq9goessJ09gzy2mvh/5+5SGxogsf2kthI2QsAFjji+koLKSJacQ
0hd7MwMoTzuZsGfMEi7EBD2pN+P5CUrjmh2HTUxa9uZEVGfJBzI3NRIKrm50fnG7
/1fdvIDMnFGMfMD4L0w9nkqqH16D2N46W0yBP1p2eRwz4SwSMtQ8OnkI0DeZa9iA
L1wSh8L2M3hA6y2miltow5ZrSqLX6jeUOxoZSFRY0VrJss6cUgz4vUpjEj0ge5Lh
M2MM1GBB5gzlcu5F+ogCPIfjvTzhcPV0FT9v9apKS1fiQSUnYzsqhb/ntKTRsiRe
iAKCoAdEvy9J3vgj3aKvCM/X5gzqXRpvNhr0LVPdhpEmGCxDAnIKKvvQQQLOBGAC
rDc+zYpQVPop1rbmSopeNK4LzElVaweFTMMyTSj37SzRIo2K5sYiDF9xZnOTBzUV
SmFbzedQCk2i4IhqV3LtILRBor0w4lWA1jMeHD7Re23BDUY2JGjjrc366JpkjE6d
OCgoS+sU2HlnL5rOP+Sr
=iVgz
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
