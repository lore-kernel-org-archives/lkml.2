Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab2CVSoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:44:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40082 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab2CVSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:44:19 -0400
Date: Thu, 22 Mar 2012 18:44:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 4/4] clk: wm831x: Add initial WM831x clock driver
Message-ID: <20120322184415.GA3291@opensource.wolfsonmicro.com>
References: <1332360082-25092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1332360082-25092-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120321222622.GG29317@pengutronix.de>
 <20120322111531.GA3091@opensource.wolfsonmicro.com>
 <20120322112613.GA3852@pengutronix.de>
 <20120322113356.GC3091@opensource.wolfsonmicro.com>
 <CAJOA=zOYfwy-smo6ukX7GSE2jrwz4UxwpgcFJiW876ga7ksShw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <CAJOA=zOYfwy-smo6ukX7GSE2jrwz4UxwpgcFJiW876ga7ksShw@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2012 at 11:35:29AM -0700, Turquette, Mike wrote:

> I'm happy for the core to concatenate the strings when a struct device
> *dev is passed in.  However the reason I dropped this in the first
> place is that I have some ideas on providing something like clk_get
> directly from the common clk core and I hadn't figured out all of the
> details yet.  For now we can handle the string concatenation in the
> core and figure out those tricky details if/when the time comes to
> provide a clk_get which is more closely linked to the clock framework
> implementation.

Yeah, it's that sort of feature that most pushes against doing it in the
drivers - for example, the regulator API never ends up doing anything
like the concatenation.

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPa3L5AAoJEBus8iNuMP3dGjwP/2HLi7NkO63ADygSaGxOVHbi
9LFC7ezbuRzL/bfvztxaexmZbSekxBgG9HnkEDiPsWuVLMAy6SuF1a8DEkDJIiu8
6kmhnGYJeWkBJuIYet+E98dvuy80/V5+SaulYUocoKVRLbUlUDglnaMXjZoDiE6e
nLqP8tX07/B//oUXPKsi+0EMZTWkzelaNfDAvnm88IQy5sZjFMkpbN2CXb/u5lPK
SJ5rhCkjXTX7n55nJzhBnT1SYtUWmerOVXN4EhFXWt2HopP7NJjmTIUa3rxIQSU5
6jc0IBKuzKdsDx2T56RPA8WlMbh6Bgiiw81QagY+ZgMmNKmsbfK5q12RU122Pub4
njvS/AdDlMeWxMmeH4139mflcqXB32zSL6yE9/Qlnv+ojUtklHFdVlt8A/0NkLiH
LRqmDZMxHZc+GEr0wCNqh16ODWJdPQn/FoOtWE0haChCkckayqDcjp6tIgwR4YVX
NOA/AnSLz1lvUZSlkI4vgXMyRUoKsOTyAIXcNtLYQxohXLe4azojGv9mEr27SqxZ
g11MjvL+u1KmTE+1Ymm3kpqxmutR4dG+ByZCf/w6JSns+awp8IK7V8JcEIPEuLy3
g9gqzrrjj6hgRSi2IkSHmqCONeYC10/cSspTOTkjCuT4wNV12tg+l+FXd/JktFMD
axxKJnfO+O9eZewA5jSY
=pdKS
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
