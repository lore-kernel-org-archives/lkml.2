Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab2JWKJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:09:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39048 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab2JWKJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:09:20 -0400
Date: Tue, 23 Oct 2012 13:03:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Benoit Cousson <b-cousson@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023100333.GA24418@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <CACRpkdaQ1WfRWrx=RXMVkeFtwdERJsOpVa3DaXBTU2KZdgqhRQ@mail.gmail.com>
 <508664CA.7000601@ti.com>
 <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <CACRpkdbhCS-Vb0DtbTZQ_Zw_8SOh3Bqutme3Y2-QrxNqvMiNNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 23, 2012 at 12:04:01PM +0200, Linus Walleij wrote:
> On Tue, Oct 23, 2012 at 11:35 AM, Benoit Cousson <b-cousson@ti.com> wrote:
> > On 10/23/2012 11:13 AM, Linus Walleij wrote:
>=20
> >> So Sourav, please tell us a bit about your plans for this
> >> and other drivers!
> >
> > Yeah, this idea is to handle pinctrl from all the drivers, and
> > potentially change the mode during suspend when it is relevant.
>=20
> I'm leaning toward the same approach for ux500.
>=20
> But it appears that shmobile prefer to get all resources using
> bus notifiers.
>=20
> So we need to form some kind of consensus ... or live with
> the fact that different systems do it different ways. Which will
> explode the day we need to use a driver on two systems,
> each using the other approach :-)

I much prefer having drivers explicitly manage all their resources,
which would mean that pinctrl calls need to be done on probe() and, if
necessary, during suspend()/resume().

Using bus notifiers for that is quite a hack IMHO.

--=20
balbi

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhmt1AAoJEIaOsuA1yqREUQ0P/iEM86b8Y65gF81tcdU42jci
7p+yTFj8M5jnWrobi4K/+rVtHPpO/kth4wlKWHP1EIPl2JsBA5NpJTm9TemO9mrG
PZXMILRMW88pCCclkYHWlPVj5CAc1F/MpI0OBMvzZ+xMy+gka3ZeTPFxON670uRQ
4pcOfCT41SdWXSztEi8/opw5VJf0BR2DiR/L/O77CmgsouFjyJ5jFK+bDBASeby4
2xxDHJt8t5eJDcCuWC1P9banJD8nTMYFtuvNb9DyFqe4kZ7C+GoRpBHB2YrTjXFX
jvYqehSWdQEG/1lhNfIAGZqdBKkpI47DOHdBDIsv/vUgPYXckIttoW8A6XQ+kP/Q
e6Q1WXZ6EzR2KBOpexzzh/z87IrxHAEZAPonZmbs62R+O8kbcMPDrcSPlbWjEMTi
r1zAJO5XUBoVCmdxmIOExf0j/cY6mM4azyAaEV1LTSowoFIxXX61YcnZUFHNu3HR
mS6Q6JkmEymnp6pBNaQlG5j3Mfj08+7+p3yMYSXC0tojncRCZzRXAGZh8jWSg56R
dIVleAjqBfeLV+VEVVzv1ySV7a4Jb4Ww4OGxG1+jBWURe5qcaCv3KWWT27DxPBRO
1qV6HsOmzBK5ELy715zArQ+ZlMRlbbQUHoHSTNQ/s2nWN5iLtG6tiGXyP229QQMl
vF558Rl905IlePS8CaXt
=xAkO
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
