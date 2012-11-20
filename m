Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2KTI2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:28:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39362 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901Ab2KTI2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:28:00 -0500
Date: Tue, 20 Nov 2012 17:27:44 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: DVS regulator drivers
Message-ID: <20121120082741.GV10560@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1211191213380.11024@axis700.grange>
 <20121120010547.GD4483@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1211200856380.21420@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b3OyYALfe3DXUU4J"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211200856380.21420@axis700.grange>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b3OyYALfe3DXUU4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 09:17:46AM +0100, Guennadi Liakhovetski wrote:
> On Tue, 20 Nov 2012, Mark Brown wrote:

> > Please don't invent terminology or repurpose existing terminology like
> > this, it's just confusing - obvious essentially all regulators covered
> > by the regulator API support voltage scaling which is the usual meaning
> > of DVS.

> Right, sorry, a more precise term would be a "pin-selectable DVS," right?

Yup.

> > Can you be more specific about your concern here?  The above code does
> > exactly what the comment says, it will set the selector it just picked.

> Your patch fixes exactly the problem, that I was pointing at, thanks.

Oh, right.  It sounded like you also had some concern with on_vsel which
I couldn't figure out.

> > You did spot one bug (I think due to bitrot) which I just fixed but in
> > general I've just TLDRed this as it's a bit unclear what you're trying
> > to say here, can you be a bit more concise here?  I'm not sure if
> > there's a general point or if it's specific code issues?

> Sorry, let's try again. Just to bring back the "too long and a bit unclea=
r=20
> part:"

It was the mail as a whole - I spent less time on lp872x since I don't
have any access to the hardware either.

> where dvs is platform data, i.e., all parameters are constant. So,=20
> lp872x_set_dvs() never switches anything, and in fact it could just have=
=20
> been called just once from initialisation to set the GPIO. This also=20
> means, that only one context - either SEL_V1 or SEL_V2 is used.

I think you're right there.

--b3OyYALfe3DXUU4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqz6jAAoJELSic+t+oim9O1sP/3KyLWGtw6TfYOXUlYvfZIYr
5fXyTCOGeQD5vMQJObNYsGLOzGwozl8a4ZstVSGOulZnU0M3dfzhmVRevMdT/8CP
OcI4rInUvopD+oSk83/KKwTF/h3GpqnbWGuomOotqFNbckX9VHgAieuDBYGEtyL4
VPpJ79FXPEf7PwXSoaGEVE/cmbKBc0DI9uqZfSKUNkRIcnuY0RneF1iW9miXaHOO
AZIveU5A3KHM3sqVjr/CitBGp6h0bljCMWs5bi5cnsZI3DGQK1xh8XAddVvVs0Xk
LhNzmPtV0btTDF2hnGEJh1xTVPdqc9p8nNbFuugz4dzIopxQbjC3fhySfOPVz6iK
XwSxoKeyurBWpSiPP8Hy2nIE/Fi3098Smv+L8dgWjotsTR93EgKi/tivXdoBMscP
xvLs+x3MrwQdUwjTeT1H7qKxRN6HDe2WuhLxpGjaYr1jIawQCnm+Lfw9M86DyfCA
U7oVh7NwW6I0TVV/8K4vgp9YCTZFjwmXWe+kB679bnOCGp5wU1hz/6yqXoSj1uc5
s/PPgH/k6YikaoQj0ZezeANogKdi5sXOJRdICpD4mKen6WWKkx/LyHroZiV9OfCp
cic3g9UaVNxdTuAVIrupS420qcPcPgey1yu/2mOlacK5gS4SDmCgy8ppWdiHjv+d
h0DGPAUaEaUWvObRiKeQ
=Wm1N
-----END PGP SIGNATURE-----

--b3OyYALfe3DXUU4J--
