Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2K0OEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:04:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43916 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286Ab2K0OEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:04:06 -0500
Date: Tue, 27 Nov 2012 14:04:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>, alsa-devel@alsa-project.org,
        sudhakar.raj@ti.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        nsekhar@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        perex@perex.cz, lrg@ti.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ASoC: davinci-mcasp: Add pinctrl support
Message-ID: <20121127140402.GE4468@opensource.wolfsonmicro.com>
References: <1353557099-21599-1-git-send-email-gururaja.hebbar@ti.com>
 <1353557099-21599-2-git-send-email-gururaja.hebbar@ti.com>
 <20121126114511.GE9411@opensource.wolfsonmicro.com>
 <87y5hn1tey.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65ImJOski3p8EhYV"
Content-Disposition: inline
In-Reply-To: <87y5hn1tey.fsf@dell.be.48ers.dk>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--65ImJOski3p8EhYV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 26, 2012 at 09:55:33PM -0800, Peter Korsgaard wrote:
> >>>>> "Mark" == Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

>  Mark> Since the driver is happy to continue without the pins why is it
>  Mark> bothering requesting them in the first place?  In other words, this
>  Mark> should be a hard error.

> Sorry, I disagree. As was discussed recently, there's several reasons
> why the pinctrl call might fail, and not all are fatal (E.G. pinmux
> already setup by bootloader):

> http://article.gmane.org/gmane.linux.kernel/1399756

I'd expect the platform to provide stub mappings for cases where the
pinmux code shouldn't do anything.

--65ImJOski3p8EhYV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtMgCAAoJELSic+t+oim9Np8QAId8bMn26Xnjq/YSiCiUFK01
iJH8Kk1Z0d/KXeOW+V1nO5x8G8phACWyVYQRdvP+rJ/91EwsRryo32NA0N5Ga3Fs
tehqHV3o3Cxx2Au0oE3s1xtlkiJYVk8XbYCjwTN0s33VkpMEE7mtULneE6jJmQkB
oOwYvhJD+bS+HtDzmByRf8pmmWCrI1jelqEy39qnU9IJUM0a/H3r7J2nM9nggqPX
d+2nnCOnTg8G59ENQptQP0sK8spcZL4FzzZgBMGthJ8oVj53WEyrLYYp5BDnSQr0
yR3BHzOALm8wCXGa7iGs0ThBt/PVeUtHhyPyPfp3EWOvcyYDh76yR9PVWkDmgNmm
mHTOABloUiudKxmEkHPQsRCUxb5nK0mohx9M+JRE6eMeKt3XG4ISR4I/+X2LPAuq
X/03eFg45p5wu6p+RbdN1dWPkAf5g5EfeCAxnahJokqR2+4ObhcIvZ3KH7abzFHi
2IF0ehAcC1hRe1ss2NnnZNypNkUb3WbV5ShulR/WyEK++ejWcjKrF6tZPx0iQj2t
IwozIJ2hxcUFSn5zfixaCFx7x8ssGH39AGoeJOcd+Ro2xqJMBDSRXhRhaRAajOT5
y069bbBoFT7KC0fGhS+WlHFlVY0yTzLwipLm7S7F9T+qo4+h02eRXno4coz61aOP
6GY1728FhMK8OjBtHTS/
=WOzO
-----END PGP SIGNATURE-----

--65ImJOski3p8EhYV--
