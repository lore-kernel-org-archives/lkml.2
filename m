Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2FKPgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:36:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53403 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2FKPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:36:51 -0400
Date: Mon, 11 Jun 2012 23:35:53 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Message-ID: <20120611153550.GW11439@opensource.wolfsonmicro.com>
References: <1339416253-4121-1-git-send-email-lars@metafoo.de>
 <1339416253-4121-2-git-send-email-lars@metafoo.de>
 <20120611132409.GG11168@n2100.arm.linux.org.uk>
 <20120611145735.GU11439@opensource.wolfsonmicro.com>
 <4FD60CA9.3070701@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ItroYk2LVxvwOvi/"
Content-Disposition: inline
In-Reply-To: <4FD60CA9.3070701@metafoo.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: dmaengine-pcm: Add support for
 querying stream position from DMA device
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ItroYk2LVxvwOvi/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 05:20:09PM +0200, Lars-Peter Clausen wrote:

> Another option is to provide the current implementation of the pcm_pointer
> as a standalone legacy function, which can be used by the old platforms
> until their dmaengine drivers have cached up. And add a new residue-only
> implementation which will be mandatory for new drivers. That would make it
> more explicit that those platforms are sort of broken and need to be fixed.
> After all of them have been fixed the legacy pcm_pointer implementation can
> be removed.

This seems like a good approach, yes.

--ItroYk2LVxvwOvi/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1hBPAAoJEBus8iNuMP3dBLwP/iO2/LhgFePPUJBpydqbTHfp
ZxpByLG2lsEHp/c+OiHhNk5Su7Dm7/36XpY/R/7B8/+tqQ4+mbgxb8xb5B2GTdje
tXpMkc0IHg5+rRBFLClezhPdx34vLJ5jtmYZOCUM9eS2o5VFqsd+i+SXrJ/mkoKH
f+Tw6VFogeQ8jCqaYoQ13mI+YlZxzGD5Sx48zkZDeotYJwbq6jQFpf1GbUXL2so3
WiUaQhXA7FgMjlX2+ttksonuIv0Apg2fAxLTJXrGI71TH+8Cphj0K+EVmiGQJjwG
w9iUnc1g8Wihhe8O/z8Jfk3OiorIpQBcaSg2hczxAxJSog+PCh7ovLav+6Wwa3VE
Rf2D0OExAK7xWfPCHCIAil7Km1sX/kFlVewDxPxHeiQMfVcsPAqpS6iiOUGV4uoU
YnJgt05sFPIjqauGMgJQFPJxM+zXDr4mOmvOtKHO9S/nrK3Me5/AsTyRQQBcDKiF
UJhjA7S7Zpeh6ViOMvdXGeYeUJhNhT0vu4El3oWUJ1uRpTkZPMPiVu63V3aArhZ7
7mikYGVfRvMpCu1rmoOCUcr4Hiex+JpjmMwvul9KJL/Fj4YwkzyzzxzTRdz8OZsc
KJN/t3glgiAeUzWWg+FWEt/OdFeG5RYQruDQ9yTqQKaoQxIdvi7A1ZQ+SeajHkmP
b3iHlc1GODRKLUhEiAUu
=iW81
-----END PGP SIGNATURE-----

--ItroYk2LVxvwOvi/--
