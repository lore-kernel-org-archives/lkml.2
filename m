Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2GZPOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:14:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49115 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432Ab2GZPOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:14:07 -0400
Date: Thu, 26 Jul 2012 16:14:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120726151404.GP3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-21-git-send-email-lee.jones@linaro.org>
 <20120726115055.GD3099@opensource.wolfsonmicro.com>
 <50114D71.9060700@linaro.org>
 <20120726142825.GK3099@opensource.wolfsonmicro.com>
 <50115BBA.2020400@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3dbUQUznexwzCA76"
Content-Disposition: inline
In-Reply-To: <50115BBA.2020400@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3dbUQUznexwzCA76
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 04:01:14PM +0100, Lee Jones wrote:

> This is the only value which the user can pick an obscure value,
> such as 913, thinking they can pick 913mV. I'm happy to fall-back,
> as long as Ola is too.

Erroring out if they pick an invalid value is fine, I'm more concerned
with the case where no property is supplied at all.

--3dbUQUznexwzCA76
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEV6uAAoJEBus8iNuMP3dM+gP/13c2ISrequPpHfkeVZoONDj
r/7vyXNS6Y5EQR1Rpmk2klygi8I0D6MyNPgrJy82GKKb9YqCWPLJamjCQ6oQQsP6
P4tfTyypfjHsTIcJa//s5GSEhLY/4GcypfsFhmKUGLJPIINVa/+caBiPb1bLWa6P
Pt7TstwhBd7HZMfr4Unohq1NrdDPl+DVBg+ER2Bq/IwaWvkmOAqLwfMecMlDj4h1
eOsUbng7elUA5vQuSXwXYNoXH5fHQZnqLyTuI0QvB2g9Mw866jsEKTZX57u+2lJk
3ziOuMcruT6OENY1kx2ylKT/gmT93QRoqjXCIqCS8zO7iVtVTx2S78gYi2NAsEIN
W/QlNv++Pvgv02ElQEszgNNR8FaYS01yqFaFL3DMwm2xVv1CvOnB5f510/HCAavC
n/BRKElBAQ6z6CUUJyuEXoIHaqnJunboWNKiuxl2YqQpm5QxbxRF9R0UnSPRAkFZ
zPFhI/JKfGoGPD9eUSuQJvoyc0FMWt1vndvjYUJ4VLC6wCbxHtLMiAme9SiY88Ty
d2h4Oq52NZ4dlMUeGAvsRjO3nx3C77VT4ynBUgizkt6K6lAi2IpGklUsKrkBTt1N
2QqE9sNQtqs/v69RhQNnGDLo6Ow2Q4vn0um+EBdWKsrLwUBtDz0eMJ+gQNGVZ9Bw
tgzkGKyOBKnPcFLPWHZa
=UFHr
-----END PGP SIGNATURE-----

--3dbUQUznexwzCA76--
