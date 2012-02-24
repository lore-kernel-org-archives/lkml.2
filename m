Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2BXGfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:35:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39990 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2BXGf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:35:29 -0500
Date: Fri, 24 Feb 2012 07:35:21 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
Message-ID: <20120224063521.GA16412@pengutronix.de>
References: <1330030639-3796-1-git-send-email-stigge@antcom.de>
 <4F46AA06.30502@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <4F46AA06.30502@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> To get rid of the remaining #ifdefs, I could as well create a new
> ohci-lpc32xx.c instead of abusing ohci-pnx4008.c. Would this be the way
> to go or are there any other suggestions?

If you could tell the difference between pnx4008 and lpc32xx, then you could
simply do something like:

	if (machine_is_pnx4008)
		pnx4008_configure();
	else
		lpc32xx_configure();

or

	if (machine_is_pnx4008)
		pnx4008_(un)set_usb_bits

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9HL6kACgkQD27XaX1/VRu/BQCgxfrgaC8gGw4ABui2sVhUNIqr
83wAnAp2VVI5XUZKDOe64EQnGgyt22JG
=T68s
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
