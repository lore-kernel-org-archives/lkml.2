Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2HTOg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:36:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49852 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703Ab2HTOg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:36:56 -0400
Date: Mon, 20 Aug 2012 15:36:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120820143653.GE26991@opensource.wolfsonmicro.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-9-git-send-email-lee.jones@linaro.org>
 <s5h628lu0q9.wl%tiwai@suse.de>
 <20120820113427.GN8450@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Content-Disposition: inline
In-Reply-To: <20120820113427.GN8450@gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 12:34:31PM +0100, Lee Jones wrote:
> From: Lee Jones <lee.jones@linaro.org>
> Date: Fri, 27 Jul 2012 08:50:05 +0100
> Subject: [PATCH 1/1] ASoC: codecs: Enable AB8500 CODEC for Device Tree
>=20
> We continue to allow the AB8500 CODEC to be registered via the AB8500
> Multi Functional Device API, only this time we extract its configuration
> from the Device Tree binary.

Please resend this series with all the acks you've got rather than
mixing incremental updates in like this.  Please also send patches in
the format documented in SubmittingPatches.

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMkt8AAoJEFJkBDiqVpZ489QP/RrUzs5lEhmjgdxHSuJ/dqzO
NHb4br9XQJa12gFNklbOovVh2tEtgoonx2TF3rAtYpvOCMvTNND2xM00cK9lTVvA
5kb8ObjsWNBnXHKePsd4Z6Vth94KIcqZ0E6E0SdJ97zLfd6bLPC4GBQYj89+4IGx
zF40Fp0/Pt5hFLiP5boUEOoXqO1qVACBEcjtdhLy3LNEvz5q+aytbR7x+wR9hhzt
6qIrtPJyrQvUJhqR4B8KjRI5cW3oKdOjtSL4PyfXJHouHXjJdILVVxlA5JcwEzQ1
2icnjmXzKlRjizcSWsi+6bdtQYkIFdBwvKF7wS6f7kaIzBLgApB40edKmBoq6RyS
GwhQ9k8Gq67TCaxeEF83E52tLiDsiKonoLar9jZcv756EI0+bVky5WN4/0DDr23t
pwvJBjm0gH2kSlbBKnTCX/+Tf3k/5vUvDEuD/UcO2aaFr/L2QxFyd4Tx3nSBqC4W
hYxbkqOdNprS+iPkifICN+10uMitd11VPGH9/oW/H7niibE9cJHdBZsZZX09ODb1
KOY/Sr9eIYv32IrQrs0zMSnyZmqX72zLPFqJNZQ9l7OalJvQ6JCCtX9u7vk0q4Lq
p4HEVe/1ZDYI/fnexLzsRruNfW3KVsJ9ekFXSk4XfyxGSUBj4Eos6OEZzJqK9bVs
t7AEWzIchdKZMnjpZG2d
=ssEC
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
