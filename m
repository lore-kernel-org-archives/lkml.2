Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0FYJcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 05:32:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38371 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab0FYJco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 05:32:44 -0400
Date: Fri, 25 Jun 2010 11:32:41 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>,
       Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH 5/5 V7] input: STMPE touch controller support
Message-ID: <20100625093240.GB27553@pengutronix.de>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Luotao Fu <l.fu@pengutronix.de>,
	Rabin VINCENT <rabin.vincent@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
References: <20100624162407.GA18899@core.coreip.homeip.net> <1277455071-8572-1-git-send-email-l.fu@pengutronix.de> <20100625091116.GE8546@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <20100625091116.GE8546@core.coreip.homeip.net>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:19:35 up 18 days,  1:47, 30 users,  load average: 12.65, 9.67,
	6.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 25, 2010 at 02:11:16AM -0700, Dmitry Torokhov wrote:
> On Fri, Jun 25, 2010 at 10:37:51AM +0200, Luotao Fu wrote:
> > +
> > +	/*=20
>=20
> Trailing whitespace.
>=20
> > +	 * touch_det sometimes get desasserted or just get stuck. This appears
> > +	 * to be a silicon bug, We still have to clearify this with the
> > +	 * manufacture. As a workaround We release the key anyway if the
> > +	 * touch_det keeps coming in after 4ms, while the FIFO contains no va=
lue
> > +	 * during the whole time.=20
>=20
> Trailing whitespace.
>=20
> > +
> > +static int stmpe_init_hw(struct stmpe_touch *ts)
>=20
> __devinit.
>=20

doh! Note to myself: never forget checkpatch.pl

> Otherwise:
>=20
> 	Acked-by: Dmitry Torokhov <dtor@mail.ru>
>=20

thx

> I assume it will be merged through MFD tree?
>=20

to be very honest: no idea... ;-) Samuel once asked Rabin and me to
merge the stmpe stuffs since I once posted a serie exclusively for
stmpe811, now it's so far done(V8 with white space fixes is coming).
Rabin's patch series also contains input stuffs like keypad etc. I don't
know whether Rabin is going to rebase the serie to merge some other
fixes or one of you (Samuel and you) would prefer the patch serie
"as it is".

Rabin, what do you think?

Cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwkd7gACgkQkLuxfMCkDTazlQCfW2YnS/zEdMvfTEtCgQZhfqTt
sc8AniBmopAOftXWJ4YYq/DHPywzQM+I
=20u/
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
