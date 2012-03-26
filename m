Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2CZOvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:51:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36513 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932652Ab2CZOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:51:00 -0400
Date: Mon, 26 Mar 2012 15:50:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        marc.reilly@gmail.com, s.hauer@pengutronix.de,
        fabio.estevam@freescale.com
Subject: Re: [PATCH] regmap: Add 24 bits support
Message-ID: <20120326145054.GV3098@opensource.wolfsonmicro.com>
References: <1332772808-13346-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jWL1oGPK2mPq0rME"
Content-Disposition: inline
In-Reply-To: <1332772808-13346-1-git-send-email-alexg@meprolight.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jWL1oGPK2mPq0rME
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 04:40:08PM +0200, Alex Gershgorin wrote:
> This patch adds support for PMIC who use regmap and 24 bit registers
> For example MC13892, the patch was tested on i.MX35-PDK

A similar patch from Marc Reilly has already been applied.  You don't
have his signoff here but then...

> +typedef struct { __u8 b[3]; } __be24;

...you're adding stuff like this to the regmap headers which *clearly*
isn't regmap specific so this looks like a separate development.

--jWL1oGPK2mPq0rME
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcIJEAAoJEBus8iNuMP3d/p4P/00FzJ9nJp5JoV7HP8eXJr23
qpZtn2hmk/TmxuYebRAaduEg85H6WXBRgihF/td1I3o74fIh7KZIog1cklj7IYck
dLT1cII4ssJSuHP3KvQi2iLbOJYDR1nSK4eYyx0RpmStb4/0X2xQHDzQ7/yrlarC
GHqOeExN7EKhdx2FOS96JzDpeZwf7aUHJyL9v+uMUHg6XPaP+BJlEMEoK4kQ5GjC
sXCqP3BZ+xchPd1IKG8Dz7JuK2GfsKoUss48bDHQVyoTYvGeJqpD3Y42s8BbrOjw
l9Xcu3WFFnj1oI8bDjTI3XR2wIQgNxJoOjD2So0Dljqe/FbGS4qjd2FSmMoTbmEt
SCAJvdFziCPdE9lW5/SdZ9lrpk+yBB9eKcY4o77giv+DRrWG2ALeKn2T+kvQDVtG
0cPxmMshgmklcyroV6tHLmOJAKroBZYdBRZ3c0P2Q+6HgJskBa0yEImAcHNU1OOH
WAYMdEC6uX8KaVotIR3opdy+uAKUeOn+lzXEuidK86LinqL99tiMH/IzqmUjFijz
ExngVHP6Qk/YluboSKRTT0cDX5nxnIl00UmactJiXrU+quFFMUW3F4GOqZPGOZ3D
0qYpzpiDVGNw31U3s4MkZK+sR3Bxh/iUdWd+by6NJPy2YRQvF+u/Joqf4ypAMJJW
KQsfeXzJaduv4oTw/7B6
=1Qqm
-----END PGP SIGNATURE-----

--jWL1oGPK2mPq0rME--
