Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2GZUYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:24:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38597 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043Ab2GZUYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:24:33 -0400
Date: Thu, 26 Jul 2012 21:23:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 07/21] ASoC: io: Prevent use of regmap if request fails
Message-ID: <20120726202311.GC4560@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-8-git-send-email-lee.jones@linaro.org>
 <20120726113204.GY3099@opensource.wolfsonmicro.com>
 <50112C29.6020606@linaro.org>
 <20120726114215.GB3099@opensource.wolfsonmicro.com>
 <50115961.6060509@linaro.org>
 <20120726151217.GO3099@opensource.wolfsonmicro.com>
 <501160F5.5050807@linaro.org>
 <20120726152533.GS3099@opensource.wolfsonmicro.com>
 <50116ADF.4050700@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <50116ADF.4050700@linaro.org>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 05:05:51PM +0100, Lee Jones wrote:
> On 26/07/12 16:25, Mark Brown wrote:

> >You're supposed to use it for the data you use to call back into the
> >underlying I/O code.

> I don't understand. What 'data'?

Whatever your I/O layer so desires, the core doesn't care.  It's
generally whatever the lower layer that does your I/O takes to identify
the device.

> Surely if .read and .write are populated in 'struct
> snd_soc_codec_driver', then it should just call back into those?

Yes, and in fact that's what we do!

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEacfAAoJEBus8iNuMP3dEasP/3A3n/FxKTf/QXUrkiPW7T6n
Pgafq7YAXayZ0Xps44bkxTFQ8qfy53a2RiumkngR0FxZO8f1EzY0PdhNaCgMbAmk
EfCzak6zgJLaij+dNehjtyQk4G5JDpYnoTzScYRbs6a+3nsFQj72LSrK5r6MbVPv
jYuCnPZZbjWw4V/BEGDzWRkwO+YK3ofPL+JlSOyu/kpfb/IUpuQWpE7vwR5pSOjr
mjVGmJ/3pL/rgVY4YU+o/D8uUP5Ty/YJ1Qo1rCntWFq3N3wWG66HIT6Izlxy9CPs
hGaDXbKsiwwpmZaSPGzVMrmsnEryefErN3tuaZdGZlk3qyRY4ajcZ5LGr70+L/lE
xIIm04lYv9Xfi8gC/MNhntDU2my08avOeZEtoPraVjwtW6tVxXD4jpIPkmLkjU+4
EF5i8T5KvJpWtYXehJWLZ5VUT4dk+dEkVTB9JaytSnX64Yv5NC5hf2pvBZOTN1s+
f1HduEu/rNwCFbwhnDK89eePqcrXH9G1QPNwn3WES5Z8PsW7FQ587IgVGP5kZ7WD
c371hLhrWto4EPJmNa2K9IqUr3vAKhCu4/13QXaYDze22d6pbPLCFAZEk4vdNodz
oN4ax/8Ha4KjiiwWEjJJu4kl4zR1u8FlMV7YRORo89TetXBYo7k2rYcDWOoxIluY
tdw+U5f1UG3NYirAraHS
=akTz
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
