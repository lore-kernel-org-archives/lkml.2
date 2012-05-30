Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2E3KDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:03:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47202 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955Ab2E3KDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:03:06 -0400
Date: Wed, 30 May 2012 11:03:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
Message-ID: <20120530100302.GD9947@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jL2BoiuKMElzg3CS"
Content-Disposition: inline
In-Reply-To: <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jL2BoiuKMElzg3CS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2012 at 02:58:44PM +0800, Linus Walleij wrote:
> On Wed, May 30, 2012 at 12:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> > + =A0 =A0 =A0 { .name =3D "ab8500_ldo_ana", =A0 =A0 .driver_data =3D (v=
oid *) AB8500_LDO_ANA, },

> So why is the device tree going to use these lowercase names etc?
> I guess there is a rationale...

If we are changing the names then not including the ab8500 bit would
seem more idiomatic - we've already worked out which chip this is by the
time we're looking here.

> Anyway: the name is used in more parts of the file, so please change
> it everywhere if you change it.

It's only used for a few debug prints AFAICT?

--jL2BoiuKMElzg3CS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxfAXAAoJEBus8iNuMP3dsO0P/RlAbanIMdrsmCRa2hpLKglA
lrUKoj9bxy/Os89//9SOKHP2RRdYhO/fJZ7s7QeI1nAmmO8phYLuitNVntTd6n85
Etx4bB92R+03F3u7GaPjjtpOnn00Q0qmynWfjbx+38t0wAW56K3SDxJZFnTHdPbx
ezG9AOg77BuXluTyPLdONE3uMmNOcrY42nfWRV1Pt2PudWk6GYuytW7irbHK+j5x
yOBLx9UbOzDBuk0Zi9hciFcwUf8AVaCLTMLODKX3wNlHBshqRrxNBO5Hd4YJUAEq
XopSSHQWW8IlIPWTYgOVIYZ+LZjTtSx+/iDu/7EY3xJLSu+g/knVbRsSYNF2IKqo
HCook+Xfi3mOPl2Dc/DN1cLiaOS9hTIu5yMzTm13PZf6txj9NSYcn4tL7RsyCbPR
BmwJh7CaYP4kGyHTM/t0n87ybEay8y7D1PVgDQdirLrrE8BXLINor3pcAYSo3UUe
xJ2bPfRIisOnelwoxTbkYTmnxl3ZbT/h16c2rdw9sr2aXcrlaCRXXsH1s4wEFGRA
E2mrj4nmqstfhzxRGwuxSLQqdSsjAmD0Vu/oIDVy5ywpST9AH6i5cgOui8e3AAuE
eZeYVXtnQg5BE6IElpNS7t5pZz1HV71QCbUQGSaVnOHwSGDqefPlTLIr7ftuEmE/
Jvp8B/dpZZ0NeuWCbvW+
=o5xa
-----END PGP SIGNATURE-----

--jL2BoiuKMElzg3CS--
