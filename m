Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0KXXf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:35:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35776 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab0KXXf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:35:58 -0500
Date: Thu, 25 Nov 2010 10:35:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, mark.a.allyn@intel.com,
        jayant.mangalampalli@intel.com, Greg KH <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: boot failure in sep driver
Message-Id: <20101125103550.7d30b643.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTin6ZJr3vXw=HVeA65aq39qxtnJGGXW2nwfp_PwS@mail.gmail.com>
References: <AANLkTin6ZJr3vXw=HVeA65aq39qxtnJGGXW2nwfp_PwS@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Nov_2010_10_35_50_+1100_1S6J+v/xw6_irPXn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Nov_2010_10_35_50_+1100_1S6J+v/xw6_irPXn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Nov 2010 15:49:57 +0100 Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
>
> just fall into the same pitfall... While digging into this driver, I
> saw a typo in:
>=20
> [ drivers/staging/sep/Kconfig ]
>=20
> config DX_SEP
>         tristate "Discretix SEP driver"
>         depends on PCI
>         default y
          ^^^^^^^^^
Of course, this is not helping ... as Linus says "Your driver is not that
important".

>         help
>           Discretix SEP driver; used for the security processor subsystem
>           on bard the Intel Mobile Internet Device.
>=20
>           The driver's name is sep_driver.
>=20
>           If unsure, select N.

It even suggests not selecting it ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Nov_2010_10_35_50_+1100_1S6J+v/xw6_irPXn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM7aFWAAoJEDMEi1NhKgbsxXEH/jAbIwb4Teke/RgLhqv2q/lg
1gr+v+H/KvsC3Bl9UScAiyAs+8tBt6WbcgLrmSXiH8rKuQUaOeusWS5pkJo0UjNW
PDyn5VlnbkPN7pfxrOFvZoJxonzcSRncfrI4G7/4JnxohNqTwYJgmV4ZTbsDauVZ
rX0YsVJsM53d8RKfniaCiWfDh33+gOcKpResT0N56hZ2iBr37CAiGlv+4OX+aqAu
KgmzDIKsVi8bTlHD2TMmWlUWVocdLRioq4EEPKYQ9oDtU+OSP9e/tkEqYpKwTKYh
6mPFDEcgzXkr6vlOgkooZDZi6EP1460CSXz4f0YPK0Izt6Nd7WYqXBIsSJ7k178=
=gNI9
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Nov_2010_10_35_50_+1100_1S6J+v/xw6_irPXn--
