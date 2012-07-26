Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab2GZPZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:25:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60079 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab2GZPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:25:35 -0400
Date: Thu, 26 Jul 2012 16:25:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 07/21] ASoC: io: Prevent use of regmap if request fails
Message-ID: <20120726152533.GS3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-8-git-send-email-lee.jones@linaro.org>
 <20120726113204.GY3099@opensource.wolfsonmicro.com>
 <50112C29.6020606@linaro.org>
 <20120726114215.GB3099@opensource.wolfsonmicro.com>
 <50115961.6060509@linaro.org>
 <20120726151217.GO3099@opensource.wolfsonmicro.com>
 <501160F5.5050807@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rnz0oC2K6vQ5doJs"
Content-Disposition: inline
In-Reply-To: <501160F5.5050807@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rnz0oC2K6vQ5doJs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 04:23:33PM +0100, Lee Jones wrote:

> What's my 'control data'? It's not used in the original codec patch.

> The old way wants to go:

> snd_soc_update_bits() -> snd_soc_read() -> ab8500_codec_read_reg()

> When then calls back into the abx500.

> So what 'control data' should I be storing in the codec struct?

You're supposed to use it for the data you use to call back into the
underlying I/O code.

--Rnz0oC2K6vQ5doJs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEWFmAAoJEBus8iNuMP3d8QEP/2oL+z1MeWLQSD8YFGzK2Ob7
gWdPOUOmFYfvGHUNK+1cshwG2yqa34MrQy84L6Pcq+NNTmoWz6w+YAfJVjmc6dHH
+dDmUVGl5oKzov7bJPdqNh06F0ChQkiLFFP/Rims/UpX3+3KJKM46jZh1P7DEk7C
TnYZKOgMglFLhYXc71MZVXw18XZ4lCE4bjwS7NntYnTahIJRTW3mz4SLCPL0LLuj
TyPo3BnbdGEtyuEuYgfAnu1hEZbZu125h9SJZ0jGZlWaNpnUYBUWYvYwl3XlK7dZ
CO1alKEuiTNtaE4Khzkq97jn40pncVjzU+bk9l9Tokko1nzJHLXKrhf3bXyS82CU
3U/5JLCrCA8l87YwVml7rTyiklZUALgV3uTn3dEy8iT1zk4tOJUcC7UvSYQil4ca
4zbuSn28zrmHBBTnmuGjVYHjDuKF0orDzB4E/kpsJ45qr5SWqsOgI4mn0TkXPaRO
nvMg0yTxKy/ElZ/J+qqLSLW/+if5xnqVYycx2muCtZz/PR9mCCV7qb+JXnXQhYb+
57uF+ozUM6y83sSem/KBqS46diXQAXmXbNMSB0dYqJzTuSpP4p7AylUNRGVkTaRb
9D7S0rGTo8+U4wtI4gdJxMmDf5ZngVPN3gA4w5E0PY5weyvk3YitD2va/pykieli
9DC97Z96jBV1vOyR0mVW
=4sRm
-----END PGP SIGNATURE-----

--Rnz0oC2K6vQ5doJs--
