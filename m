Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab2CBM6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 07:58:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49481 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717Ab2CBM6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 07:58:23 -0500
Date: Fri, 2 Mar 2012 12:58:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20120302125819.GE3230@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <20120229235147.GM8295@opensource.wolfsonmicro.com>
 <CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Content-Disposition: inline
In-Reply-To: <CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
X-Cookie: Chicken Little was right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 02, 2012 at 05:16:04PM +0900, Tomoya MORINAGA wrote:
> 2012=E5=B9=B43=E6=9C=881=E6=97=A58:51 Mark Brown <broonie@opensource.wolf=
sonmicro.com>:

> >> +static int ml26124_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
> >> +                               int div_id, int div)
> >> +{
> >> +     struct snd_soc_codec *codec =3D codec_dai->codec;

> >> +     switch (div_id) {
> >> +     case ML26124_MCLK:
> >> +             ml26124_update_bits(codec, ML26124_CLK_CTL,
> >> +                                   BIT(0) | BIT(1), div);
> >> +             break;

> > Why can't the driver calculate this automatically given the MCLK?

> Sorry, I can't understand your saying.
> Why does this driver need to calculate ?
> I think this driver can use "div" value directly.

Why does the user have to set this divider by hand at all?  There's
already a set_sysclk() function, just have the user specify the clock
they're providing.

> >> +     ret =3D snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_I2C);

> > You're mixing regmap API usage and ASoC level I2C, this should be
> > _REGMAP.

> Currently, it seems codec control via i2c works well.
> Let me know why I should  use SND_SOC_REGMAP not _I2C.

Have you checked what _I2C and _REGMAP do?

> >> +static int __init ml26124_modinit(void)
> >> +{
> >> +     int ret;
> >> +
> >> +     ret =3D i2c_add_driver(&ml26124_i2c_driver);
> >> +     if (ret !=3D 0)

> > module_i2c_driver().

> Sorry, I can't understand your saying.

Use module_i2c_driver().

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUMPlAAoJEBus8iNuMP3dheIP/1v4aa8NKQM0Ad9vNHU2ImPP
B1hDPCDC1BXOBHMDL9gx5fbf4aMprIss5fSM6yx9cbvXgQWe7mmUzOrqdXyXj2pW
YhM8wbpT+T6n4X2PYopqd1eBQj2ukfFv7PW+fILZ454wwDgDdfeG/H1kiQOc1MbF
T8YE9Dv+fpPBjAiGQRnF824NPOED8qdERxrBX8rfB001aDrSWTpoqcZu04ETz1d/
oXWAebOAYFE+hDKgepLE3Xa/njbVpRHRH9N7zgxu3sI8x2zdQCjF2dWY9bnBx53A
YW2+U6j9okitJa0PS/8HEAv/lk4ZkgRqrCz1nsCjE7DNoPWPWSwmDUj0LepH915d
xaBbeR9hifQl++pm9WhqE/dg0kNQoz7IhJJsyxR1ZG3uAok0uDalfZXsYoVALL8m
DC8RsIBSxnJaxrqrqyyJnZAjJQgegjYte54t64jqHuE8+vDV6Qy7eWOzJZV5y1kc
AOLDJomEBFSOz8DGSIDc0Omm10R4VSy8YTOW5sOgcMNyW9Umv3OqkDbKyk3F+WBq
Na2XAJ8dj79W6u+RBvu2XjkgYJ6EIX4eZki+xv3h8ru1SRk0Dt7p9IoQ/e5fnWYH
okcG9j49GL0X/di6IbaIO2RI79LDMfPJi3IH1dN+x/A0V+/n7j3WZHiiBokBZr4k
i8tUjdtU1LR1yODGh1ml
=ciYL
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
