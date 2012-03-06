Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030219Ab2CFKAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:00:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50694 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758525Ab2CFKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:00:15 -0500
Date: Tue, 6 Mar 2012 10:00:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20120306100012.GC19635@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <20120229235147.GM8295@opensource.wolfsonmicro.com>
 <CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
 <20120302125819.GE3230@opensource.wolfsonmicro.com>
 <CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 06, 2012 at 12:03:20PM +0900, Tomoya MORINAGA wrote:
> 2012=E5=B9=B43=E6=9C=882=E6=97=A521:58 Mark Brown <broonie@opensource.wol=
fsonmicro.com>:

> >> Let me know why I should  use SND_SOC_REGMAP not _I2C.

> > Have you checked what _I2C and _REGMAP do?

> I've just checked it.
> If SND_SOC_REGMAP is used, it seems there is no processing in it.

This is not the case.

> So, can I delete snd_soc_codec_set_cache_io ?

No.

> > Use module_i2c_driver().

> I understand.

> As a matter of interest, why can I use module_i2c_driver ?

It is best practice.

> There is no ASoC driver uses module_i2c_driver.

This is not the case.  As I have *REPEATEDLY* told you you should be
sumbitting code against current development versions of the subsystem.

> >> +static int ml26124_update_bits(struct snd_soc_codec *codec, unsigned =
short reg,
> >> +                             unsigned int mask, unsigned int value)

> > Why are you open coding this in your driver?  There is no point in
> > replicating subsystem functionality.

> For ML26124 spec, it's necessary.
> Because the codec's register read-address and write-address is not the sa=
me.
> E.G.
> Sampling Rate Register
> R: offset=3D0
> W: offset=3D1

This is not what the above prototype says, the above prototype has only
one register in it.  You need to make this *much* clearer for the
registers it's affecting.

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVeAlAAoJEBus8iNuMP3dVssP/1uborFkcsdWswKgiBb8yHg5
UkMaJbz9lKKxC6t4UC407uYpReHKpkToZJitULrmWeOPTKxZ2eiAOIinKdzNdT5L
KX0Zw30+FaiEnwLzMTB9dnVKR8UdIndpB2i7283bHWnnnaxFNo1jvbMYCRbTVsTT
Tjox/3SfMigPMC6WsZkQe2OD+WNkTr51lcULjA3YwJ/QineOZ4XHpCt9l2QUSgYW
B4BD+taNconB5jjdwnQ1+tiO/JRS0tp/zq6iC+vsLWrB6Q0jz+P6FkFtBYV/iDJK
e5aLNe7xn/OuBXlHcAplMiahCC6DD2VSjAacT2ri0Yo7LEZH4E2AQfO+fzHrQ+Et
V9F+XvqUJASiB6TpzoeqedkjNhKnYz0HGAjHiBWWjeEGzVCCrdbbEHwCkjXn7bWK
1S9pcv3gAgUnyx5yXd7PabmOM1sWZk/9K6IcM8tWiNaWpp9wojAhzZFU/Wayr2Nu
vTerHSCPxlqp+73cbwRRSKvsjUdgsQdwkwzyywhLG7P/SAt8Pog4hpyaq8V+oRRT
ZELFlmpxrqH6Ej3Ky/KW+1HZKXAISfTdQX8iAsPNScyvh4Jc00SYXfXVzUcXTGtl
R84R28rfB1bA+Ze/MCGAQZ0E9gdIq6+hoWniNPVNnc9ESLFhXw9sP8VDqwzTlDYQ
8Wtavpb8/NAH6dlW+2lp
=8OSh
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
