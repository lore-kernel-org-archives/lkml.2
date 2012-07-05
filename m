Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2GEONi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:13:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48329 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab2GEONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:13:37 -0400
Date: Thu, 5 Jul 2012 15:13:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705141329.GN4111@opensource.wolfsonmicro.com>
References: <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <4FF58B68.5000703@linaro.org>
 <20120705124549.GD4111@opensource.wolfsonmicro.com>
 <201207051357.07195.arnd@arndb.de>
 <4FF59F5C.8050002@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FAVlh7XA/4iOdtaa"
Content-Disposition: inline
In-Reply-To: <4FF59F5C.8050002@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FAVlh7XA/4iOdtaa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 03:06:20PM +0100, Lee Jones wrote:
> On 05/07/12 14:57, Arnd Bergmann wrote:

> >The non-DT path for this is a huge mess, I'd rather focus on making
> >it obsolete than trying to fix it. Other than that, I agree that
> >we should be registering the ab8500 from the prcmu from both the
> >DT and the non-DT case.

> Ah, is that what you were saying Mark?

> If so, I apologise. I thought you meant register both from platform
> code. I'm happy to register the AB8500 from the DB8500 for _both_ DT
> and !DT.

Yes, that's what I was trying to say - sorry that I wasn't clear!

--FAVlh7XA/4iOdtaa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9aDBAAoJEBus8iNuMP3da64P/1668PBSC8XnM8pzfhtNZBMO
cw1RGlAQo9RKEqfs8TuogIpdpHjJ7d1BVL1RBZ6eKsOoqbn8XIYpahFsOXC0L2Gv
ISy95enEZJNqwcNn8YiBuiuU8JOP2Be7vX05bw1d0UoNIQaLsqoZk+lhK0fKLj5i
BGZGt0gEJssZZWLiSc6PzTx5+U3sto+qFyt/+i+uZlLXQmrgVGBvUD4b3HCDSC4m
gS0xhwjeiAg8FHe8Wpdphw+aN2Cna+Rgd6qdQSrsB7KaeBZthhENky7G436cD6H+
2DEa/zT4gZicABnxvAynedyq5UR/fYqwOTExiy1MZGRAqLBtqXry1Bf0dfdzTYAh
4cqWeL9KAvJsVLMQ9RwbvNyKyO3+9wNunyVRYMjwVkx8ctNxQaCaqrsD9z1TGxd8
08FbEBCb+dM9VSrvgCtIOIrssUYf4h2zM5rmGl17ueeKjVgP+QiG036AHPhw95pQ
Gdj4PXJVR3Grtz6XBHYxtJte7h3OZoJVNvXGKGQrK0qXS+9W7+0v28EgRo/IVShC
72zXdEIT3lL/hvJg1NgE15twBAzTjC+xE8ug6wKa4YKWXA9cECjHvJu/Zs1LshcH
ygkwS1GK6eHApLhpxNNiFVmsyC7HDjc98gBP2j3L5c8hUkLg1eTIy/XExBwlYz3V
IQdT6VVO9QMKidCQQP50
=MlPC
-----END PGP SIGNATURE-----

--FAVlh7XA/4iOdtaa--
