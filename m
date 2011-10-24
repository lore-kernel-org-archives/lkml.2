Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1JXVZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:25:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55853 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab1JXVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:25:02 -0400
Date: Mon, 24 Oct 2011 23:24:55 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Roland Kletzing <devzero@web.de>, adrian.hunter@intel.com,
        linux-mtd@lists.infradead.org, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] Re: mtd_stresstest module bricked my dockstar
Message-ID: <20111024212455.GC6326@pengutronix.de>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
 <20111024055705.GA4020@1wt.eu>
 <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
 <20111024195313.GA6326@pengutronix.de>
 <1319490276.12314.9.camel@golum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <1319490276.12314.9.camel@golum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Yes, we should use -1 as the default value, and print a scary warning
> message when the module is inserted without a parameter. We should
> probably also put word "destructive" or something like this to the
> module description.

I would volunteer to do this tomorrow if nobody is working on it at this
moment...

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6l16cACgkQD27XaX1/VRt5RACgwMdTUyiafJ2KB96FbuJqx6Tg
jJ8An2I0PmTHJyPzYfxknWjBhgroCuDU
=B87k
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
