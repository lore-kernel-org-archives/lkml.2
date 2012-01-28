Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2A1WTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 17:19:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56766 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab2A1WTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 17:19:50 -0500
Date: Sat, 28 Jan 2012 23:19:45 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Lars-Peter Clausen <lars@metafoo.de>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3] watchdog: Convert jz4740_wdt driver to watchdog core
Message-ID: <20120128221945.GA26708@pengutronix.de>
References: <1327572645.25187.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <1327572645.25187.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 26, 2012 at 06:10:45PM +0800, Axel Lin wrote:
> This patch converts jz4740_wdt driver to use watchdog core APIs.
> Also use devm_* APIs to save a few error handling code.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Paul Cercueil <paul@crapouillou.net>
> ---
> v3: - Remove unused define for WDT_IN_USE and WDT_OK_TO_CLOSE
>     - Remove mem from struct jz4740_wdt_drvdata
>=20
> v2: Address all the comments by Wolfram.
>     - Remove unneed header file inclusion
>     - Drop 'heartbeat' usage in jz4740_wdt_set_heartbeat and jz4740_wdt_s=
tart
>     - Init wdt_dev->timeout in probe using the global 'heartbeat'
>     - Remove unneed pointer check for drvdata->mem

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

Thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8kdIEACgkQD27XaX1/VRuEywCgqTkg+NLKNHHQr91+CewzPc2M
e5sAmwVGPCFxOnwifMcMZgcfurdyWS/e
=8cNi
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
