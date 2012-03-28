Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2C1IuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:50:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46211 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2C1IuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:50:01 -0400
Date: Wed, 28 Mar 2012 10:49:57 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 12/13] Add a kerneldoc comment to spin_is_locked() that
 discourages its usage
Message-ID: <20120328084957.GB2522@pengutronix.de>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
 <1332895637-32572-13-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <1332895637-32572-13-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> +/**
> + * spin_is_locked() - Check if a spinlock is being held.
> + * @lock: Lock to check.
> + *
> + * This function should normally not be used. Especially using it in
> + * WARN and BUG_ONs is usually incorrect or redundant.
> + * If you want to check if a lock is held in a function
> + * use lockdep_assert_held(). A lot of other usages are racy.
> + */

Maybe add a reference to the section you previously added to spinlock.txt?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9y0LUACgkQD27XaX1/VRs9wQCggrIMFNjOnEaB0CTKBcZFuUI+
ZTgAn0LTHmdNk8dPiepgjmBO20PY1vTG
=IO01
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
