Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2DJMKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:10:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33396 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab2DJMKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:10:42 -0400
Date: Tue, 10 Apr 2012 13:10:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: twl-regulator: Use DIV_ROUND_UP at
 appropriate places
Message-ID: <20120410121038.GI7499@opensource.wolfsonmicro.com>
References: <1333985710.16502.0.camel@phoenix>
 <20120410100621.GF7499@opensource.wolfsonmicro.com>
 <CAF+7xW=yH8Le2cbRhun=1R3DdUkETVedZt75Yt1LMsop-PQEzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8NGGaQn1mzfvaPg"
Content-Disposition: inline
In-Reply-To: <CAF+7xW=yH8Le2cbRhun=1R3DdUkETVedZt75Yt1LMsop-PQEzA@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N8NGGaQn1mzfvaPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 07:49:23PM +0800, Axel Lin wrote:

> Seems you apply V2 of the patch.
> The V3 is the correct one. https://lkml.org/lkml/2012/4/9/435

Send a fix if you think there are issues.

--N8NGGaQn1mzfvaPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhCHrAAoJEBus8iNuMP3d0L0P/ieW8uFRVixVcc2NEoyO/lb8
YNDfD4xx4YO9YbRbhqb8geTr6qCrC5yhU0QJnoqe/mWSSQZFGHUeQhJU2+p8Bg5W
Gbb/a/d1cBzHnat/BFcxfRn7K7NT2sLDCv7/EkoJYM4m3tWtZr5x1YRsLrZStlZj
LUGk5Y/64MpP/QhC32nvpHxr63F5qod8HVBZveD44P1oxOL8MCJ9PHdT1hGCbzR0
n8/7Cp4zS6aRgvAQl1sWSFgK0Q13ybXYlyCVVl2y/dQY67zfqBDsdsi23rsuwiDu
k325KQ6mUCBWStuq0CTmt7Q9MR5uhQhEL4wKX0xSkKaD7wVMNUFeiMwD/rpwXzSF
X/E/NcbBox1jG2OhUaNGLNt8pJx/rKPZrM8FqLRLrKgIhJxFVJcJhnyNWZU8qQXh
a3mttlN1bHVl2WKAz2XLZjLyoYC3pF62AH/5EGDVfyl0HfCS3vz/aNb2/VrkhwmF
3m2QalPSqlzuOpmWjmgMh25pJzZeHg7kOD0G/2XRxv7gCpVqTRXayRObhQ8k0AYL
R+hloZAd0Kn9hbawoXxKLqPwZBvHdj3Q8UJraZJdMe2mDR2MM1U6nuNcMIOMchDF
VYwlWNSWL6DuQvYBzJXIax5y29umgRZmDOGazvY2SJ+c5UvLNcdEBkT/7pXGa+2Z
08WySsALFuq7rFwiwGlm
=UQYC
-----END PGP SIGNATURE-----

--N8NGGaQn1mzfvaPg--
