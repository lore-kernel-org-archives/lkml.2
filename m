Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab2FAIsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:48:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35923 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759050Ab2FAIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:48:53 -0400
Date: Fri, 1 Jun 2012 09:48:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
Message-ID: <20120601084850.GJ24139@opensource.wolfsonmicro.com>
References: <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
 <20120530100302.GD9947@opensource.wolfsonmicro.com>
 <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com>
 <20120530121547.GJ9947@opensource.wolfsonmicro.com>
 <4FC63632.4030504@linaro.org>
 <20120530151119.GN9947@opensource.wolfsonmicro.com>
 <4FC63B39.6040905@linaro.org>
 <20120530164152.GP9947@opensource.wolfsonmicro.com>
 <4FC846CC.20801@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AptwxgnoZDC4KQWS"
Content-Disposition: inline
In-Reply-To: <4FC846CC.20801@linaro.org>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AptwxgnoZDC4KQWS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 01, 2012 at 12:36:28PM +0800, Lee Jones wrote:

> This:

> >sdi@80126000 {
> >         vmmc-supply =3D <&ab8500_ldo_aux3_reg>;
> >};

> Is the same as, and will cause no more issues than:

> >static struct regulator_consumer_supply ab8500_vaux3_consumers[] =3D {
> >        REGULATOR_SUPPLY("vmmc", "sdi0"),
> >};

> ... because only nodes which we care about (dictated by compatible
> declaration protections) will be parsed. So different platforms will
> not affect each other.

What makes you say the two are equivalent?  The former is a reference
=66rom a consumer device to a named regulator while the latter is a
reference from a regulator to a named consumer.

--AptwxgnoZDC4KQWS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJPyIHsAAoJEBus8iNuMP3dSMUP9ROXuAbPdNsA/Fte2MqMmaUY
U4LE1vwCQ0WZFwCpL1i34gwqe1Sp/nM2yJ4E0+H9GD3ibLQMJ6kY7NJmjkjLK9Wd
18PnB0oDHQvvFRZA+DvmrPdf1WlIr9X/cBOqzEzIIAVsCk5LzqtBcIqszhFT2LZo
uFTslPH1c5a0AEoVY4LN4FTpzwhpO7Gx1BMTAL3NcO2riia7vWvCUtw2bpQU6/6+
7GHj9W8+2z0FI6KvcGYtRWyjxJ+A8awOtD65V+wlH8w7NeibzNiu/LCnRuSLHIrW
KpVcODbwtBiRJWre+/DYKh6/mFNEE2xnwlNBDTx20ySJi4egO5g0gnJWGaGPLHrc
QFwxK1vwWX7oX5lUveBoAfO3CO1g9ASqanVCeApXHGg6CHzFCxTbrw+RKUOunMC5
v/eM6dd0vbeSh1MvmeY0+5FCQ9NrebXCO/SpZb329Rgtko4De6aRiJSACBc6AL7E
Pmgqeyw5VnktRmf8A/81aBM3K+6BkTONYLFJ/vQCwYd2MNwybFlMdBFXK4ZD/hvp
Y0AdzFkuQxye/NaqEgdZT8gJCkkz18XepqJaCOCHKgFzlA/mle6XEqWd+XjZUupA
ct9yu2fhbmEKqN+K3/KUySNxYzwgsAkTdJIPPkN9zcco7rDJFcg/5Q+YUW76BCsT
767O61sKBd0t7WeJI7Q=
=3M4A
-----END PGP SIGNATURE-----

--AptwxgnoZDC4KQWS--
