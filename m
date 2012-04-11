Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2DKJmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:42:06 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:47440 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754120Ab2DKJmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:42:04 -0400
Date: Wed, 11 Apr 2012 12:41:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: remove deprecated fsg_add()
Message-ID: <20120411094112.GK12064@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com>
 <op.wa9go4093l0zgt@mpn-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/+CTqSGWdiRg+8j"
Content-Disposition: inline
In-Reply-To: <op.wa9go4093l0zgt@mpn-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/+CTqSGWdiRg+8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 12:25:42PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> There are no in-tree fsg_add() users and it has been deprecated
> since 2.6.35 [1dc90985d1: fsg_add() renamed to fsg_bind_config()] so
> out-of-tree users had more then enough time to convert.  Removing.
> ---

applied, thanks. Also added your SOB, next time be more careful.

--=20
balbi

--W/+CTqSGWdiRg+8j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhVG4AAoJEIaOsuA1yqREMJYP/2qmQS1TfVRWbWxXmPRUTnrw
tx9i6/45u5lWsKuue3c9xutXBZCTKfC6U2ddZwrFdeHcQnZb/9ps9lG86ONY4w+B
ivrLMs1zd+CRwpiq58PzUNN0K54n9aFBUpvWTazgoH0jy42MX09s1MpZ95WXoWrY
qk1lLL8UhS6zNsbbd9kBYsBVQChRRQegg2uqP0e+UFuakBAHczZC87D7VJ9kjRLo
ICpVYk5D+jqpRpPHxoAXbsjjGs7UQ8WpfQgh8meRcQfRE8Lrp334pKrNgM3LPM8F
5FJrU9nu42bVIrRhiAQ1r87qB3p7ThOqKp6ttFmPRvgkl2835aWfWDaaxrw6fIpT
NB7TIByQNDyyHpVVLeg7UraWPmEHdj2tRE5zKppJF3jWhzc+6qQ1ajrxJtC+jmvZ
u8yS9qzHDh1xI4An+6ilWGHldqAPBhQ5jaUnikp39EaTTECNgoSenn8uzXlv//lc
FJmA5L+gl0vz7G0wr/NcNqGppE7me9tzuS5uUcxAR9QhZEv4rYv6XxvZSTlvO6dz
wVaLzFOAv7rU6dCgUhLwIaEXHhvQwapSlf6sF0KN2unkq4N2ldFDX4b3VhuG7MCE
wZ0fSGn1mxZArzynbsgd1ScZyER89e0cUzAUJ8QBzd5O5nN5jiyo5XGB+CtZcblh
fjCp7le2sieS22dV6Qzq
=M8o9
-----END PGP SIGNATURE-----

--W/+CTqSGWdiRg+8j--
