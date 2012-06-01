Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab2FAOk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:40:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38704 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182Ab2FAOkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:40:25 -0400
Date: Fri, 1 Jun 2012 15:40:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH] ASoC: make snd_soc_dai_link more symmetrical
Message-ID: <20120601144022.GV24139@opensource.wolfsonmicro.com>
References: <1337991731-12149-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O9T4zNOkGnr0n+A/"
Content-Disposition: inline
In-Reply-To: <1337991731-12149-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O9T4zNOkGnr0n+A/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 25, 2012 at 06:22:11PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Prior to this patch, the CPU side of a DAI link was specified using a
> single name. Often, this was the result of calling dev_name() on the
> device providing the DAI, but in the case of a CPU DAI driver that
> provided multiple DAIs, it needed to mix together both the device name
> and some device-relative name, in order to form a single globally unique
> name.

Applied, thanks.

--O9T4zNOkGnr0n+A/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyNRPAAoJEBus8iNuMP3dhPkP/1ozI/cemfZucUDcLeCyI6hw
5gPJoE/Mzz4o0adaWB6wNXR3uNm0pQVS+M+NKqmdfVINQxbo3+G33ZSYwIFPUwZv
+7N/xQhH7wDhGLEQ6XEnw7INRhrwQ6+W4zyM4dnH9pe71AF59A17+C2J0aLVV97a
ianbaBI0PXWmpsvDgN6ustZ2iKd11flekNc0uCdPnUtQvJwNGv8qlyoF8RCG09/B
PIMi1GUCLdYvabt9KSwey1P3GUjuHyBsdsJ4GLTft9fDw6HgLNpI0zmcgxlA8epb
k3Kf7S5762f7oqLIxzPgUmz7TB6IDh/alN8gAzuKCN23EeV824fyqw9n9tGpafA2
H6rgatyTC73jexUBLbuHGETnBo9idQuBg780xEtkhBrTnLj0zqk1Wtd28H9SytmF
HG3WxJqw8Ff453K5f9hMEdxcBvRnCnj9gRC1V/puB6vyxBY1dOJkeyLW82YWwcsb
sElvglv2UM/ABuUupqUnmv+7m0HFXvTKK+YRRUcHbIsYMgKMVBLvR5QyTyLhkvR+
yJJVBo7nsE1reJHHb/lvH3bzRBWK2WKiwm1AfzCWq0BQY6v4wQy4F4SojC17LwU+
av1kmgwSf0kW/TPuSCHQXClC2VWjMnDU7EPRuhWP33Nz6rFlQNpIaH43rwOtLS+f
DDQFclV/kFhqNia0trY5
=Ej9J
-----END PGP SIGNATURE-----

--O9T4zNOkGnr0n+A/--
