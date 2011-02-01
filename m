Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1BAIBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:01:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32914 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1BAIBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:01:47 -0500
Date: Tue, 1 Feb 2011 09:01:46 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [leds-pca9532] Add gpio capability
Message-ID: <20110201080146.GA27955@pengutronix.de>
References: <0D753D10438DA54287A00B027084269764CEEDA479@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764CEEDA479@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From the datasheet:
[...]
> So, you should provide both a direction_input and direction_output.

He did in V2 of this patch (what made me also download the datasheet ;)).

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1HveoACgkQD27XaX1/VRspcQCeMTEzhksszWpP5wpeAMnrBH8T
ue8AoKv6SE1y6nbvLC9cWKcxt4Lmiq2Q
=VS+E
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
