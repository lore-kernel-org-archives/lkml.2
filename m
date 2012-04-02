Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2DBKOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:14:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45682 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074Ab2DBKOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:14:31 -0400
Date: Mon, 2 Apr 2012 11:14:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rabin Vincent <rabin@rab.in>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120402101427.GA3172@opensource.wolfsonmicro.com>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com>
 <CAH+eYFC+q4xFuSdRBkO9nb0XZWU4pQ_yCyinMy2X3ds9WQd1kw@mail.gmail.com>
 <CACRpkda2zh=zR+A9bwhRXYHtQdFeUpiqG4d5g1i82mPCs1mXaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <CACRpkda2zh=zR+A9bwhRXYHtQdFeUpiqG4d5g1i82mPCs1mXaQ@mail.gmail.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 12:39:11AM +0200, Linus Walleij wrote:

> Mark: as Rabin says the v1 patch is probably fine, are you pushing this
> to ARM SoC or into Russell's patch tracker?

I was waiting for some pronouncement from Russell - looking at the git
logs it seems the patch tracker is the normal way to merge things.

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeXv9AAoJEBus8iNuMP3dkCAQAI3tbIQ54EOZZCb3+IrnOJp8
36FXqbsmoPiwRgsJeLrgD6Bj3pbF0afQrdPk+7BTHB97s9Z5Letqxul/HC1DPl0K
Jxv7ZIYrnJI19wYEnvctTf4svytP87yZj8u5G+cvM5gZZXW2EjwcsDAqAjVfQhIM
fjw40v6g/rHopkLYOPGrqlCUiaNO/FnBmsYrtUYtu+SctIa0DKvl9X6bCZin095e
1tEESIHrOJY5azHZCXM7qUIlmUFoKTvW/366cLpSwrwgDSoOs4lrsQSEcVchQcyO
jtP+1zPsNGyAQv5W0WIbgLlUNJ+CqV7UUV9WdKssBvgL13axpLdtUHztFPyAoFJ/
C9f5k5qqmCCmKzEuU09hahm9jqCCgwFCl/uplkHI8NqCBeopKUeP9t5AjX/4mSrJ
NK0jhuwVjBUZQrph3we3gOSJqdM3ghvkNsedDI/vSShKrO7YqFxC9v9lYn7Rwcn+
bIWhr57l/izVVbmrBmDKm8n0Ju0MscsJL+nNbOVPhDsC2xFX2qTEoserZH3XpLAo
HLYW6KxTE/tBFjc9Ts9gh00ONA4Vpxh7XNjCx5vbNiFT1Xl5k2VGp/no7j0H8pEm
ejAvD46rSdsPIdxujTKXO/INa9I5E3GL1z1mU+0drrTU9DZ2DBXK7qKcwb5Qi65x
C+mcG0Si/kAn8OpdAJ7m
=l0mE
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
