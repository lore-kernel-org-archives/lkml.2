Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab2HIByI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 21:54:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52157 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510Ab2HIByG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 21:54:06 -0400
Message-ID: <1344477233.13142.204.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 029/109] batman-adv: fix skb->data assignment
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Quartulli <ordex@autistici.org>,
        Sven Eckelmann <sven@narfation.org>
Date: Thu, 09 Aug 2012 02:53:53 +0100
In-Reply-To: <20120807222045.656376771@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
	 <20120807222045.656376771@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bN4RRhWtJk/NDcIAl8r7"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bN4RRhWtJk/NDcIAl8r7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-07 at 15:34 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Antonio Quartulli <ordex@autistici.org>
>=20
> commit d2b6cc8e460494251442a877fcbc150faa175b4f upstream.
[...]

This was applied to David Miller's net-next, but then also on net as
commit 2c995ff892313009e336ecc8ec3411022f5b1c39 upstream, which you've
already applied as commit a7faba5c5263f9d8a31b3f542a0504552fa80932 in
v3.4.5.

This inserts the assignment a second time, which is harmless but weird.
So please drop it.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-bN4RRhWtJk/NDcIAl8r7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCMYMue/yOyVhhEJAQrl9Q//X6ts+cpi89oym5kWa7a5cY1NyvrwBolG
lVoKbkcyLOfC6CMLJbLI7ngkMn/H4Ng2A7jkJ5SOzUCXZnkgEItoUGksipY+conH
B2B2B6sch8Ffy6TazqghK4OZkFU3efko6Xe8Wx12YM7quysPh0vdIhod3EkfF7a9
Q+6LntOn1IgaywNUlP6seNrVJkwm+/xjK0O0hDsUYoh0xjOLiuG2fCxg0kst/W3l
VdxFQAnPUn34HdDKvpWkCgh0hoCIJ2LA6xRnEMJFi0c5OIpTz9stHXAddxnz3c/L
R5dAn6/AtaifXFsnu16wyx6zgzvFUmKCJiq79YJlFWbgQ730Mpd3jjXEwiItpR24
U8+KlxNowXyLNV2fN1tbKpanEiVST2D3THMvYb29PKTkLHcgjNT08tctk7vGfWD6
tdRLs8Fgj1EbOEHTdoaNIWOcXaflgSmOzOLbG/6vczq2PR6XeGukDkXmuk1ILmhd
lPyH4yg8wx/RrsUqi3yoIBDisD/tq/aqsc+hAUooWy7QJZbW+IZ75ZSTb++giHXT
wkA2DBI2uQGk8WNDjRiE6Ul/4jzJe4WhrqDCDUaFzKmn32fJmF2YXyCf9yWoMl4r
lPzd210rVlLnrPD/5q9bQwQxWiY9bwSSSM/UKRkOUeBUItnT7vJcXLKy9mQDWFyp
gILh3GA/DuA=
=45xf
-----END PGP SIGNATURE-----

--=-bN4RRhWtJk/NDcIAl8r7--
