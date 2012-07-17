Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2GQHnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:43:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35426 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab2GQHn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:43:28 -0400
Date: Tue, 17 Jul 2012 08:43:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>,
        cjb@laptop.org, rob.herring@calxeda.com, rmk+kernel@arm.linux.org.uk,
        ulf.hansson@stericsson.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, aletes.xgr@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] gpio: of_get_named_gpio_flags() return
 -EPROBE_DEFER if GPIO not yet available
Message-ID: <20120717074324.GA12047@opensource.wolfsonmicro.com>
References: <1340836334-20427-1-git-send-email-stigge@antcom.de>
 <CACRpkdYrZizqvZqsocLEGrkY5yPMuYFfmR3UUSFZgPDvEPa0eA@mail.gmail.com>
 <20120715211120.GH4041@opensource.wolfsonmicro.com>
 <CACRpkdb0k4fNigA6FGyEobxUt-JnmUy-ni7XzH-gup-ic_j+VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <CACRpkdb0k4fNigA6FGyEobxUt-JnmUy-ni7XzH-gup-ic_j+VQ@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 12:16:48AM +0200, Linus Walleij wrote:
> On Sun, Jul 15, 2012 at 11:11 PM, Mark Brown

> > I had thought a version of this
> > had been submitted already and was in a similar place to the one for
> > gpio_request().

> Me to...

Greg just merged the driver core patch for pushing the deferred devices
to the end of the dpm list before reprobing them which should address
Grant's concern about doing this in gpiolib.

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBReVAAoJEBus8iNuMP3dX+YP/26yy+wf0P9dfwDuUzqIwDly
1LJwZICuOa6dcaxY/k9Afqrf0zPJtkf761QCg6cRSjfHCE2zazv+wzy21TqwhUB0
ZI3ZbjOAUXIJXZR40AMhT273Ze8u05hPolAmbP4mzFulrkCn+sWy+y7I36viAWob
h5hBh1mVZF81Krj2oObhbkcLT9Ta3Od3PdXf8L/DBJY7XjymFFqMQLAVhQm2Fahx
xwbQqty2L4dWFD1ZkF/896kRXoNhiyJqRC6Q01vj0JHS7BIFF2kR926EfCyhHy7+
UyBlJ5eryaDGf+P1Gk17MccvnHHV/p5/EG17XP+P4K3Pd2yM6efvVEpmb11e9zGJ
lUOWkgL5tDMbPyI8SNZyyCL4fkGPu7XULmhWEhb02oOHMbWnl9YubYlCoHFoA82M
Wz4a8Z179V3flPwByRhC3dzCCrT/lC096F9fEur463USdp4rYmQmjI8y+A8CawIb
bEOnWWznUjTelVvumkOFGTm7goayWjTZrRSBQwPw/hbrpGX9yT0TIrpRMX1+nOaq
MS8sx0+4biZo/R5ZI1QswXWZT1ge7vSZrigh9+LJ4sqD//3+1jRj5a+GlDqTkzmg
dJbwaKSO6aBSwGRL/vy/F9tHZvgdRfIyS0WJhH77Lg13t4f9nS21obI3MtR49tAa
JgK3N0ZUB2mocVi+sJ/l
=NwsN
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
