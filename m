Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0CaCQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:16:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56739 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab0CaCQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:16:28 -0400
Date: Wed, 31 Mar 2010 04:16:26 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc3
Message-ID: <20100331021626.GB3520@pengutronix.de>
References: <4BB24E5F.3030703@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <4BB24E5F.3030703@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Remember our old friend? See also
> http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/02769.html and a lo=
ng

There is a patch available:

https://patchwork.kernel.org/patch/87436/
(or https://bugzilla.kernel.org/show_bug.cgi?id=3D15548)

Seems it was jussed missed.

> related discussion at
> http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/02772.html.

The firmware bug should be gone, but there is also

https://patchwork.kernel.org/patch/87359/

pointing out a few more potential issues. I will resend it without the
thermal_sys-part and hope I'll get some comments.

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuysHoACgkQD27XaX1/VRsAUwCfdKkA8JF7NyN90SB+Fy4pQnbw
5fEAn3OAs1xtskqESV3jdq536o1u0xRH
=vzUP
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
