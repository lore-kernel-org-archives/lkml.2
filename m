Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2BDSqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:46:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34413 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601Ab2BDSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:46:43 -0500
Date: Sat, 4 Feb 2012 18:46:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: devm_request_and_ioremap
Message-ID: <20120204184638.GA10688@opensource.wolfsonmicro.com>
References: <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
 <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien>
 <20120126110506.GB2611@pengutronix.de>
 <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6>
 <20120126112242.GA9401@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201261439460.1851@localhost6.localdomain6>
 <20120126135135.GD2611@pengutronix.de>
 <alpine.DEB.2.02.1202041922070.1974@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1202041922070.1974@hadrien>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 04, 2012 at 07:25:05PM +0100, Julia Lawall wrote:
> How important is the name argument to request_mem_region?

It's just used for diagnostics.

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPLX0GAAoJEBus8iNuMP3dVBsP/jAVpSwJ9rWNJusL+qELD+JA
M3/SmBVIyAD2gtyJ3PTfNn/o7OUyFVoNNBMcDv+YngSaT/T1L92bJ+nbrfB48why
jh66v05yRMcrqsjQ75Tl5l6CD23CJXGCN9iMEQpTeKqUvq9jJqcphhbpN75Ln3EF
fCL+br7P0rG5RZbjKsvCtr94EGGwdljLCnyafBqZRu3vnFu8fyWTCUmMruxI45Y1
JKs/mzfS4cMosNkbI0A+jsI2CY8STWCgkiS72NHJmCwm4JV6ccG3dU6h2CCggTr+
ab+yU8GiCqDhB5F1IaY1zOR8mbo3L9t+Va4wkC0YD1vYi1ISS3Lr0LBHeAzJdYqV
L/8wXo61ekgg/KjW5wRXK/rwdLccrkUx3ocQingTd5TKEm4CHzUumcahowSGCi7O
LyWI4BfrQFkNV/sBLjsG6JLwPWFO5AUqJU5DDERO7rEAMSaM3Ou3rsQimKne13Yi
bQKGJo4N/edY3+pkNlR1WMnlRjhhzxAp8PjrrNdBdvG72H2OChk5l52si8KL5Zvt
hTQlDo37SjJllUhucz2uq21rsyIFTVfV6Yt1gaErOSzkx9QlMSL0pHbU25O+eCov
1Fzo8cFeqs3iT+RRIZzwg/IRyoYVeZviWtmFpWs2QojRb3EQrEFUaXwwRvb5OzWQ
zTBD6iZWnIrqmQ2BnrJl
=kug/
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
