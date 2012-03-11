Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2CKHny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 03:43:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59493 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2CKHnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 03:43:31 -0400
Date: Sun, 11 Mar 2012 08:43:23 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v5 3/3] USB: ohci-nxp: Support for LPC32xx
Message-ID: <20120311074323.GA30894@pengutronix.de>
References: <1331408166-11607-1-git-send-email-stigge@antcom.de>
 <1331408166-11607-4-git-send-email-stigge@antcom.de>
 <20120310204955.GA14564@pengutronix.de>
 <4F5BD5BE.3000808@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <4F5BD5BE.3000808@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > And while we are at it: Could you also try replacing i2c_write()
> > with i2c_smbus_write_byte_data(isp1301_i2c_client, reg, val)?
>=20
> Interestingly now, replacing i2c_write() calls with
> i2c_smbus_write_byte_data() did _not_ work (hardware initialization
> failure). I guess this is due to the differences between i2c and
> smbus, and the hardware only handles the former correctly?

Did you take into consideration that the smbus-call has (client, reg, val) =
as
arguments while i2c_write has (val, reg), that is you have to swap the
arguments?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9cV5sACgkQD27XaX1/VRuVtACfWDVpFFZ4P/ZZ1NB939LxoWBb
EBEAnAvSMfi4lJPM+6QDUUqxMPbYXV1V
=mfc+
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
