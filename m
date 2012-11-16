Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2KPNsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:48:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47519 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2KPNs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:48:29 -0500
Date: Fri, 16 Nov 2012 15:42:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: move dwc3_cache_hwparams before
 dwc3_alloc_event_buffers
Message-ID: <20121116134207.GB18527@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353047874-4981-1-git-send-email-kishon@ti.com>
 <20121116081719.GA16568@arwen.pp.htv.fi>
 <20121116124711.GA14886@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <20121116124711.GA14886@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 04:47:11AM -0800, Greg KH wrote:
> On Fri, Nov 16, 2012 at 10:17:19AM +0200, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Nov 16, 2012 at 12:07:54PM +0530, Kishon Vijay Abraham I wrote:
> > > commit 392142 moved event buffer allocation out of dwc3_core_init() b=
ut
> > > event buffer allocation uses the cached copy of hwparams to determine
> > > the number of event buffers and the caching is done in dwc3_core_init.
> > > So moved dwc3_cache_hwparams function before dwc3_alloc_event_buffers=
 so
> > > that dwc3_alloc_event_buffers sees the correct number of event buffer=
s.
> > >=20
> > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >=20
> > My bad, what a regression I caused :-)
> >=20
> > Greg, can you take this one ?
>=20
> Yes, will do.

thanks a lot ;-)

--=20
balbi

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpkKvAAoJEIaOsuA1yqREoe8P/2M6jwOsF6U451AhttxizF3g
1LmbmI/YOS/o5sdQ5uiv4SzDDs6NNSdUpTT6gLX52v3caNzDFVnjaLJi4n/xliVj
YQAKijzJaIcXe+qMezi0Dxt56I/CKLCuOdf8pE4Mh9VneOcfGJoZHzn3zzJjQc4o
Sc/ytJrtS4bz/uvvGK9e6SAsIIQBHyJWQWG/xgz3z/A7sU3MRqGBXAzyRrN7er79
gjKjTCpVP+GiumXmVLEXktanfwKUn8y7H1u0mYqHwPbuM04nwU5inIvptgZ6SM5p
AakETQvHKdmKlczj+PTDYZ9nyJ8i8kIhaB9MIIb+mXS4P8doUcHFwpJTyCHca5JI
bDUWECJO4H9ojPGpET1AA1ZykLGc+1Gelnt65oFov9hA643mFftXoexQ4/Gop4PW
gaLyWp0tBIJocZ3dSxyVOx1sRsUBavQ5bJc4L176RIFbsxlXHT6Wo1MYyjmRUxA2
JYP1DmZ15Dy/xZJrTafB2XrAvxWSQW3SIaWhMCHK0N1FcaJuOLDhflyvI6D2ZaKE
AFjD7ysqBrbfKholelSLl52F5KGwjZNmXNUo/jGl+b788Qd4ZmIK4Ih6AA1gelGF
OQO2D57AtM9esR4xH663ndypd1uxKOS4SJZNCw9Sgty5cdOJno7qaaaiRhjkk2wK
KiVH/D1fsKbGDOcuV4pu
=gfVD
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
