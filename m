Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab1K2FRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 00:17:07 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38550 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1K2FRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 00:17:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v2 7/7] ASoC: SigmaDSP: Add regmap support
Date: Tue, 29 Nov 2011 00:17:03 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com
References: <1322469860-8210-1-git-send-email-lars@metafoo.de> <1322469860-8210-7-git-send-email-lars@metafoo.de>
In-Reply-To: <1322469860-8210-7-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2450757.PcOoelOeIC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111290017.05980.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2450757.PcOoelOeIC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 28 November 2011 03:44:20 Lars-Peter Clausen wrote:
> --- a/sound/soc/codecs/sigmadsp.h
> +++ b/sound/soc/codecs/sigmadsp.h
>=20
>  extern int process_sigma_firmware(struct i2c_client *client, const char
> *name);
> +extern int process_sigma_firmware_regmap(struct device *dev,
> +		struct regmap *regmap, const char *name);

having the deprecated name be renamed and the "_regmap" one not have that=20
suffix, but eh

Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike

--nextPart2450757.PcOoelOeIC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJO1GrRAAoJEEFjO5/oN/WB9mwP/ixAQTOh6m/tNsdhXD8A0SbR
ZWTpmMZ/bpr9BnCtWP08lDjoVkZ8KHSvY4/wsJqejKmP+FX2Db2SSatv81U+xVXI
Q8vZ4Jg5aTvNgeW5yGZtwkKcf2B09lazOVmi9CQR+xWRI+jfZ5lSc1R3Wcg3WX4b
pUXOhrU8nmeJTAWHyj6937sjp09V8cqWQ40FAE1T18fdFJM+urdbWkDfokOYuMdq
QeAYXloD6C6PG+150CHV986kUwSsm19ilGPSHdGhH/HBGgMsaH7wpC4YQpwC+0VI
YNNOQkzhlxf/SoHJtzpjLEHi2tz6pNI9EqfkmnswGWznGjvIlyzSVCZQO8NYkQTi
R1Zejxi3BYeQavtEXNFeUhDzwd6Kj8O7g46HoVhemhsReiy3msDRlnoMexnLBglM
DBN56ewMWijh2ohO3p9uraPGKcW9yRHF8068wGeU3P+UXqdK0mQA66opcLv/+fw/
NLkte1F3n993fKg8uhFNnvUrkmf4cx8YHbOzalf1HxqXdRDbePptYKnuvmpTHWcA
z9TEmKGRy3Ih82MOjSXg0vlL6GcPCg4dLttVYx7TfyLs6qu9azcFW4EWLjtTHVQD
F+bWiIo9XGUmUdJWdtw6behelQIFsv8TKcU5X1ReZ5GwM05Z8l9XAFoYegs4h8Lf
06GnUVYBf2s4u+6Ca25l
=EFXo
-----END PGP SIGNATURE-----

--nextPart2450757.PcOoelOeIC--
