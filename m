Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0GFPsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:48:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45710 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0GFPsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:48:14 -0400
Date: Tue, 6 Jul 2010 17:48:12 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, Luotao Fu <l.fu@pengutronix.de>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ilya Dryomov <idryomov@gmail.com>
Subject: Re: Problem with tty changes in linux-next
Message-ID: <20100706154812.GA2813@pengutronix.de>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
	Luotao Fu <l.fu@pengutronix.de>, Alan Cox <alan@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>
References: <20100706130403.GD3991@pengutronix.de> <201007061623.48363.arnd@arndb.de> <20100706151454.GB12444@suse.de> <201007061735.02881.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <201007061735.02881.arnd@arndb.de>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:43:57 up 3 days,  6:54, 61 users,  load average: 1.29, 0.72,
	0.78
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 06, 2010 at 05:35:02PM +0200, Arnd Bergmann wrote:
> On Tuesday 06 July 2010 17:14:54 Greg KH wrote:
> > I should get to this today and push it into the next
> > linux-next release.
>=20
> Ok, thanks!
>=20
> On Tuesday 06 July 2010 16:40:52 Ilya Dryomov wrote:
> > I had the same issue. Here is the patch:
> >=20
> > https://patchwork.kernel.org/patch/108700/
>=20
> Yes, that's the one. It would be good to get another confirmation
> from Luotao Fu that this fixes all the problems with missing characters.
> As I mentioned, the boot-time warning will get taken care of by
> a different patch, but can be safely ignored.

I picked up the patch and did a quick test. The console message printing
works so far.

Thanks

Cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwzUDwACgkQkLuxfMCkDTaFjgCfcx9Rk6p6EnFeDJTWs7San2nn
C78AnRax1sF2ZJVL9sRQMKDeRPGZi9Ic
=VE+y
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
