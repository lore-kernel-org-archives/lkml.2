Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab2HUQwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:52:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54181 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758133Ab2HUQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:52:09 -0400
Date: Tue, 21 Aug 2012 17:52:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120821165207.GX7995@opensource.wolfsonmicro.com>
References: <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
 <20120821095026.GU26991@opensource.wolfsonmicro.com>
 <20120821105413.GD26899@gmail.com>
 <20120821110329.GA7995@opensource.wolfsonmicro.com>
 <20120821120243.GF26899@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IfhPODtivl1BCmut"
Content-Disposition: inline
In-Reply-To: <20120821120243.GF26899@gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IfhPODtivl1BCmut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 01:02:46PM +0100, Lee Jones wrote:
> On Tue, Aug 21, 2012 at 12:03:29PM +0100, Mark Brown wrote:

> > > another way to get hold of the domain, because the only way to obtain
> > > it without having direct access is via a device node.

> > This doesn't actually hold.

> Okay, besides irq_find_host(struct device_node *np), how else can you fet=
ch
> a domain from the irqdomain?

I'm not sure I can parse the above, sorry - I'm not sure I can
distinguish "domain" and "irqdomain".

> What have you done already?=20

Implemented a patch for this which I've now tested a bit and will
probably post in the next hour or so.

> Why make suggestions if you're just going to do the work yourself?

I made the suggestion then later on realised that this was actively
going to break things I care about so I actually need it fixing.

--IfhPODtivl1BCmut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM7xgAAoJEFJkBDiqVpZ4AZ0P/05xqLDm0NdfMtjIM1gEE0lp
iCVMbB/HzNF7uy+xtbnZ0rotX2BictMgwB6F3/OQUIR5XMnTDxuQoxuwpEk6wstp
JHufOoKHoD2D5yier5JZIDm0dbkqrVW2qzJjlR6tdW5+S0iFFhZxxBoSVz6vbbug
Ik3sIOcsa1OJ+LtkqseosYbNliHymObW4qobj3YRLXhB7xG4Xoj0eXxrt9SUzMo0
rH4q96rE74XuJZW216xdDU+IvaPkzcmMyANb1ipVTeUMoI9gV2F8XhKX1LIg0jVM
rnrUS3SKvA2kIt3noBI5qcqxE0WWq7gOzCWXp4RJLECg6BRGzxQU0nIYR8pjqpOn
Pq7k6zBdEKX7c2BYfiZptouya0c2yol3zo95uXZJqkIDsVy+4C6Kmxn6tJKoi3hz
3D/HgCBc7poPSPqkw62Sj1Nt8ESHsEPg2SjCU+ZbMUaYBD7XxAfZdxsjTKnFwuVU
hYFbmfl6GY4YiEU/SpAW5czrfypEZpJOoczD59W/Y7mMUNeMrq3KkTyUYfJ7x5ix
VxV8kJVBbDxeE8BZRPAxym0Y+ivAf0L6Fi8Ar92boKAO9zeEW1NHqPT37KL7iCx7
1kI57TNb3dmT/4Xpc+SoUH+EnL1EjPg/2N/rK+4qWpRLWK8Alb1RRW6CXd82XPWl
ttAhxFpxTAqTBJW6xmLL
=6Gif
-----END PGP SIGNATURE-----

--IfhPODtivl1BCmut--
