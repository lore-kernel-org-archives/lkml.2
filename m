Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1HOV1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:27:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51971 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1HOV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:27:10 -0400
Date: Mon, 15 Aug 2011 23:26:59 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Peter =?iso-8859-15?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] video/atmel_lcdfb: Fix build failure/typo for avr32
 defconfig
Message-ID: <20110815212659.GA18198@pengutronix.de>
References: <1313429190-29275-1-git-send-email-peterhuewe@gmx.de>
 <201108151931.27607.laurent.pinchart@ideasonboard.com>
 <201108151943.08347.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <201108151943.08347.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2011 at 07:43:07PM +0200, Peter H=FCwe wrote:
> Am Montag 15 August 2011, 19:31:27 schrieb Laurent Pinchart:
> > Thanks for the patch. I've already submitted the same patch
> > (https://patchwork.kernel.org/patch/990792/) nearly a month ago to the
> > linux- fbdev mailing list. Paul, can you please pick it up ?
>=20
> Ah okay, didn't see it. I usually look on the lkml if the problem was alr=
eady=20
> fixed lately but somehow missed your patch.
>=20
> Since you've done exactly what my patch did you get my=20
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

This bug was spotted during the review phase, too:

https://patchwork.kernel.org/patch/878382/

Dunno if the wrong patch was picked up or the follow up patch never came ar=
ound.
Doesn't matter:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5JjyMACgkQD27XaX1/VRvG2ACeMJPv7Le8EpjUYxqDtAEJSh6G
N+sAoIi5n0uGTWQTQVTKdfb3f/tN5dn+
=3LSh
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
