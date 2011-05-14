Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab1ENVAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 17:00:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52738 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754794Ab1ENVAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 17:00:17 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Apollon Oikonomopoulos <apoikos@gmail.com>, chronidev@gmail.com
In-Reply-To: <20110514204536.GA16496@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	 <20110428183434.GG30645@1wt.eu> <20110429100200.GB23293@pcnci.linuxbox.cz>
	 <20110430093605.GA10529@1wt.eu> <20110430173905.GA25641@tty.gr>
	 <20110430201436.GF10529@1wt.eu> <20110514190423.GA2264@nik-comp.lan>
	 <20110514204536.GA16496@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-o/Id6A680A5jTXD8JWg4"
Date: Sat, 14 May 2011 21:59:53 +0100
Message-ID: <1305406793.4065.466.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: 2.6.32.21 - uptime related crashes?
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o/Id6A680A5jTXD8JWg4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-05-14 at 22:45 +0200, Willy Tarreau wrote:
> Hi,
>=20
> On Sat, May 14, 2011 at 09:04:23PM +0200, Nikola Ciprich wrote:
> > Hello gentlemans,
> > Nicolas, thanks for further report, it contradicts my theory that probl=
em occured somewhere during 2.6.32.16.
>=20
> Well, I'd like to be sure what kernel we're talking about. Nicolas said
> "2.6.32.8 Debian Kernel", but I suspect it's "2.6.32-8something" instead.
> Nicolas, could you please report the exact version as indicated by "uname=
 -a" ?
[...]

Actually you need to use 'cat /proc/version' (or dpkg) to get the full
version.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-o/Id6A680A5jTXD8JWg4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATc7tQ+e/yOyVhhEJAQrJdA/+JHRru6s3el6/Bwa0TabO0PRxs8koKu/o
rSdfiq1LqL++E4YMdBfcsDgZZ1301ZcZ6Kom158dC6woXLo/NFvc/T+NQ1HJOrTm
dbmHZ9b9z38Qk9BLzBHBxDUafZzOPFftwmqYHE0HpdXmmDlIpWuN9ucmtA6cLVTW
COpV5qC3RZViXPoEMajzpemLB2ympsegJKJZv+F7OBU07iypBjGt7EDT+XO4qhFm
YNFq8/Z5duboMGNPh1IORsCqVl2YRZn8WeuK613zED0UFutR4Xo2UsrkGFsmyu2A
xFqvtRylflM4jkNTWJl5W22Ra7E3GNmym/Vf0IQwuioptpQuw/Y63KXHy01Oiapg
gUs2FLwArR/b70Y/no3aBNtjKPqs6BsPdccNGATD6ZCA8MQ8tFC6SyYWl1drofPD
QNKcezosK6AY58FQJ0/ciQQ6TqMv4S/NnVxjb4DmCb61eBbOgBoBnghTMNi9U1T7
127GJLYIXHv6OOLH+ZNBF/FPlqB0niGWr6WWifotKCY7lxpZLHnW3VBiyfPXAGvA
FPSDUDbrHUHpC8Dj8e/3JWXm7Mg5206STZ+86g52j8nkKPlXbfZKm8Z5XjBBfuw1
X6Xm8SLph+cibEXj7zDhcnbVuPDRBMMQGsz9d4noPuZfuEkBSEFq4xV4zLvYd7h0
jP1IZ/5Q2Hg=
=Qaux
-----END PGP SIGNATURE-----

--=-o/Id6A680A5jTXD8JWg4--
