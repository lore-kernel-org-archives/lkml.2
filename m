Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab2ISRea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:34:30 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:57778 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701Ab2ISRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:34:27 -0400
Date: Wed, 19 Sep 2012 20:29:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Sonasath, Moiz" <m-sonasath@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] usb: dwc3: Fix gadget pullup in SS mode
Message-ID: <20120919172939.GC7784@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-3-git-send-email-kishon@ti.com>
 <20120919115306.GG3772@arwen.pp.htv.fi>
 <CAEgRx2zOVn0zV39-cuPuj4n4HRgQmywy_NY4KTe0qEgeC+NEkw@mail.gmail.com>
 <20120919160450.GA7510@arwen.pp.htv.fi>
 <CAEgRx2yXStORBknr2hoMcobMO8wFGuKr4bvzZwEQHQQcHVH76Q@mail.gmail.com>
 <20120919172442.GA7784@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <20120919172442.GA7784@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Wed, Sep 19, 2012 at 08:24:44PM +0300, Felipe Balbi wrote:
> > > at minimum this should've come with a proper revision check anyway.
> > >
> >=20
> > Actually most of it is under a rev check :)
>=20
> fair enough.

one extra comment here. That revision check is not related to the
silicon errata you mention. That revision check is there because the bit
definition of that particular register has changed a little bit, so
we're just handling a slightly different programming model between older
and newer revisions.

--=20
balbi

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWgEDAAoJEIaOsuA1yqRE0YMP/0QnYGsHl/TJqh4iyowMnLk4
mU88PfxHpN1o/KynAj/R+hVpizQaOprohV3r3EFVg9AEF/c4NOY5ZUWh3TkCvQC6
eAhBPL+hh7ki54C9yfYNJhLXZB/YH6JFSoZ+JrSZT96gbWSWvOf8vSt/mVwQ7cpt
jYHC6OZKATyKEGs8H+CLrmyEsx04vxMVN33YIr7osVTREd8E2j5ZYlROGsecAd2F
csgsz+Utuah8NZz+HH2kFfNUVBGNloT8G3dfgD5DnNNI9KBCj1j9Upc6Wgk9FRfV
XydcvrllD0gCxhJZPJn+x73spmqDUTjL5GBiqS/xoh7n/VNOI2Mx2C8EcgVlm79f
RXgyYmUw6kHJLMPA4T8mMOOjX3mI3GsDyug9PklNY8lc4fnMjzInW5zWxA3n8hXZ
3AlvKtsKYf+KKx4jQg09n+YghOOmNmt/mGIJQFqvaz9IeT82JQ90yCdCYqkmOjhF
zqxjpDarm7CyrFFemURPst2IVbmHVDY35N0gE+1cgHgbh6a3y8MGE1ChvHg7FQrY
oPPqs0iaxRBZAfxfs/L+r7wGdXxOp1C1+/DVxSYyB2mQXL0mp6bM2FMHquHht/Cn
pPqrQhXXdlw1OI7q7Fni0Hme0WzgBHbKSu0eo+RApJX7YVyzGy6NX4VZtvW/+weH
F8O1eYOPrK3snoupRE3x
=JG2n
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
