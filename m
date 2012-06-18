Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab2FRQiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:38:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55519 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641Ab2FRQiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:38:01 -0400
Date: Mon, 18 Jun 2012 17:37:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2 v2] regulator: support multiple dummy fixed regulators
Message-ID: <20120618163758.GU3974@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
 <20120618115738.GI3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181755370.23884@axis700.grange>
 <20120618162058.GT3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V4yrq4dHtCqH+JvC"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206181826210.23884@axis700.grange>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V4yrq4dHtCqH+JvC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 06:30:30PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 18 Jun 2012, Mark Brown wrote:

> > None of this seems terribly obvious to me.  Once we're getting into
> > allowing the user to specify a voltage (and possibly other parameters)
> > for the regulator it's hopefully going to refer to an actual thing we
> > can point at on the board rather than a virtual thing we've got to
> > satisfy software so giving it a useful name seems more useful (like a
> > name correspoding to the relevant supply on the schematic). =20

> Sorry, don't understand. What do you mean by a "virtual" supply? There is=
=20
> a device, it is functional, doesn't this mean, that something is supplyin=
g=20
> power to it? And if power is supplied, then it also hopefully has a=20
> certain voltage :) Why I need to know it - to set an MMC OCR mask.

It's for cases where people can't be bothered to specify the supply
properly but want to just put something in there to satisfy the sofware
without providing any useful information.  There will be one or more
physical supplies but the software is being non-committal about them.

> > There's also the fact that there shouldn't be any need for unique
> > regulator names internally so if it really doesn't matter we should be
> > able to give everything the same name happily enough.

> What about entries under /proc/sys/debug/regulator/? Don't they have to b=
e=20
> unique?

Meh, yes.  I did try to make them readable.  But then making up the
names in this fashion does rather defeat the point there...

--V4yrq4dHtCqH+JvC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP31k1AAoJEBus8iNuMP3dnJsP/34Me79o28ryZlMVtomJZoMa
5KxpJjQCpkwc66xr1gIbZ5ojgKz6UMxUdacse1c7wC9I28WvsXsca8Sv0Rs4MGd0
CpHSZGqgl7f7lzmTQKCgBPO4276YtnapzIfcpoxmzaTeh0da79jLAH/8k5DOL/0f
UErQZCqJbtA9u3sFCmCBMYDeanUcqHkVl3UXcBj/AMACPncSTLnMM7H3bgAbm2PZ
RbQ+9NtyTrshAZFq4Vk6xOz1kzz1FpxNW23cMh/GA7GmX26/Zi8ZEBSmUW44eNSX
5qXkeCWAbGXJ3tQ+R3QtMe9mls6L1e/nqXi+KPaM1Rroat3lksvYLl2+Nznobf3u
L6Woz6texf3Z0Am/Ptj0zm3xNNTvDcwJauR21fzkU2n2+Rg823XOPwlxtnaX0tqg
HrCYHYQRENj/jy1Pmhrp2MLhPeuKynJneDJZYv8VFZ7az0qfma//TqBgeg06eCWY
wzKYZADxVtJAxqMigFMc88OctJpyFxcIGzeC6QCGkDeYdG3uzoITELEAKdSA4YGW
MHou8+i9NbArgoON1UrFBIrwjlERYZRcUNAjiD0NnjwbU96GOlqPDqZ3fodnqRqH
N9BcrTjGjoxgEFMQZZz6E4wfB7v2dgx/EoZPRZXl0EJupTrdW2zE7gEuNnampcNX
eJek8/rGrZCY5b50WrU+
=dp38
-----END PGP SIGNATURE-----

--V4yrq4dHtCqH+JvC--
