Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1KPUOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:14:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54970 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1KPUOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:14:53 -0500
Date: Wed, 16 Nov 2011 21:14:42 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 0/5] Generalize module_platform_driver
Message-ID: <20111116201442.GC8843@pengutronix.de>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Content-Disposition: inline
In-Reply-To: <1321434819-23678-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2011 at 10:13:34AM +0100, Lars-Peter Clausen wrote:
> Grant Likely recently introduced the module_platform_driver macro which c=
an be
> used to eliminate a few lines on boilerplate code in platform driver modu=
les.
> The same approach can be used to do the same for other bus type drivers.

Cool, had the same thought when I saw Grant's series back then. Series looks
good to me, so for all patches:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7EGbIACgkQD27XaX1/VRvblgCfREYCxlSSFIl+/BPnzHL8LlHp
7w4An2jLa1lYnfpjuP7zrDKwWlmF3JFL
=gR2n
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
