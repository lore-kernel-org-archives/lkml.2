Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1GEWkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:40:18 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43298 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab1GEWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:40:16 -0400
Date: Wed, 6 Jul 2011 01:40:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 2/5] input: twl6040-vibra: Do not use wrapper for irq
 request
Message-ID: <20110705224009.GC8023@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
 <1309895376-17446-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <1309895376-17446-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 05, 2011 at 10:49:33PM +0300, Peter Ujfalusi wrote:
> The twl6040_request_irq/free_irq inline functions are going
> to be removed, so replace them with direct calls.
> The irq number is provided by the core driver via resource.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE5LJAAoJEAv8Txj19kN1UEIH/RUaW100IFCoN5HnoX1R84Fj
irUiOoDqFnorhe2wB9kFqt5REwyC9Ql5x1WxDFgzo114u5rNoMwdyoomRzm+d7kU
HNQF8RO1WqS5zHX4vSnSQ+8U9z/HlJGJ1oaBukU9gzR0LT6+bgCf4ZkVERW1txmz
+d97m8OiM6DyW/jCDSlz5kiHq8AekVcWFAgsDZ5VfXFWqOEHzjEQF3J3/ngbRFEE
T7sJEMlq2IDi606j2ztW4JwdLSK+DooRZb39YFdaPEJDbFShsCdApPScRYMBT/n9
TtcUrdc5MCZBYwNKr4uwGcQwKLjoDCrfA9VZoJMD/zQs/Mjpod2SMuMjSkI4ya0=
=NgIz
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
