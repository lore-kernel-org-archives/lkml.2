Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2KILtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:49:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab2KILtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:49:45 -0500
Date: Fri, 9 Nov 2012 11:49:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RESEND PATCH 1/2] ASoC: Ux500: Fixup use of clocks
Message-ID: <20121109114943.GD23807@opensource.wolfsonmicro.com>
References: <1352302962-25201-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
Content-Disposition: inline
In-Reply-To: <1352302962-25201-1-git-send-email-ulf.hansson@stericsson.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 07, 2012 at 04:42:41PM +0100, Ulf Hansson wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
>=20
> Make sure clocks are being prepared and unprepared as well
> as enabled and disabled.

Both of these patches are already applied...

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnO3FAAoJELSic+t+oim9iAUQAJP3AihLKvHrjpsTijwoxETa
lQk4VrEVa/gqxku7QuZM3CdeTkpWHGRJ5hPiXIL5GPv4pVsqHPv+njbwvzXJjvOM
D/kb9lSOL//jYT/lbgAudZmvEtROL/hFRJ4nPnSSUErhmO/B8m+epceNU10qSroK
gs0G48Eaw1veJ9KXG2aNP22TrM5CMWp8219HyCCjID/AEAgrCaSG6cCB7Plgam3e
ufUAdgYE/KRFvant6UoRBLenGEO+zauIQGb1RqUjJy3X1fxWJyA4mM1lOrpjKJQB
OsGNkzdEGoMZWsCVdT4wUWdr73Sz5Z/R/z1Gc3VGLy+TYvpDcKfcARdovD26VIZk
MjUVHTb1XyrKiR8o76uKtE+aZ+jGn/7zqX4gLVW4+LeqkK67sv27JVrW38z2P4lc
bocwGsiUupJtMdDP3gC9BL4B2uzmAc5MX6gsQCa9sy4Wpo/c0WySKrQwEmzCOv4P
/k2Y/4t4JoTtLuUvxtoHDOIHbhSvHPUc/Pb5B8bCgqAFzyV21rPTyfqDVOZ5Zsza
rlSTkqseMwLN0LI3uPEIvXAricyuUFbLCE8CeBOsc9q41Ng6YhDPWrAZomGVTnsi
V+pt17LQHt/Da/ZU84hrVYfq4JoxIzaiixnQN4aiSPf1SDdTOCR1Z5HO/jUDerRj
QMHQxb8cPWdbHoUtIR8S
=jmRY
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
