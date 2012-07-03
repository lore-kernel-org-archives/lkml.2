Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab2GCQSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:18:06 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:41351 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755297Ab2GCQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:18:04 -0400
Date: Tue, 3 Jul 2012 19:15:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC 0/2] USB gadget - configfs
Message-ID: <20120703161523.GB23380@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <4FE76F6C.1090300@linutronix.de>
 <Pine.LNX.4.44L0.1206251006520.1770-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206251006520.1770-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 25, 2012 at 10:11:43AM -0400, Alan Stern wrote:
> On Sun, 24 Jun 2012, Sebastian Andrzej Siewior wrote:
>=20
> > On 06/21/2012 12:55 PM, Andrzej Pietrasiewicz wrote:
> > > $ echo 1>   /cfg/usb-function-gadget/G1/connect
> > > $ file.img>  /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0/fi=
le
> >=20
> > connect should be available at UDC level which triggers the
> > pull-up/down of the UDC. The gadget itself should be configured once
> > and made available / bound to the UDC. And you may have more
> > than once UDC at a time within a single a system.
> >=20
> > > Each function, after creating its corresponding directory
> > > (/cfg/usb-function-gadget/G1/C1/F1), must be "personalized" by storing
> > > its name in the "name" attribute. After that it is possible to create
> > > a child item of the same name ("f_mass_storage" here). The common code
> > > handles everything from top of the hierarchy up to the function direc=
tory.
> > > Under the function directory a function-specific stuff provided by ea=
ch
> > > function is used. The function-specific code is abstracted by the abo=
ve
> > > mentioned struct ufg_fn. In the example, the mass storage function is
> > > supplied with one LUN.
> >=20
> > The hierarchy looks good. C1 vs config1 is just taste.
>=20
> My taste prefers "config1".  Same for "gadget1" and "func1" (or=20
> "function1").  Words -- even short or abbreviated words -- are a lot=20
> more meaningful to people than single letters are.

I agree with Alan here, though I'd prefer function1 instead of func1.

> > > 4. Do we need module parameters for USB descriptors like iManufacturer
> > >     and similar?
> > No. No modules parameters at all. With one exception: Currently we set
> > those things via modprobe. As a for compatibility interface I guess we
> > have to keep this. In the end I would like have f_mass_storage gone as=
=20
> > it. We would have a new gadget_storage which provides only the function=
=20
> > and relies on configfs module and nothing else. The replacement
> > g_mass_storage would simply be a small module which takes the
> > iManufacturer parameters and others and configures the gadget the way
> > the old gadget did i.e. without echo this and echo that.
>=20
> In any case, iManufacturer should not be adjustable by the user.  It=20
> should always be managed by the composite-gadget layer, since it=20
> contains nothing but the index number of the Manufacturer string=20
> descriptor.

that's a misname, actually. The iManufacturer parameter is waiting for
the actual manufacturer string.

--=20
balbi

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8xqbAAoJEIaOsuA1yqRE0soP/2yQ1N6K1q5HLYc0GvryTFdx
H0T1dOArnjaPN5coZhMe0K4sE0XNImZXxADfDqvgK5gQ+eKNwg7YlqmqIwzSj30A
9DhUI9ka++3g4q5zke7la4EFaNPzXkKcg8bo7YrMXABfacfDMZ+Z+pwOBJtFhoyQ
zJXBz4R+nEK6hZr0ccrLVOJhD5bXhSRdHNaCN/M2HwhR6DsKOhA7hGxEkRXIgZ8x
xFyK31fw5MKMsDn5uQmiilfUqX4XKxJM3jpKGI3etKjiULyBt41NXtoqE1epQP0k
3ueikhX7Bq/GoZusOn3zxTBxfLOcilJB/04wST6wPScoR/Lwj3xOZHrIdAf8AytD
O60sNlGBi/xViS8eCG2SivHTUojJZjlDpfnnEeM8kLDHh9bdrfKFHISxLH8QiivN
MXyEXDCz58MmESTl3dXjw5VJatBXcQ9198s+b4N2WjMNy2QVQPnkARD7EElhgbKF
AD+CaZ+SC2DSMBYn57BSRGjzEEEnROX7jrNC2qPrcBNk5UcH8lga0iMftMs63l0d
YZHYHxS25X/RNyFE+Rl9hFSdEQPExPnvoHyW70lPqnKCn42p41U2/eVpSFaYxgJb
KmAn6ATaz5egEKC5xQzm3TnSEn05PmtXJEfghOkvkEI8cPrmQuh34QpbsVv5bgR6
p0eoeXjSfQfeyfDjyTqb
=l/rG
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
