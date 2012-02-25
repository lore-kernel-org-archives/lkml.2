Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2BYDvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:51:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2BYDvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:51:43 -0500
Date: Sat, 25 Feb 2012 04:51:28 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Roland Stigge <stigge@antcom.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
Message-ID: <20120225035128.GA4455@pengutronix.de>
References: <1330030639-3796-1-git-send-email-stigge@antcom.de>
 <4F46AA06.30502@antcom.de>
 <20120224063521.GA16412@pengutronix.de>
 <201202241503.27406.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <201202241503.27406.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I would recomment telling this from the device itself rather than from the
> platform.

Basically yes...

> Unfortunately, the way that ohci handles the abstraction between the
> various implementations is backwards, it would be much easier if the
> main driver was following that model to start with.

=2E.. exactly for that reason I didn't suggest it. Looking at other ohci-so=
urces
(e.g. ohci-omap.c), machine_is_* seems to be the consistent use-case.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9IWsAACgkQD27XaX1/VRsvKQCfTQoSMTE2PahBjBby5s75LZT/
tgIAoImjIROFABH+XZSJi/PPHJIXn9Fw
=ZMer
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
