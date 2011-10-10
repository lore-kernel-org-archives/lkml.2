Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1JJJ0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:26:23 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:37781 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068Ab1JJJ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:26:21 -0400
Date: Mon, 10 Oct 2011 12:26:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: balbi@ti.com, Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111010092613.GF6685@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com>
 <CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com>
 <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
 <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com>
 <CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com>
 <20111010090330.GE6685@legolas.emea.dhcp.ti.com>
 <CAP05o4Kqrsr3Kzm=NDpEB7wHACzXkp2mQLuWdUAsZ8pVPdJafA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AH+kv8CCoFf6qPuz"
Content-Disposition: inline
In-Reply-To: <CAP05o4Kqrsr3Kzm=NDpEB7wHACzXkp2mQLuWdUAsZ8pVPdJafA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AH+kv8CCoFf6qPuz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2011 at 02:47:42PM +0530, Munegowda, Keshava wrote:
> On Mon, Oct 10, 2011 at 2:33 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Oct 10, 2011 at 02:22:23PM +0530, Munegowda, Keshava wrote:
> >> Hi paul and Felipe
> >>
> >> Here is the highlights of the change in the design of =A0USB Host which
> >> we can do after kernel 3.2 release;
> >>
> >> 1. separate the TLL changes =A0from UHH
> >> 2. The TLL is be a new platform driver in ./drivers/mfd
> >> 3. the TLL platform driver will export apis =A0for enable/disable cloc=
ks
> >> and settings.
> >
> > TLL should control its clocks through pm_runtime APIs like anything
> > else. If you really must export APIs to be used by UHH, you need to have
> > an API so that you can claim/release a TLL channel and get/put for
> > increasing/decreasing PM counters.
> >
> > I still think though, you should try to avoid exporting OMAP-specific
> > APIs all over the place. Ideally, we would be able to have some way of
> > saying that UHH and TLL are closely related... something like having the
> > ability to say e.g. two devices are sibblings of each other, so that we
> > could ask for a sibbling to wakeup/sleep depending if we need it or not.
>=20
> do we have sibling structures today? I dont think so.

no we don't.

> > Dunno, maybe I'm drifting here, but I don't think exposing OMAP-specific
> > APIs is wise.
>=20
> so, it means , if we can have sibling structure, then we can
> conditionally enable it right?

the conditional would still lie in UHH driver, but at least it would be
made into a generic API. I mean, you could create a generic way of
defining sibbling devices, and a generic way to make them talk to each
other.

--=20
balbi

--AH+kv8CCoFf6qPuz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOkro1AAoJEIaOsuA1yqRE/IYP/iNE1giE3h/L+Y2S8tJX4DYJ
1o1UXpmpft/1q4CuA01UvaH46JS/uLLPEnNuMNAgdprW3+PdXL/garE8z9cbiaVe
/lQXbG0krwU94sGxzTEFPlScMk8BGmaI9V/KdgsBamJ3oX0Bj7BFDeZg9tofCbhl
GGe3OGzs9p/3szXutERloP2FzT1YGQNBH7iwUXrBqtYlw+wdIPlB90ogrhDNWZys
obOSpo4MIwNICmedwxJrJF2wdwL7vqxbVy2Q43p2lC6/OnUNasvgRPocTbdr+032
rmDdf3NsCNebaOHYWGY/hRsjgYAAW0MlZHbu+LG/6ZACsM9mC5sHa7FJajDtF42H
AJ61UKSsnO7LwFAMtGyt6tWSjF0OU/1y00aRW67E28iv1cLDcJGT/d9MI4odhY88
6jghbNATx6jg0LPipRfFJKKSOJA+SQ0o/C+4ljrPg4UBfgXLvrlytovfD5gDoc8g
PWW/8GaTlOOsxg219ORr7kjNrwcvuze64dGgVtd+VGLuYcRDIxJgg3QKFrTs0TBn
lycro5fmoJYjbPpHyYgwxsaqNGAaS3bFHRyVrm11T27F2dkFnT2x1zrs1dXHios4
FVOQbbzNyMiWLkpXJ4Ls31MuFTPqxICxaS4xmWGsE7kQEW9eQ/KfsqZytqcnGal9
m9tBYfIUE8agV4YDAFo+
=2Buk
-----END PGP SIGNATURE-----

--AH+kv8CCoFf6qPuz--
