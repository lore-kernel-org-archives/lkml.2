Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2IMGyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:54:18 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:34016 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656Ab2IMGyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:54:15 -0400
Message-ID: <1347519249.7471.42.camel@lappyti>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Thu, 13 Sep 2012 09:54:09 +0300
In-Reply-To: <2689722.93BQTh4lSC@percival>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1464760.6eqxJ2IzZ2@percival> <1347517377.7471.23.camel@lappyti>
	 <2689722.93BQTh4lSC@percival>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Z7zQN41Yy4VWSEps7HLu"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Z7zQN41Yy4VWSEps7HLu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
> On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> =20
> > However, I fear these board specific things may be quite a bit anything=
,
> > so it may well be pwm, gpios and regulators are not enough for them. Fo=
r
> > example, there could be an FPGA on the board which requires some
> > configuration to accomplish the task at hand. It could be rather
> > difficult to handle it with a generic power sequence.
>=20
> Right. Note that this framework is supposed to be extended - I would like=
 to=20
> at least add regulator voltage setting, and maybe even support for clocks=
 and=20
> pinmux (but that might be out of place).

Yes, that's one concern of mine... I already can imagine someone
suggesting adding conditionals to the power sequence data. Perhaps also
direct memory read/writes so you can twiddle registers directly. And so
on. Where's the limit what it should contain? Can we soon write full
drivers with the DT data? =3D)

 Tomi


--=-Z7zQN41Yy4VWSEps7HLu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUYMRAAoJEPo9qoy8lh71/G0QAK/iACEID25N+9nv22F94xd8
XJaD08QNPvPVBn6i2ImESx9GyIC0MW38txdKcNLWsoEmxiTTUiHZt9ORH5uihGMZ
0etZRUzuFZKgYLXfpMR57Np+23j55w51vYYjBsmrRooDsWxdcXO6CDTJQEzVctya
SJg4LjH/HznrwMsSbtFsmWEO2RIO9ukM4kHqTCRgYOdVfmRP8il/rpMyTBCneZ2y
qfEHkWIUtwmdDuzOj45c8G0apugUmb0eBGai5xc7PkXng5zfveZZNiBSlt4Z+CQ5
C9+PElyF+6NOEtHV1J0OCz3njOJnGGUjqPpoaP5SSSRKtqdzh5ypmM59O9SWHx08
AIaWBZkbctf21EWyRoLsXKckn2JC9NUR7qCNyOTLbH5wPwXdhA5o6wehuZMOTNk/
AsGpl0W/fL+sxZ9OerIYCZhiLpIO28pA9X1TuUOEsPqFjod1CCgKVrm+xwephZn1
VuRFOAYTYf/OYo2ahcSxZ9+s3q3vkCQMsiqdtFK7TaLE7YdTPDGQBKHfEzSICIeQ
DLvmaldw9MuhwsxF+HAtzdIUlzwtJ2UfIcFNoHY57iYCf8lrfbV2DdwL4f/FCk43
lhEeZryEkqDhnLCEw8LdjkxDY+o+8lcm1uY6YhG6dNtFpeMbbHR24p8SNtAZ0lZu
exN3o8jW2fuTRlnisslK
=deQn
-----END PGP SIGNATURE-----

--=-Z7zQN41Yy4VWSEps7HLu--

