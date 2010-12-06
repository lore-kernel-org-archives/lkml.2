Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0LFNo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:44:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35420 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0LFNo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:44:26 -0500
Date: Mon, 6 Dec 2010 14:44:20 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "kmpark@infradead.org" <kmpark@infradead.org>
Subject: Re: [PATCH v2 1/4]enable background operations for supported eMMC
 card
Message-ID: <20101206134420.GC7320@pengutronix.de>
References: <20101203121338.GB18655@intel.com>
 <201012061328.49738.arnd@arndb.de>
 <5D8008F58939784290FAB48F54975198320B3E49F6@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <5D8008F58939784290FAB48F54975198320B3E49F6@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > These headers don't belong into a submission. If you use git-send-email,
> > they get cut off automatically, otherwise just remove them as you paste
> > the patch into your mail client.
> >
> OK. I will remove them when the next submission.

'git send-email' takes care of a lot of other things, too (e.g. chaining
all following messages to the first one) - strong recommendation :)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkz86LQACgkQD27XaX1/VRt0zgCeM76IzwAq40/++nl75euxP/TN
MWEAn2Rj3VduImZt0SwWUUb8nPhEzAOm
=hiYb
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
