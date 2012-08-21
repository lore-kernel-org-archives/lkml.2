Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2HULDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:03:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab2HULDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:03:31 -0400
Date: Tue, 21 Aug 2012 12:03:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120821110329.GA7995@opensource.wolfsonmicro.com>
References: <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
 <20120821095026.GU26991@opensource.wolfsonmicro.com>
 <20120821105413.GD26899@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20120821105413.GD26899@gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 21, 2012 at 11:54:14AM +0100, Lee Jones wrote:
> On Tue, Aug 21, 2012 at 10:50:27AM +0100, Mark Brown wrote:

> > What makes you say this?  This is just a convenience for finding a
> > domain, irqdomains are *completely* indepentant of device tree.

> How can you say that? I think you mean _can_ be independent of DT. If
> that's what you mean then yes, that's true. All I'm saying is we need

No, I really mean what I'm saying.  Device tree builds on irqdomains,
not the other way around.

> another way to get hold of the domain, because the only way to obtain
> it without having direct access is via a device node.

This doesn't actually hold.

> > > - I know that you have interest in pushing the functionality into the
> > > IRQ domain subsystem, but I'm struggling to see how. It's calling into
> > > the IRQ domain where we're seeing issues in the first place, specifically
> > > irq_create_mapping(). How about if we passed 'irq_domain' as a parameter
> > > when requesting the IRQ? That way we can pass the correct IRQ without
> > > worry of conversion. If 'irq_domain' is !NULL the IRQ management subsystem
> > > can do the necessary conversions. If 'irq_domain' is NULL it continues to
> > > use the requested IRQ as a virq.

> > This is totally orthogonal to doing the mapping in the MFD subsystem
> > which is the issue here.

> Again, I only mentioned this because you said you wanted it to be handled
> by the irqdomain.

The *mapping* should be being handled in irqdomain.

> I'll code up the second suggestion now.

I've already done this.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2r3AAoJEFJkBDiqVpZ4CzwQAIKqmg4uHZ+1+A8520VpDDND
fyLKVy9XVElyQ4i751zMoHCbGa1WRHzIAyU2+xKzaI3K+uSmuWJqVT43V2jmmHFu
0pjjSgA+UpVdQ4VsU09ngAdLvVfTxtzDS8RWK2OrLlCODPUjxIhCTtB++oMP3EL9
2c9rWJn0D2VsY4cfnnvuUvfh6L+9skxXHWQZhLCnLLx2jvEdg4OZ59RDN0MF4MWN
R3Qouy6YJW4UDCWwDv+ofrI5JeuUtxYL50t/yMQnZyJVVKUi2+rU34iV8d61bohM
KyFtKSm98qPUZHYvMdAzqHofo9IX7R9kR4zdeqMQM3LQ6oAvdl6ItTUIkBnLghG3
OuF6FyY+g2mXSZ6NLBISuldkiDQilC6CnwolYH/T87uQBjG+0gNjGxGnEUgi2cue
72b2SfZOCg7z/mR2XTQPyC9+UaR5uiNaf4s7pimvxcT60hdrNKnlrh4lbrmZr/+Z
h0l9ksFaIe8Va3lMjFhLQ4tdgnDTgRLteV4bna+voVUN710dYJ64sed6tOyKfLTj
AnzLTwwZcCioMeBmtFIgYt0Jq1SbMZGmAYRCNd5iD5G5+0/x/i/MIs7soaD/Zudf
l8H4nO8lIZcg7zzu4FN1SiBVNwee4D7X3vnuDDh2xPz3lOaAH+zrxkXgMx4+czHa
2ALNGFvhL6MOIEY+9cEl
=Fbwq
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
