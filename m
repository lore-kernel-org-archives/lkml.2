Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2DGJAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 05:00:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50885 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503Ab2DGJAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 05:00:21 -0400
Date: Sat, 7 Apr 2012 10:00:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gpiolib: Implement devm_gpio_request_one()
Message-ID: <20120407090018.GC3099@opensource.wolfsonmicro.com>
References: <1333552489-27694-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333552489-27694-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120406044832.7C80D3E0ED5@localhost>
 <20120406144917.GE19424@opensource.wolfsonmicro.com>
 <20120407022512.2C65C3E1B12@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
In-Reply-To: <20120407022512.2C65C3E1B12@localhost>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 06, 2012 at 07:25:12PM -0700, Grant Likely wrote:
> On Fri, 6 Apr 2012 15:49:17 +0100, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > Yeah, I couldn't understand why the non-managed functions were written
> > in this way so I followed the same pattern when I added the managed one
> > assuming that the original code was sane.

> Actually, I looked at it again, and the _one version behaves subtly
> different from the non-_one version.  That may be irrelevant though.

It always does a direction set, yes.  This will make a difference if the
direction call either fails or blocks future reconfigurations, what was
puzzling me was if this was an issue or not and like I say I decided to
assume it was and stick with the same pattern.

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPgAHVAAoJEBus8iNuMP3dUFkP/AzuZXVz1bC4ogFD4YD/DZgX
+ZF1EXL+l9VIFi407MNTU2+d6PvH9HYAaXtn+mYeCgVwWWFrTHpVUivnMhEA9KHT
hBtyTaEEICuLyxNFcHYT8Lpx4Hl1dGYnFXC1F3Ew4ezjmYBNjS3ugEr03XDB5zxK
5kEXOZPyQZK9CAHutUeAp3yvv3wWkOgw8KGqfc/93DXGSWktJU+Qm+S/eJtmdMzt
ouNa1rCup023QnS3yTugxt4o5ki6QpOhpzYgVGXy5r0UgK1wq84oQBtZFKfjc9LV
Om8x4PYuhSC5RJas45GEBN6ok/oZPe1Ehi9q6Xd/NQQzhrBIOdgKy4FKnZaROIDE
PxAWAe9B514sJ2KgFpWW3Om2Xb+yhadDIs0xiBO1MNFhPeNbDtO1i2z0C0E0fBUp
a92X0aJ2lj+6JnJ0iIgtR0wfpoCzybMe5Py2N5T6omBV56TZr6Hiufsua5ea5Tkz
xeAYD0lFerdzagAVO0O6eyaEWTxtHnYr7qSyvrPPn2F44RNoMQ+sVJVkFOA3zOme
PglXissCL3gtkdDT1lt2H2LtmMoTSkdBxn8Hs9xqdblhjg0whaOm3oEnMsfoTUi2
fZmMOIWac/YMoqo6zpYCiWb9Aps+awly7rwOGek+IxTBB0q1YuLHlwhzPbimmcJy
B/NrDweZ0uUX9z6m4is2
=V+cL
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
