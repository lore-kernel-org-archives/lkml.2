Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2C1LkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:40:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55307 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932527Ab2C1LkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:40:07 -0400
Date: Wed, 28 Mar 2012 12:39:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org,
        mika.westerberg@iki.fi, lrg@ti.com, perex@perex.cz, tiwai@suse.de,
        vinod.koul@intel.com
Subject: Re: [PATCH] ASoC: ep93xx-i2s: use devm_* helpers to cleanup probe
Message-ID: <20120328113940.GO3232@opensource.wolfsonmicro.com>
References: <201203261600.17787.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oSMU0HVueUMCAvn0"
Content-Disposition: inline
In-Reply-To: <201203261600.17787.hartleys@visionengravers.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oSMU0HVueUMCAvn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 04:00:17PM -0700, H Hartley Sweeten wrote:
> Use the devm_* helpers to cleanup the probe routine. This also eliminates
> having to carry the mem value in the private data for the remove.

> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> CC: Takashi Iwai <tiwai@suse.de>
> Cc: Vinod Koul <vinod.koul@intel.com>

Applied, but again please take care of the above.

--oSMU0HVueUMCAvn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcvhIAAoJEBus8iNuMP3dvbsQAIiyUsqcuQBLLaQjKNIG/tEQ
/ETt/7Ocj2VFpY0jmlwB9r5XAhgnikC3YkA7LCfhwwTFovAAV2dezVLiRF52ho0e
7Ij0d1E3KAP7UVvUNzXy/GYe8+MqwFO5pU9jdtjIxglnnpuymq+NssY2bJMNWfGQ
8rWVJjlwCNzzibsmYgHHVswXKrUjUNWY4ErcLTtoTNS+fU301CfgXrsprvx+bKPs
nNbXXDdAnbzVsMhIRW5wKo9IWG95tyvpEmL8lnVbIRwd5TuOhRQaG1WGgR47ljad
rdYpC8Ld/xnNyziyfX2Ow3G6l7bgoamwfgu5FY4rvq13rtLM+xKuaXklqLAYKbPd
66WjOWRfvgeG3pFK0xRS+/owTjIGiMx6tUL/ItIOqCJoP0XRnzoIIEO1Sv3redcl
rmu1gzio2QT4rTcFTgHQ6yFaWVoeR9gUzFa0ribSm8mcTbb32sJcFsupZTjvV6se
QrwB73MSVVfaroX/AFWrNesXTfW06BA6vKWBewGMYRFGozznTKppwlSLGJACxtpW
WM3wHn2abW/BVQOXz91QRliiLO68cIBok/qzwwYTQ1DZdlxeVK+Zx73VEBl+g4aE
nY4RHEbYznxt0/kL3X2tmwNQlIIPFgMcl5BmRgjuLHKMccCFOs5cnG6aLEplWdku
dhe7WS0AX9Q+Lk5BTxqy
=2Ndn
-----END PGP SIGNATURE-----

--oSMU0HVueUMCAvn0--
