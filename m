Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0LNSIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 13:08:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51793 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0LNSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 13:08:50 -0500
Date: Tue, 14 Dec 2010 19:08:40 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC][PATCH v2 2/3] spi_bitbang : get nsecs delay from cs
 during transfer
Message-ID: <20101214180840.GB4584@pengutronix.de>
References: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca>
 <cover.1291925752.git.bengardiner@nanometrics.ca>
 <67270e44ec792d1a684d6052f7aebbc8c538a6c1.1291925752.git.bengardiner@nanometrics.ca>
 <20101210114604.GB4228@pengutronix.de>
 <AANLkTimdw5crEJTdnObURp_kxqjwFas2RuDMewd=CqEG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <AANLkTimdw5crEJTdnObURp_kxqjwFas2RuDMewd=CqEG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

> I think it is starting to sink-in that a 'slower' spi gpio _driver_ is
> needed. I can think of a couple different ways to make the CS-to-data
> delay assigned to 'nsecs' a per-device feature:
> 1) a flag or 2) a function pointer in struct spi_bitbang. Were you
> thinking of something else entirely?

Nope, just saw (very high-level) that it should be per-device as it
might be feasible to have a fast and a slow bus at the same time. My
advice would be to start coding your favourite solution and check if it
feels right :)

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0HsqgACgkQD27XaX1/VRsi3gCgwvwf8VcK/Hry6eZVPl7uAbbl
x18AoJ52tQVVO9a/yHT2CwLYC116JQbK
=EI/Q
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
