Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0LJLqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:46:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39814 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab0LJLqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:46:14 -0500
Date: Fri, 10 Dec 2010 12:46:04 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC][PATCH v2 2/3] spi_bitbang : get nsecs delay from cs
 during transfer
Message-ID: <20101210114604.GB4228@pengutronix.de>
References: <1290205185-11956-1-git-send-email-bengardiner@nanometrics.ca>
 <cover.1291925752.git.bengardiner@nanometrics.ca>
 <67270e44ec792d1a684d6052f7aebbc8c538a6c1.1291925752.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <67270e44ec792d1a684d6052f7aebbc8c538a6c1.1291925752.git.bengardiner@nanometrics.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

thanks for the submission. It has some issues, though:

On Thu, Dec 09, 2010 at 03:34:55PM -0500, Ben Gardiner wrote:

> +		nsecs =3D
> +#if defined(CONFIG_SLOWER_SPI_GPIO)
> +				!cs->nsecs ? cs->nsecs : 100;
> +#else
> +		100;
> +#endif

This coding style is very hard to read and gains nothing for it. Also,
slower_spi should rather be a per-device than a config option.

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0CEvwACgkQD27XaX1/VRsviACgmUcwWV5cqVcKo9X2eeFm1kQ7
NscAoIhABVZW4Pni+8eRsYl9s6fOHnvk
=aO5M
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
