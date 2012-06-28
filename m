Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2F1Kvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:51:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35984 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab2F1Kvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:51:51 -0400
Date: Thu, 28 Jun 2012 11:51:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: perex@perex.cz, tiwai@suse.de, lrg@ti.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
Message-ID: <20120628105148.GD28922@opensource.wolfsonmicro.com>
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 28, 2012 at 12:31:26PM +0530, Laxman Dewangan wrote:
> The pcm mmap for the substream dma buffer is done using the
> dma_mmap_writecombine().
> Some of the chip sound driver like Spear, Tegra, Davinci,
> ep93xx,snd_imx, snd_mxs, NUC900, OMAP, Samsung are doing this
> mapping locally.
> Add api in the snd dmaengine driver so that different client of
> snd dmaengine can use this rather than implementing locally.

OK, but I'd expect this to come along with one or more patches
converting at least some of the users to the new API...

--48TaNjbzBVislYPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP7DcKAAoJEBus8iNuMP3d+osQAIvuuvCUKlZ1Vd4zES6f6LbA
YDCXj05mH/leRfNHq3DU19M+jKyP+GZ81NXfpq76BpcjLf0ieTECyOUc7lKs6Ivw
EGb3GMRV+TnBZaTUlQTLc4UR2F/AVvOgAoLSqaL9fM0eLm2w95HyECt1vGsSX4A6
FxDswxf5tDGxoMjZsOdv6EOzYOSiqM+f+HPegmiyGFs/ghlNKuDKupgvN3JwHs3j
F4fcDm7ARELKHCCKxHzAfC40oAfXUdF4iZbHMm1BBzTAQIRY0UW1s6SNdZMNdiLs
ylaV7aNVvXhanM69MIQ5iJsXftsdQ8c8J0hr2L6JJCV8DxAqV23mo9q/jEq/MOeJ
yeAB0PDbdn/VXCuuv8e6RVBpftsdwN9Xmzx+4HlMcaKyyJ7Ci63jzP/iM7lIvg4q
4EKP8ox1inSCQpWTJ8TWqH0imjARrwcHHL3q1nbV60kgd9aUSAEYnQxF3IeSHo1M
DCUlqGt4FShXvXY9NmAt/a+uHko6BhFe9mcuaqCP1UIqCC2Pjpumn6WnfMIoEzxC
cHuQq2HPXmqYdX9AzmaLAPHWQqD7msc1vtlFRjGyWDF78aQdm1Eu0IgrLCdZwXK/
/GV5Cv6R8nHuBS/ibN/KbWejk6SX68orPYJnOMos7shVhFjkzQM48FD4J+TrLNsU
/PH9ZFKm0jDoj501PqZQ
=task
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
