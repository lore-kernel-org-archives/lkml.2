Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1LFV7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:59:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47832 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1LFV7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:59:38 -0500
Date: Tue, 6 Dec 2011 22:59:36 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wolfgang Denk <wd@denx.de>
Cc: Heiko Schocher <hs@denx.de>, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH] RFC, watchdog: add generic wdt driver API
Message-ID: <20111206215936.GE14154@pengutronix.de>
References: <1322992423-21683-1-git-send-email-hs@denx.de>
 <20111204125928.GB5788@pengutronix.de>
 <20111204170810.8370625EA22@gemini.denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <20111204170810.8370625EA22@gemini.denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wolfgang,

> > right, this additional API needs new drivers for all the watchdogs? Als=
o, I
> > didn't fully get what you are missing from the combination of the curre=
nt API
> > and additional userspace-handling? (check [1] for one example, not real=
ly

=2E..

> But as Heikow wrote; this is a RFC patch, and the main purpose is to
> try to find out if it has a chance to go into mainline - several
> earlier attempts (which go back as far as 2002 - see for example [1],
> [2]) all failed with similar arguments like yours: "It's too complex,
> we already have watchdog support, nobody needs this". Funny enough
> that we have a number of customers who consider the existing wdt
> support unsufficient for their use cases.  We've been using it on all
> kinds on PPC systems, and now on ARM as well.

I never said the features are useless. I also didn't say you should do
everything in userspace. I asked because I wanted to know what exactly are =
the
things you are missing from what is possible today. So, this could maybe be
added to the current watchdog frameworks. Adding a new framework (with lots=
 of
issues) and requiring a new set of drivers won't cut it.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7ekEgACgkQD27XaX1/VRvl4gCgkaILektY1rIYLvMM3LeNgxvc
isQAn041B0xQVn33pYPZgzz3yMdSnuMm
=MSJ0
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
