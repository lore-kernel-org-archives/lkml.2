Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2KWKvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:51:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2KWKvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:51:41 -0500
Date: Fri, 23 Nov 2012 11:51:10 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: Re: [PATCH v4 05/11] pwm: pwm-tiecap: pinctrl support
Message-ID: <20121123105110.GA6884@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-6-git-send-email-avinashphilip@ti.com>
 <20121122205944.GC16716@avionic-0098.adnet.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9EE991@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9EE991@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fZj+qs6IsnyA2SOk7W7+UiRJ7b9HzE6iWVGakE0QOVH
 UzbEJN2ld4Ulr5IYEDhLmu+4GQmCno+mX16W96UWcSmQam8/Bi
 V6un+p6e/iB/Mpvh/H8Rlh4wsrmgdSyp3R/dEKrJJspI0rK1mK
 xLbnIJoPt8MQUdhHv4gGfDGj3uj6innRDeHijXHTfWShFJE22D
 dXUE1Kk2pnGqFZLYzJFg8iLwQjC7hmpYAzM10ZlUb3/qlquQcF
 xXUuBeARpO5y1fypVaubJHcHGDQoATUPQljzFPBERV4i2TnUTP
 QEcomQBvVP5KWtYSDFk6GXSQia+6cCnsiUWOPRJ+8+WlAgGqwk
 xGpDnzrT3CZG79/vFaUUPwDl6I5lEUh4u8GAoWl3l2wXU5F3q+
 GxJyfaVqLama4AmDYaaVMo0zhDJG9s9rH8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 23, 2012 at 10:34:02AM +0000, Philip, Avinash wrote:
> On Fri, Nov 23, 2012 at 02:29:44, Thierry Reding wrote:
> > On Wed, Nov 21, 2012 at 06:41:02PM +0530, Philip, Avinash wrote:
> > [...]
> > > +	pinctrl =3D devm_pinctrl_get_select_default(&pdev->dev);
> > > +	if (IS_ERR(pinctrl))
> > > +		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
> >=20
> > I think we already discussed this, but shouldn't this be a fatal error?
>=20
> I had checked relevant discussion and found this can be warning message.
> This is because most boards don't have pinctrl implemented at this point,
> or may never have.
>=20
> https://lkml.org/lkml/2012/9/11/369
>=20
> Any way I will change to
> dev_warn(&pdev->dev, "unable to select pin group\n");
> as in other drivers.

But in case pinctrl isn't implemented, shouldn't the implementation of
devm_pinctrl_get_select_default() just be a no-op?

Thierry

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQr1UeAAoJEN0jrNd/PrOhtp0P/3jPxTmRN9ImONWDo9JSKADw
qWlakenC0K01Q+q4bd4kGlwfLEFQqT4OxRTng5/E6UPgNEb1EeMjYltbpLacEN44
lpT859vobtjTAC3hSjJ+M+2uH0LKLflzN2OBXdwKXdr2VHpdrD58KqFSt5pKoTKH
fdyMHdbfGw0gFKDGgh7/4zqj4wOCF1GmjZ+cVGIDRkpCCMW9qXXQ83bE+0CGkx4E
iVPOOLODN/poWkAg4wVOnHU9AVt64IdSuTX+nzKrdZRgsyyw9lHxhJy9WDVli98h
2PXypzzy8yxj01rSPyUoQkt6qfu9hNWIKOLbKmFh7DnSJLrsm8ywqVmWIaJt1Jxv
N8/hfNyGaslUhwk6wQPNFWYFsT5mqeAH7GYMyeHbKgZo8XtoHkDuEUu3C0Zbjx5R
fG/GzbHxACqfBeF6xoWopjczxmrmYwhmGE4Jrc8PDWMEqQtwzhBZQGiBFbGRpVdn
am5s3VN7HfinTPhOjl7wCUv/+cksU3LN4NnU+QOd8V0vA7+Hmcuy0Px5qh6Hr2IV
WyEwA8/+wWndDit1944llxV9FJiAeig4h61X2iYRPmbCok3jyBSfnLtvFC9nmuif
OuijIcQzdhJA9986sPYjVO73lF1l19wShYOVFAdYGjN4TpuXnCxmxh3Vaj4kw9Zx
ZHZPuc1cKGaZlRBHz6ck
=0Z07
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
