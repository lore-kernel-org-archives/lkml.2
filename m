Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2IMId1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:33:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab2IMIdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:33:19 -0400
Date: Thu, 13 Sep 2012 10:32:38 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Alex Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
Message-ID: <20120913083238.GB12259@avionic-0098.mockup.avionic-design.de>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
 <1464760.6eqxJ2IzZ2@percival>
 <1347517377.7471.23.camel@lappyti>
 <2689722.93BQTh4lSC@percival>
 <1347519249.7471.42.camel@lappyti>
 <20120913070012.GC6180@pengutronix.de>
 <1347519807.7471.45.camel@lappyti>
 <20120913072920.GA11459@avionic-0098.mockup.avionic-design.de>
 <1347523218.3014.4.camel@deskari>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <1347523218.3014.4.camel@deskari>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VFKZo9Nr2kYEmYDejsFvvu/VPG8p+P2MPfXog99WXd/
 AlHYwctM1Lk+kLLVYjR30EBOdLDEA9L3BtnzQrXlUo7DJLDcrG
 QoY9CnxStqI6MCfEuemL38R+wAaOt2fWwY03RUobYetEUp47IL
 uOITIzXlvOWKomf2fs+I1ZzB0TImztNRHhbicLS1QEoLMaqCYr
 pf3SUCYhGZBa//nUlJBkO/J+D57gfeLpivHRa8jk5TpGANnQuk
 GxaS5r+NVk/7dQs0Ka2KxRHQCOzxKwRofdy+zZUDxeAYEoA/3G
 igv+3gUMWisp+QMjxGzQULDcGeGnecnpS+4BRdBcGrGVjW6Qym
 uaoYZqsUIZ5DoqBYNjzWA6rm8X7xBu4Ab4YnE95q7qfk3qjMyZ
 +d1bCbCmd+C5Je1kkpnyQiSy6Xo7XAQ3veb5y8FRFvY5jGE4sq
 /g7AJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 13, 2012 at 11:00:18AM +0300, Tomi Valkeinen wrote:
> Yes, I think the backlight and the panel should be considered separate
> devices. Just like, say, a touch screen and a panel may happen to be in
> the same display module, a backlight and a panel can be in the same
> display module. They are still separate, independent things, although
> they are, of course, used together.

Still, as Alex mentioned, there may be some dependency between the panel
and the backlight, so we may need to have some kind of connection. I
haven't had much time to look at the panel subsystem, but perhaps it
should provide for this.

I obviously don't know every panel and backlight combination out there,
but isn't the dependency more of a usability nature. What I mean is that
the panel will work even if you switch the backlight on immediately,
just that the panel might take some time to properly display data and
therefore the backlight should remain powered off so the user doesn't
see garbage. Or are there really any functional dependencies?

Thierry

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQUZomAAoJEN0jrNd/PrOhoxkP/1NcMahOa2vJssXtRd00kKjt
43a6kdaicffWOSgNh6grb8KYv1yc3obztLPrDXZK+mEYI4BZRw4HSR+xkoRHH1B7
tYBbrnB7gwJV3aI1kEbF2O78SPIuk6OcdpMcF1G7vYV/W9aI04GTUMxbeARSppQI
omA8Fsp6r0XtMYMeupBXRBAgrXB0UB7SESrB2ZRYCYK/Ok7+lZ/6A9Wfals7Cep7
ZdGa0PsXBp9XqEKiG3xyW3Z1HEM2Xjq306OoxWjci8kyy3s2oIerAj2/d087fkWY
brt/hTKIxPUYPRorYFgT5O+LyHhPQDr8GER11kqRRsaYrrV1aQ/DH/0n3dTtD3Ts
TFume+Cu9gDLJ69yh6Iyohf5NqhQTmeERR8h8lwWfLZjhi7ksxl3wwEA1BorT2ly
MQe8FRiJEvQLnneYjPlcIvjCGW1h+NpjmRdRAiS7XsRec3O/t+U71MxY/nNkxR/u
aUXtvVBVklTOSzhqsU2H3BSYHw2F/Ngvu9TkqbBz/YRtzwSroVMJMeiU8DRGl0Hs
gY6bogMqy9UT+WE4xtsVEm3h7K6tlBkNgX9ZVSr7OcJ1kzH2YtKQ32DI3MVXl4DJ
xJvsMEeRgBuYFFtY35mG2zGx04nLdcUDoVoeNS2jmTfxW7dWHdIsGveyGU7ANWF6
EFnBvzqsTwC2AaDlAJJz
=M0St
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
