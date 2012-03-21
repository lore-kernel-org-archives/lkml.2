Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2CULnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:43:11 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:59348 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724Ab2CULnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:43:09 -0400
Date: Wed, 21 Mar 2012 13:42:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: balbi@ti.com, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb gadget: fix a section mismatch when compiling g_ffs
 with CONFIG_USB_FUNCTIONFS_ETH
Message-ID: <20120321114248.GB3092@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
 <1331474926-9237-1-git-send-email-LW@KARO-electronics.de>
 <20120321100402.GL3092@arwen.pp.htv.fi>
 <20329.46902.300917.811262@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7QsOHKuLbhbLTwLB"
Content-Disposition: inline
In-Reply-To: <20329.46902.300917.811262@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7QsOHKuLbhbLTwLB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 21, 2012 at 12:10:46PM +0100, Lothar Wa=DFmann wrote:
> Hi,
>=20
> Felipe Balbi writes:
> > Hi,
> >=20
> > On Sun, Mar 11, 2012 at 03:08:46PM +0100, Lothar Wa=DFmann wrote:
> > > Hi,
> > >=20
> > > please ignore the previous message. I sent the patch out too early.
> > > Here is a revised version.
> > >=20
> > >  commit 28824b18ac4705e876a282a15ea0de8fc957551f:
> > >  |Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
> > >  |Date:   Wed May 5 12:53:13 2010 +0200
> > >  |
> > >  |    USB: gadget: __init and __exit tags removed
> > >  |
> > >  |    __init, __initdata and __exit tags have have been removed from
> > >  |    various files to make it possible for gadgets that do not use
> > >  |    the __init/__exit tags to use those.
> > >  obviously missed (at least) this case leading to a section mismatch =
in
> > >  g_ffs.c when compiling with CONFIG_USB_FUNCTIONFS_ETH enabled.
> > >=20
> > > Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> >=20
> > please send in proper patch format and while at that include any Acks
> > you already got.
> >=20
> What's wrong with the format?
> I used git-format-patch to create it, which should produce a properly
> formatted patch AFAIK.

if I try to apply your patch I will have the below on the commit log.

Hi,

please ignore the previous message. I sent the patch out too early.
Here is a revised version.

--=20
balbi

--7QsOHKuLbhbLTwLB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPab64AAoJEIaOsuA1yqREpwgP/16BrC4844OrZ3tZanQ62mQo
ouKHWbEbY+lV9GR4++jhqkKPxR8zuCe7CGfPx+loHeoacx6Ran0YGVQZcWzOIdim
JNNpwgYNY9hzzETRigwQ/25TCzOH5sLnV82ABc2uhRC1P9B7rCaqyT8l9/naacni
6Z/IdJjRmPeWkA3e7YmAe17KQuwyFgxWa9Y32A1sMgZpVsW+qAep8RbYFNrvcSsh
7PxNQFTXvUt9syJAxDjU0RgNn9e8eLUWz45br7kcqDBjSxBEGkencU4+IxOnDvVu
ZZGAauKwy/+98vhZz+LgZ+QrITYITMH2Xopa3nAQG6EXvdsHSewfCsU7OJZVdrTb
JBakX8hTY/3WNi4Grj3wsHubij1x8QJr+XCkHvYHqdlHa2Wq1pZX2Owa0dKQ5r3w
2c9cS8pESpdwmWp5w+W44EU244s2vf/Uy4z2JhlczSTWADCLrobs4atntmYW8z2q
uE+xfnE0QFfErFEOSTmAXjK9ZN8lgYJOod7bGp5/nmLNh1lpfMBuX2jHx9WM92uM
Z7+G3qkV3UrIKiYtcxZvcng0WEWNrUTTu6ydjhb/xzVlRw7FjALMHUKLOigf4MzW
/Q4rvK7JZ3e2XK8Gz7yyW8HuOh7I9Uk0AhSe9hvLnmuDc4hlRrKDOZR76QTzpf5b
eJBA4fcA66lg5cPCYl4j
=pMha
-----END PGP SIGNATURE-----

--7QsOHKuLbhbLTwLB--
