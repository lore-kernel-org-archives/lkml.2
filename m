Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2LSNyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:54:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35122 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab2LSNyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:54:33 -0500
Date: Wed, 19 Dec 2012 15:54:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
CC: <balbi@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Luciano Coelho <coelho@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, <svenkatr@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <cjb@laptop.org>, <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <r.sricharan@ti.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219135428.GD17993@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <50D19040.5090404@ti.com>
 <20121219100909.GO4985@opensource.wolfsonmicro.com>
 <50D19463.5010605@ti.com>
 <20121219103206.GQ4985@opensource.wolfsonmicro.com>
 <1355913954.5273.21.camel@cumari.coelho.fi>
 <50D19D54.2000307@ti.com>
 <20121219130128.GC17993@arwen.pp.htv.fi>
 <50D1C652.3050607@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g7w8+K/95kPelPD2"
Content-Disposition: inline
In-Reply-To: <50D1C652.3050607@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--g7w8+K/95kPelPD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 19, 2012 at 02:51:14PM +0100, Benoit Cousson wrote:
> On 12/19/2012 02:01 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > +Sricharan who commited that
> >=20
> > On Wed, Dec 19, 2012 at 11:56:20AM +0100, Peter Ujfalusi wrote:
> >> On 12/19/2012 11:45 AM, Luciano Coelho wrote:
> >>>> Well, we still haven't got the foggiest idea what the actual problem=
 is
> >>>> beyond that it's probably related to the 32kHz clock in some way (un=
less
> >>>> it was one of the other reverts that coincidentally made a differenc=
e,
> >>>> but we don't know what they were) so it's unlikely that just randomly
> >>>> implementing clock support is going to fix anything immediately here.
> >>>
> >>> This is exactly what I had to revert (as I mentioned in the other ema=
il,
> >>> I had to revert the other patches otherwise compilation would break):
> >>>
> >>> 0e8e5c34 "regulator: twl: Remove references to 32kHz clock from DT bi=
ndings"
> >>> e76ab829 "regulator: twl: Remove references to the twl4030 regulator"
> >>> 029dd3ce "regulator: twl: Remove another unused variable warning"
> >>
> >> Yeah. 32k clock is not provided by twl.
> >>
> >> As I said I need to take a look at CCF to see if it already there. If =
it is
> >> clock driver + mapping + patch for wl12xx should fix the issue you are=
 facing.
> >>
> >>> Let me know if you need more info.
> >>
> >> BTW: have you happened to ubdate u-boot recently? There is a nice east=
er egg
> >> added there:
> >> f3f98bb ARM: OMAP4/5: Do not configure non essential pads, clocks, dpl=
ls.
> >>
> >> Which means that _essential_ clocks and pads are no longer configured.
> >=20
> > anything essential you can list ?
>=20
> Yeah, that u-boot version is just unusable at all with any mainline
> kernel, since we are still missing pads conf for every drivers.
>=20
> Regarding the 32k clock, I noticed as well that the OMAP4460 panda
> u-boot is the only one to enable it at boot time, and thus this is the
> only board that can probe the wilink chip properly as of today.

hah, way to cause regression

--=20
balbi

--g7w8+K/95kPelPD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0ccUAAoJEIaOsuA1yqREjEIQAKbWCaWYxtkT0ULTeZ4KgAig
W6fu9nMJpnI7GD2ZuxUzmzg5jjQUgRb4pjdR/L02CBR4jDXz5kqgZjVDaJMRUYMd
AX8i7Qajr/w02VHB9gHHCXG7+X9KrQq5uIfTlzP+h5L5/8jBKoBN/Q97SH/jM5lB
wJBl4bqHklkNtpQLb8tPVOh19zaYHH8DZUgC2Q5PWGYtc00Orr356gjQGuDPpqEq
aBa3whwqarDOAt6PNZcEUGD/nKcVQvevaEVQVJqRp+l1pw3SWrEJzFlCTlS0Cen6
cqnMKlqHVa3dpUCQ79A+XXMmc/905ymBsyi5IvTeqlh1jzCwzbbsEqpJSFrAITMw
UVVvEmv3ONeQvFB4KhHAWpLTATffAvsaG7j1ffjKvyO3BTvzW21p4qbujXGucqPi
JxhbDbQCv7RxZe8g5Wzgz4XHGn079qfok2AocdzvS3MNnxhOa+93ptPlzx/qzMYm
CsEbSEyPX5EMJL1T+lf7SpGannH30FWxPh6G6w2uTS58XqP7TxJu9grWwy5Q1IDQ
wcfW2GTx5aMQmvfE3VBBxtJ0xpwZbreuIbH9JIDswsU48BB+lFAWBpxUt3ZjbMgV
zN0I1ccA3t6J4ekcg5nUr+ENdIdA6Ng0dijG930UdI78U1SSC2tIkFzH/nI8vyP/
pF89aVHKZ1HUSZJ0dYqZ
=rfOm
-----END PGP SIGNATURE-----

--g7w8+K/95kPelPD2--
