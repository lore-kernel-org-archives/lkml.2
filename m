Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935101Ab2JYRz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:55:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49968 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934768Ab2JYRz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:55:57 -0400
Date: Thu, 25 Oct 2012 18:55:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        festevam@gmail.com
Subject: Re: [PATCH] regmap: Fix printing of size_t variable
Message-ID: <20121025175547.GT18814@opensource.wolfsonmicro.com>
References: <1351181238-25568-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/7+LvQqw8N5lf/3J"
Content-Disposition: inline
In-Reply-To: <1351181238-25568-1-git-send-email-fabio.estevam@freescale.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/7+LvQqw8N5lf/3J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 02:07:18PM -0200, Fabio Estevam wrote:
> val_bytes is of 'size_t', so it should be printed as '%zu'.
>=20
> Fixes the following build warning on x86:
>=20
> drivers/base/regmap/regmap.c:872:4: warning: format '%d' expects argument=
 of type 'int', but argument 5 has type 'size_t' [-Wformat]
>=20
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied, thanks.

--/7+LvQqw8N5lf/3J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiX0HAAoJELSic+t+oim9/VoP/RLRSo9MXZlD2v1yAcAM3CfN
z4TaBv5ZsyxsrkSO8ndvjdLpnTOf+Vlbt9azu4k8I+hxIvZzUn/TnDRxMrA7ZoJS
APMk7jjOh8nAaAYJFMr0gqVCW63atVGFsc7YGN3PoDVJXprYL1hWMgmZgfUqJcfR
T4oNKpt1FqZe3LwcjNnXo0ddwkbSack+9DqZrR1eT50I9sNCqp+SMfTCCNWITbsO
tFKgyAiEY/nLTyWyCOz4ysBF0Onla3SszauIJmlf1hfgRo99fYLMKHoMsBjOk0eg
9sPKWI94sp1xRKLUaJyzVCvvdQcnaGSiJ9ng7W0om5ltbB8vPZQPm5UzFzcODMkg
ei5JHs5NqR+0QciYta7cajMyF18RbkamSh+ht6Vy8bdDOZeCKIrRtDC6OfzczhUH
xLkoTrYNylk+zGlGQuTlv0SfHQbZwxhX5ag9m6qUWlbT3mxdQ37bM+6juEWmamPk
LSK341wR6gI7X57jg0VQ9nXzCMa7s1aC14OPmUPA03q1yTTqPCIys7/Olmmzl9jB
eR7GG4ZOET/xjAAa35Md07x5L0Jd3Wz86vGgrZFpIqtmhKrrgBXukknTYMEgWP1i
7OBxxYmx9aPuLaw+G9AnGYaYe61bS9P6nppagIZrvPRzw4gkCBUhf3FpoDHTNtfn
096vHdlrUWZ2TZD8NvBl
=KYan
-----END PGP SIGNATURE-----

--/7+LvQqw8N5lf/3J--
