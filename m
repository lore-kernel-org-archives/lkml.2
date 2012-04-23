Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2DWQ71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:59:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab2DWQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:59:25 -0400
Date: Mon, 23 Apr 2012 18:58:47 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v3 2/2] i2c/of: Automatically populate i2c mux busses
 from device tree data.
Message-ID: <20120423165847.GF27321@pengutronix.de>
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
 <1334265263-13549-3-git-send-email-ddaney.cavm@gmail.com>
 <20120422162008.GA4201@pengutronix.de>
 <4F9587E8.1050702@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bqc0IY4JZZt50bUr"
Content-Disposition: inline
In-Reply-To: <4F9587E8.1050702@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bqc0IY4JZZt50bUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I can send a new patch set with those corrections, or if you prefer,
> you could commit these making the changes yourself.

I'll do it, probably faster for both of us :)

Thanks.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Bqc0IY4JZZt50bUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VikcACgkQD27XaX1/VRthzQCgrsSj0Znag3hwJFNEA9ruNW4x
5cgAnjDMmscysGhSCPJhl8hZaIOEeks4
=4sKg
-----END PGP SIGNATURE-----

--Bqc0IY4JZZt50bUr--
