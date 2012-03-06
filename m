Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030444Ab2CFLyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:54:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35005 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030402Ab2CFLyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:54:10 -0500
Date: Tue, 6 Mar 2012 11:54:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v5] sound/soc/lapis: add machine driver for ML7213
 Carrier Board
Message-ID: <20120306115407.GE19635@opensource.wolfsonmicro.com>
References: <1329976011-2251-1-git-send-email-tomoya.rohm@gmail.com>
 <1329976011-2251-3-git-send-email-tomoya.rohm@gmail.com>
 <20120302130509.GF3230@opensource.wolfsonmicro.com>
 <CANKRQnhHo1P0cmxyfUAShTinWMv0B81d8v8f7M6Oj3Yx9807zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
In-Reply-To: <CANKRQnhHo1P0cmxyfUAShTinWMv0B81d8v8f7M6Oj3Yx9807zg@mail.gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 06, 2012 at 02:49:24PM +0900, Tomoya MORINAGA wrote:
> 2012=E5=B9=B43=E6=9C=882=E6=97=A522:05 Mark Brown <broonie@opensource.wol=
fsonmicro.com>:

> > You're also missing a blank line between this and the previous stanza.

> Sorry, I can't understand your saying.

Your file should look like other similar files in the kernel.

> > Use snd_soc_register_card() and a real device.
> OK.
> As a matter of interest, why do you recommend me to use
> snd_soc_register_card() ?

It's been the standard since 2.6.38.

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVfrZAAoJEBus8iNuMP3d410P/imjuxCBTavWKqO6itbwwxt6
lJ0ia1+zV8TriR5At4vdACD5hDr1CbqTL/I/h95G7o8JWvDGlIgmC1Ha1Jlmbtcq
xfywkJt5nggxr51Z73ArvxOsWWewAS15HyFTF2mTrQYlBFQghoj1Tf3Kmk/XDtt0
69zq7rOOSFTjARICscxW1IwGbzIBQGLqF9Nre66QwM+83h35daJ5q+3853T1Tfb2
/WMrpETmZzwEIHnHLj/GBMfG99ZVuepiD8YR8rKMJVYkpPLtrcrWM2+USoSL+Xri
kvolYugnBmvcquHc9z1mqrsCOZnh4sNzqGp/Ngl8fyIcdNSn9mRgQcwx5wF7e4V/
UFwUnIZnkKidRDkiMwr80/A3ExvIz4SH3OR1hYPRZM8S+wHAxdKb+LwsvneYEvHk
BCVOeUJXZLrx6d39nc5wIdHNhywLnsl+lJ8+VJ49a05DtdGpfJauKdah7u3Eju2y
nzLdMp8fqS5NDTPmtvJjtbDN5l+e8LXIO5zpOIx+sQwJSreNIGV29MVkW/IiRCKR
ou6KPPsk/AN6zEkZ01RBeAjNvPNCYSXJxuYyRO4pYQcDRwEVeqOxSYHhIGsDS5Y8
5H4YpDwWVRvbHNAxPq8eXYMKkcaVMuciWgOzKYCVx/MuPhRUZkzdEZHe4UT6Ju4t
PT2KjS+pdYtY41rcrxB7
=dHXw
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
