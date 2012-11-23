Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab2KWBov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:44:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48669 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756670Ab2KWBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:44:49 -0500
Date: Fri, 23 Nov 2012 10:44:44 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121123014443.GD4385@opensource.wolfsonmicro.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
 <20121120215429.B621F3E1821@localhost>
 <20121121013133.GE4673@opensource.wolfsonmicro.com>
 <CACRpkdaNmBpfONDpt7zFqLaqfiGm+ELpO-v5gZmM0rEi_AzijQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Content-Disposition: inline
In-Reply-To: <CACRpkdaNmBpfONDpt7zFqLaqfiGm+ELpO-v5gZmM0rEi_AzijQ@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 22, 2012 at 09:57:22AM +0100, Linus Walleij wrote:

> Is it correct to assume that this library will be useful also for ALSA
> SoC type of devices?

ASoC has facilities for autogenerating the bulk of the sequences which
with modern devices is all that you really need.

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrtUFAAoJELSic+t+oim9or0P/jeRd4BYe3ocqxtkm+e8e60Y
blALWfdQExTsYg1gmoEASiBFm5vhQg9TDcmM1MdojCRV0+IfPem+a/Zo8DuLinqO
QqNNY5pw/j7KLM2FflzoiFPtwz5w4Tg85eMZD9nsmmAUw//t+hlB1uCI6qo1RAQ7
GAR4L6jCTNqe9q7osV5ydEw3rrKKTqo99MMO0inZ788wp+xzSCHcP5wljRwHZwSI
3Q8vL3dQw+IGa6/XJM9pMAOd/IFwW8+5QCl89Z6hRLza9V+K9Ax7/Xgj4uv/E2CG
ASe9HZ4hInv6kwJX0yUN4dQJPt5CH+ABnuRnB9WBEhxZ5EIeYDy3JIHfCBxevGiN
j8g8mLQ8ihXQ3GcLHgHk6cXtxI/5EZhaOWDCN13sZ3FTnxKfm1xDQ9iQoEx/CTgR
oirZajqnKJyVBI2j431JLtzwzsI37dS9gS12MLtudXTCMuuib/RZ1CtpqvUfV0Hq
mTUaKqiUXl67Pu+nbbIlwUuvicPugTjMBJepjhQlXlrDwvOXGj6p2rX0ZHEJYel4
/mzD0ZIlwhcHgfh7RUQefuDldbr2DLJSDveAi6mWPnS1/GuNn4KIKwJuKgRqNGgW
dQvoKBvH5qEQvZpwEehl7HAt7UQ5blr8zcWMz4iQxv9q3WY4G3SmmgUIYLH9E+Qw
31wJ1bVSScBxeHLbdGqf
=yrHA
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
