Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab1F1KhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:37:00 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:37849 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756928Ab1F1KgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:36:03 -0400
Date: Tue, 28 Jun 2011 13:35:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Message-ID: <20110628103549.GG2612@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/GPgYEyhnw15BExa"
Content-Disposition: inline
In-Reply-To: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/GPgYEyhnw15BExa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 28, 2011 at 01:35:27PM +0200, Nicolas Ferre wrote:
> Add this Kconfig variable to ease the submission of this chip support.
> As this chip/board inclusion is dealayed due to deep consolidation of
> arm/mach-at91 sources, we include this dummy configuration variable to al=
low
> submission of SAM9x5 related drivers in other subsystems.

Why are the drivers even depending on this ? They should be portable
enough. Can you share a few drivers so we have a look ?

IMHO, the whole idea of the consolidation is beyond arch/arm, drivers
should be affected too.

--=20
balbi

--/GPgYEyhnw15BExa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCa6FAAoJEAv8Txj19kN1p6IIAIJV5YF0H5P+ijbXXniH+EMh
yLd7PrGMwIHPIfVdIOyuZ5ko+EXbx8TumnW2C5HbptR3aWtwO9ibdWlxqcSyUZ2X
xL5VQJA1EpkkzGtGEvvtdpRgZnE7A/F4HQ1yI4exXE4tlIlBfVTDWNmnEq2WK9pf
Y0pD9vlU9ZwxiQeNGnPtRkI92wTqOCbJOHFy1gxDEce20l5ELJdgsUN/6UbfESvb
GtxgheNgAF6lU5StmoL15GR2b9TE9ODNIoxO+0rCMlYDEWJxJTPgebOpQGQSLVZh
cFTkQoGTVUoJyqcWgQuG9PJREs2KAoH60mLOkPVqliuV9sbiLTULh4StmlqPwYE=
=oplL
-----END PGP SIGNATURE-----

--/GPgYEyhnw15BExa--
