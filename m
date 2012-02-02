Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2BBQlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 11:41:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57107 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2BBQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 11:41:33 -0500
Date: Thu, 2 Feb 2012 17:41:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: stigge@antcom.de
Cc: bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: LPC32xx: Support for OHCI HCD
Message-ID: <20120202164114.GB3219@pengutronix.de>
References: <1328103028-20547-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1328103028-20547-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 01, 2012 at 02:30:28PM +0100, stigge@antcom.de wrote:
> This patch adds OHCI support to the LPC32xx ARM platform
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Okay, I asked for a patch to test USB, so thanks. It did not work for me,
sadly, so there seems to be more work needed in that area.

Yet, even formally, this patch is not ready for mainline. It touches
various subsystems in one patch (arch, usb), uses too much #ifdef and
also misses important mailing lists (usb).

May I ask if you read Documentation/development-process and/or
Documentation/SubmittingPatches? If not, please do so.

I'd suggest to work in smaller steps. Get LPC32xx build again and fix
the elementary clock issues. Then, get USB to work (for example). Then,
get the network driver accepted (for example). Also consider, that those
drivers have not just been forgotten to be posted. They usually had
issues which need to be fixed before mainlining. So, one task at a time
will help to keep focused, I think.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8qvKoACgkQD27XaX1/VRsr6gCgryZNbU51QPkvqs1a2SwLZqnj
2A4An2Acck3KG7WJbChs9oCN9GiVDwa2
=sjTC
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
