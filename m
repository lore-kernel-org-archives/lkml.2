Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0DZHlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 03:41:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47888 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab0DZHlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 03:41:50 -0400
Date: Mon, 26 Apr 2010 09:41:36 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Farid Hammane <farid.hammane@gmail.com>, ben-linux@fluff.org,
       Enrik.Berkhan@ge.com, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c-algo-pca: fix coding style issues in
	i2c-algo-pca.c
Message-ID: <20100426074136.GA20663@pengutronix.de>
References: <1271973715-18331-1-git-send-email-farid.hammane@gmail.com> <20100423113326.3691bdd6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20100423113326.3691bdd6@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Geez, that will teach me to review whitespace-fixes while working somewhere
else :( Thanks for the catch!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvVQ7AACgkQD27XaX1/VRtteQCdHEhyQPc5n513HAi8Jgn83xoy
k3cAn3mgJqy0upBPPBFgUhphYgjyh5NM
=bPmH
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
