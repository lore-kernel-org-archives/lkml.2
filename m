Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2DZJtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:49:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57560 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab2DZJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:49:07 -0400
Date: Thu, 26 Apr 2012 10:49:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>, Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] clk: Use a separate struct for holding init data.
Message-ID: <20120426094901.GE3207@opensource.wolfsonmicro.com>
References: <1335419936-10881-1-git-send-email-skannan@codeaurora.org>
 <20120426083924.GE17184@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8vCeF2GUdMpe9ZbK"
Content-Disposition: inline
In-Reply-To: <20120426083924.GE17184@pengutronix.de>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8vCeF2GUdMpe9ZbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 26, 2012 at 10:39:24AM +0200, Sascha Hauer wrote:

> Can we please stop messing with the function prototypes? So you prefer
> passing a struct to clk_register which is fine and yes, it may have
> advantages. But do we really need to change the prototype? Why can't we
> just add a new function?

> I am generally open to do these changes, but we have come to the point
> where people actually want to *use* the clock framework instead of
> rebasing their stuff onto the latest patches.

Or at least wait until we've got somewhere with applying drivers so that
whoever is changing the APIs is responsible for updating at least the
in-tree drivers.  This would minimise the pain for people who've been
sitting waiting to get their stuff in which seems helpful.

--8vCeF2GUdMpe9ZbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmRoGAAoJEBus8iNuMP3dT7sP/2Z8iJhw0VybySNbx1Ec+XPY
jj62fksWrB0RgeCk7wkKpRX149hFCkTqZwTizH8V6Z/HzXMdw2/wijOKAzUitxO/
7Ck9W3qlUxuJTM5EPW5cIHxOYfNCeDnr9Ux+GKR88o3TriiTVk6FhGgFeifyIq2m
G4hT9dCwHuuBjuVKKGEiflQ2qR/3fDohw1sRK5Ar//Mr6kZtPVu7XKm/Glw8wgQY
GM3v7c72sqF67qkMdN2KQ27lD4h+oMWbykWZ2xmJfo3aMDUhpwDICwLO4aaxveKF
4V5CfNExfabOPfK1vVZJFdNwqt72n48unzi18TMi7D5L2bQTJQGdUuXOTVANMsvm
N8iOyYoMhVvy81F61KrvE41GKifEdBRyDtsn/F5AgNn3dgT3tq2jfXz4ey5Wm8Os
LXzZ3mcx73zKoIV+T9stNNCe4QOLYOKba/t0/ouixhIJ0hQMcszEis5WnThmxYhp
Kj7R0u+mGvyK1+aD8ZwhjVEhMZOVsUIsU8/j1UY88WxJ13fAT2zKR23eUU4mrHpV
i+tptjiM4aS4ls7YMAu1Y2hufaPYqvqX1OKM3PdujhIuvcCAkdJULxIrG1Q5JDyK
w/9pORre9GMzOed5PbrtKg8T6Fk2r4kgVITM+HqzA11l/SW4JGLv5fakY0ksVxAV
XV1209vdIDb2K4gfsGGe
=GuM4
-----END PGP SIGNATURE-----

--8vCeF2GUdMpe9ZbK--
