Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2GIJso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:48:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2GIJsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:48:41 -0400
Date: Mon, 9 Jul 2012 11:48:21 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH V3 0/3] i2c-nomadik changes
Message-ID: <20120709094821.GB1296@pengutronix.de>
References: <cover.1339447570.git.rubini@gnudd.com>
 <CACRpkdakDBrF+G9wpPn+PQ5tcb2xqeiBoSRMmj_PuB_WhufaaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <CACRpkdakDBrF+G9wpPn+PQ5tcb2xqeiBoSRMmj_PuB_WhufaaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 11, 2012 at 11:37:15PM +0200, Linus Walleij wrote:
> On Mon, Jun 11, 2012 at 10:56 PM, Alessandro Rubini <rubini@gnudd.com> wr=
ote:
>=20
> > V3:
> > =A0 =A0 =A0 =A0- fixed according to Linusw feedback (merged the patch h=
e posted)
> > =A0 =A0 =A0 =A0- added Tested-by: Linusw on his permission
>=20
> I'm happy with this version, Wolfram if it looks OK to you,
> can you please merge this into the I2C tree?

Done now, thanks.

Is the latest version of Lee's patches for DT sent on 20/06 suitable to
go on top of that?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/6qOUACgkQD27XaX1/VRtTWQCgsHsNf254ujlFk20vSpgWXto9
c3UAnivCKkol+mZVUb7qpOONjxaA6fyb
=hYOt
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
