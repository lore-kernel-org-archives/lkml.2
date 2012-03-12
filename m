Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2CLK5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:57:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59933 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab2CLK51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:57:27 -0400
Date: Mon, 12 Mar 2012 10:57:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v12] Regulator: Add Anatop regulator driver
Message-ID: <20120312105719.GD3110@opensource.wolfsonmicro.com>
References: <1331349188-14765-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <1331349188-14765-1-git-send-email-paul.liu@linaro.org>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 10, 2012 at 11:13:08AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>=20
> Anatop is an integrated regulator inside i.MX6 SoC.
> There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
> And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
> This patch adds the Anatop regulator driver.

This looks OK but doesn't apply against current regulator code due to
sorting in Kconfig and Makefile, you should always submit against
current development versions of the subsystem.  Please rebase and
resend, this will also give you an opportunity to build test against the
current subsystem :)

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXdZ/AAoJEBus8iNuMP3dX+oP/2kD3QVL32fXAmS2heBe51em
ppY5uYval6qjf0aw4eC3Or4/Cz1oo3XyiaTdQmiRJAF12Thym5YCggdBjH6uDU86
HbsnCwwR73JKuNr2MHFHxKCNMzBG+XXZmQOW+aKRwmPeyu1KED393Ujpz7zDHs7z
hRtvDcQvPkoe4W6deYKqTOGCC8SCyU8NtITVhQVgF+FSyGYzTNtcUxq4032LqRIO
8HhF75x+FfQXV8Hg4a7aeLkNgT+IrIuQ7jflC472yyw+PB9WlGnTzGBTreVbqB95
3gdhLukbt9g8n1agfZXZHgFYrZMOmSQQUyhUNLMqExpkxnX9b5D9Ri7YMVvOgZyK
I+wDnaFaF0u6j9svI9M8nKJD4vXAQF/cowPk1E4EbLYjQk6AssmP/y2rjXVBPknS
BR6t4myCudQyD5saX831rl0gLvuAnFI606cSWnSUsTui7nCmpwBhZasNRFCvXY+C
VN9DjUNBcXXvr2rPcgWGpKdj+PRJtPT+Ru98Atcvb6OWOyQE379U8Ih0laAL+ji8
ksyp3HjEW0+mV5rNQLdAe6cWDCLCOTXXWEanZUfI623GWua6tUk+LzmochYP8sld
QXyZpu1ghTFxOXFeMy6Ahw0VyMQa3mP6MyuAWRvejDu3UFHD5KxHwJwEv3LUglAW
iHBxTJXXglQL88FZYP0j
=1PBC
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
