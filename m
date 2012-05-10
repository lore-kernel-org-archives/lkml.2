Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab2EJJLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:11:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54023 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755386Ab2EJJLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:11:44 -0400
Date: Thu, 10 May 2012 10:11:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ola Lilja <ola.o.lilja@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Liam Girdwood <lrg@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20120510091140.GE3908@opensource.wolfsonmicro.com>
References: <20120510143329.4cef3cd78ce5ea55416b1d93@canb.auug.org.au>
 <CACRpkdYsHXnWHvBw6Pt1atvwKP6KYjfu-PwQnL_L7-yW1-4_FA@mail.gmail.com>
 <4FAB7DC1.5060503@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="orO6xySwJI16pVnm"
Content-Disposition: inline
In-Reply-To: <4FAB7DC1.5060503@stericsson.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--orO6xySwJI16pVnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 10, 2012 at 10:35:13AM +0200, Ola Lilja wrote:

> True! I think we should put it in the "config
> SND_SOC_UX500_PLAT_MSP_I2S", though.

That won't work, the machine drivers should be selecting the I2S
controller driver so the dependency on it will get ignored, and
presumably any ux500 system is going to have this dependency.

--orO6xySwJI16pVnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPq4ZFAAoJEBus8iNuMP3dQxEP/jqkkv+kl6y9VRjQ55Jz2xGQ
I1T3EMMqUUx+c1eQp7qjMyGq4b6fC3mEWm4LCY+7dBBilDt8qhVpUAF0OIKXWa9I
Sc6px8cuhQTXpUjRQ09uP2ugTkXHltqj5N6UUuHp3IKGY40Ff7RtKfHyj+nwpePK
NnTCA3DdbMnPxR8kmQvVREVCIX3iW6w2LL9Rvfhf4MgYYiBfJ9gtg/dmJE0dH0FO
ANynsOF34PanCTvqoY1GEv0YRx6vvzq/E133o9qzi7PQvlGKQB3hrbO/VZP+6xse
IAzGPZqSMV3mqfr+IZA8UnFeiWwyNeGlZZFDqioHULQUP6UlzOYNr2z844I5d1Za
NL4hLEl/AFsHVj/apldXQddKoCNbvWNPkxTqNcyv5F797MPuEh6Wk7I0OCGyzGbp
z6cBoXFYAT1JwG6rQ79cTFgUsEJa4jw7YwQF8vXqTqFYsKW3L5+w89jHp1iqj79+
2BdVULleTpsIGJYHLcmkG3EZO5NcbmO5209ieg7nC0UjHFko+5qjcyI51m/kCD7c
Tr9eAhlV8O5JwyF4pY/dZBgvcrSat1a6Jam9IRUyB9Ql2I3qBATaakDzJ1FVXeMk
id739Fuono92YALx1KI4vVP6d4ra67LOepYr4+o3R0+sqVUAdb7qsXHgu+gyLU65
+2yP0cX48/3DV8A/o9T0
=a5BE
-----END PGP SIGNATURE-----

--orO6xySwJI16pVnm--
