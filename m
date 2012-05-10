Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab2EJJer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:34:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34351 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757870Ab2EJJep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:34:45 -0400
Date: Thu, 10 May 2012 10:34:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] regulator: Add support for MAX77686.
Message-ID: <20120510093442.GK3908@opensource.wolfsonmicro.com>
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
 <1336580695-1184-3-git-send-email-yadi.brar@samsung.com>
 <20120509184709.GC32037@sirena.org.uk>
 <CAKew6eWEYBP1zXXwLL4eWOhOKZ-HwAfUX_kg8cnsaDyUXVKSkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iSeZnk6FyAS3EJ1y"
Content-Disposition: inline
In-Reply-To: <CAKew6eWEYBP1zXXwLL4eWOhOKZ-HwAfUX_kg8cnsaDyUXVKSkQ@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iSeZnk6FyAS3EJ1y
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 10, 2012 at 12:54:24PM +0530, Yadwinder Singh Brar wrote:
> On Thu, May 10, 2012 at 12:17 AM, Mark Brown
> > On Wed, May 09, 2012 at 09:54:55PM +0530, Yadwinder Singh wrote:

> >> + =A0 =A0 [MAX77686_EN32KHZ_AP] =3D NULL,
> >> + =A0 =A0 [MAX77686_EN32KHZ_CP] =3D NULL,

> > Now that the generic clock API is in mainline these should be moved over
> > to use it.

> Sorry, I cann't get your point here. Please explain it little bit more.

These are not regulators, these are clocks.  They should use the clock
API.

> >> + =A0 =A0 if (pdata->ramp_delay) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 max77686->ramp_delay =3D pdata->ramp_delay;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 max77686_update_reg(i2c, MAX77686_REG_BUCK2C=
TRL1,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 RAMP_VALUE, RAMP_MASK);

> > This appears not to actually use the value passed in as platform_data.

> It gets corresponding index of ramp_rate value in ramp_rate_value
> table supported by hardware, from platform_data which we write to
> ramp_rate control bits of control registers.

Why is the driver unconditionally writing these register values here
rather than setting the ramp delay that was passed in?

--iSeZnk6FyAS3EJ1y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPq4urAAoJEBus8iNuMP3dm4MP/2/+jQIWB2OMph66lu7FnD0s
gc/YAQCsinMwiKpRTRNkYJNzGc+IRZyHelqLTc8cRXgdLtsZDrWdBVaxqXbiftIz
57jEz3Tr+5ovgIjllJ7a65J/Ye2a3VdozyPqxTqfISK45piHCy2NGTJIctbCqfDA
JYpV/Vhqn/Lb3fg2xquGtCh6Hd9omD7TYhqdTpPNUzMIkj3xrEiX5Iv1zpBMMpst
u/rLyEHTUj7tovJkOrtkLUVe5PFm6M07g7KgvaaUC52+bjdh1t+slMSYgaL4zw17
760CG4NO/3xxoxNDDH7wb6uJ+BA/mMyhU/ay4tJVZlMbOJQ14V327+R4F/QEm3NC
SDQJDKAGb+IdoYcQPxtCMWia5NzU+l4a62pHvByelFBMnZUJhyRJHibvwdmK5XUU
VAtdwPY6/X3jmeMGSnT4E1iQMDFFqA8ghi+bByL4ROqt1Bl9WqrbecTEPOaSakIm
GwiMdfqoKd4Mwwl+y83M1iRgp2Xvc+exe0ZNnvxOWJFwzFzpouB/2e9TxQ0MfVN6
IimTEk851eJHJTslsnQUZRe155QChIYuDqcmZy3ufaXePoOHNGxJrRcLeTdZCfHa
eVMvFbVdWk8+ugYFNxdc54Gf4NQxkTB7M5NuebfJufUPvAwH0DiRbAwsOzh3z+3L
zIgSXcgj+zPdFcZ9RLU2
=W6IA
-----END PGP SIGNATURE-----

--iSeZnk6FyAS3EJ1y--
