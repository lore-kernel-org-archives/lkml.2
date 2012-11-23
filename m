Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2KWOhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:37:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33259 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab2KWOhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:37:15 -0500
Date: Fri, 23 Nov 2012 23:37:11 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, patches@linaro.org
Subject: Re: [PATCH 00/10] ASoC: codec: devm_ related modifications
Message-ID: <20121123143710.GQ4529@opensource.wolfsonmicro.com>
References: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Kq+wHeKEs1nwG7z"
Content-Disposition: inline
In-Reply-To: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Kq+wHeKEs1nwG7z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2012 at 09:38:32AM +0530, Tushar Behera wrote:
> This patchset includes devm_ related modifications for sound codecs.
>=20
> First 2 patches fix warning for freeing of devm_ allocated data.
> The next patch introduces usage of devm_kzalloc() in wm8995 codec.
> Following 7 patches introduce usage of devm_regmap_init_xxx() in
> remaining codecs.

Applied all, thanks.  If you're doing stuff like this it's helpful to
sort by part.

--4Kq+wHeKEs1nwG7z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr4oJAAoJELSic+t+oim9aycP/Rc/Rd3uwDIqj4wuVthV05Wi
37V6bBMOCDC5ZaisJUbcm8aOqXz6sEz3whtFOSk9Uk2PuzvH/r5EQF3V24APe7U+
P0shfslU+Z7bnYQFOI3ghvqe4gN//INuy+teEVJNUVFFCqggT4kNGPZyWidreHvg
oCOwFKB5kIPLvpuWis2AD1RhrJDBPmSlINT8SxlSnQ0k368tS1XndroNF/MvKwEW
PONLRADpfQuzYFVIocul0d30Q0u0QITMVuRa5DCMPQN/7PzqjDHaXPwY6pc8TULy
c5hPV8dJ5XE2s4Zqw+g9Tyn4L767KpUgG0rrD86wN4FHe/ynd83+6lirhRovVRSU
IwQ70zwYiVX4Pqr8xLeVWEDIWmUq37ZYnkl9aOHfIeBEm7CTOh9/7LyDI56XOh+s
AS6EHBiN+Lk85+biP+uNvE2oNQnINF3y3Al9eD05bIDxmbwL1mIhlJ+EQ/CM6I1P
DaWT1KtqJmyO3hZ4lEfXhVSWrcLzK6Q5A/Wbz6nMQAvnWKscb6rMHxsxXJkZkQE7
yEl5D2qq6cSBoiyOOeUetq+K9jJFTJZsVOtBdbUufGnnVSvTeydJDWU4IQ1M9o2j
IhHH6tRH+oMH3yI985Ly0Dh0VWORe2C/QAoKMgDNFnNy9F2I9P3B7PcSQHys3t1U
9rtZYcvrZVkqob9kmWbY
=GHVv
-----END PGP SIGNATURE-----

--4Kq+wHeKEs1nwG7z--
