Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2LSK2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:28:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54545 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab2LSK2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:28:37 -0500
Date: Wed, 19 Dec 2012 10:28:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, svenkatr@ti.com, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, cjb@laptop.org, lrg@ti.com,
        linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219102835.GP4985@opensource.wolfsonmicro.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
 <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <1355911317.5273.10.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9v2bTOXBzuB5Piju"
Content-Disposition: inline
In-Reply-To: <1355911317.5273.10.camel@cumari.coelho.fi>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9v2bTOXBzuB5Piju
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 12:01:57PM +0200, Luciano Coelho wrote:

> I think one of the reasons not many people use the mainline with TWL is
> exactly because something seems to break on every new kernel release.
> I'm one of those who care and report things when I see them.

Well, it's a recursive thing - nobody works on mainline, nobody reviews
mainline code and therefore you shouldn't be surprised if there's
issues.

> I think saying that it is not important because only one person reported
> it is not a good excuse.  I would at least have liked seeing an answer
> saying, "this can't be fixed because of this and that" or "can you try
> to fix it by doing this or that".

That's not what I'm saying.  What I'm saying is that it's clearly not
the case that OMAP is completely broken here or anything, it appears to
be one particular system which it appears vanishingly few people cared
about in mainline even before all the stuff with TI recently.

Looking at your report the reason I didn't reply myself is most likely
to be a combination of my expectation that someone from TI would look at
OMAP problems (at the time there were hundreds of people working on
OMAP) and the lack of detail in your mail - the bisection report was a
bit unclear as you said that you'd reverted the patch "plus a couple of
associated patches" without saying what exactly you'd backed out and
there was no analysis of the problem to engage with.

--9v2bTOXBzuB5Piju
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0Za1AAoJELSic+t+oim9WjIP/RkUuex/HoNV5Tj6cpq64pGw
OjcLNkPUQ5etIr9wBHmk0egEc6eCBQWG4c3Mq0VgZs5Iyy1sHGZlAvmmlkOZO/O9
Q6UkZBVO5eUImT/vXHoZp1skJxipFnL+9rrhYOAWlr1aK51FsMSjifbL44RZ50gT
+vchkrmqoIFLfaxX4G8toeKnIkVCEIK1v0ZJ5K0iu6bMxq8HbrgDejord8MXgLTP
Yp8jlGYbSn3PhqBo/FRhzrKMCZc1CMR5cLaQ/27PSojOrepMcjbl6uNP9NRC+3PS
IuH7yRysCjLSGYrwT2n1fgtj9HiRgK8AcyR+5IiYSu2puBHgyv2nbcaGCq1hv19H
GX8Hjfcg0wwa25CcWLQd2JAVd90Cz08F4th0VMDWxmttzV1GZrFVaJktaa0h3Rj0
+0BO0PMCKqX0mCkshMB8KqWawUGmPZru4qaxN++BO/KUSZreDOgI865IWw4KhJtc
avcpenu6EXnNxol2b3x55dHMfTs2COht2g6T+zbnm9/l3vvKlQKoteABWU5UCIJw
dwLwW4d4jydecWxEC5/q3S34c/SJ0KLJta9sfY4lQIpXOCKQVETxqjzWg6VL0Mu8
FW3gbZI8IR1dX46i2j+dA8Un8ZLGN1mZ4gQBJlT7nmaYmHCcUXw0sAkr7zw7sK7P
sIZJcv3zX1ALIPWixVi2
=AdQt
-----END PGP SIGNATURE-----

--9v2bTOXBzuB5Piju--
