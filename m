Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131Ab2I2AOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:14:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59986 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758725Ab2I2AOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:14:20 -0400
Message-ID: <1348877643.6858.20.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 064/218] mmc: card: Skip secure erase on MoviNAND; causes
 unrecoverable corruption.
From: Ben Hutchings <ben@decadent.org.uk>
To: Ian Chen <ian.cy.chen@samsung.com>, Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Namjae Jeon <linkinjeon@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 29 Sep 2012 02:14:03 +0200
In-Reply-To: <20120928201508.875615166@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
	 <20120928201508.875615166@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eQ+DTMxkxAw/Y1J1jRgG"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eQ+DTMxkxAw/Y1J1jRgG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 13:14 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Ian Chen <ian.cy.chen@samsung.com>
>=20
> commit 3550ccdb9d8d350e526b809bf3dd92b550a74fe1 upstream.
>=20
> For several MoviNAND eMMC parts, there are known issues with secure
> erase and secure trim.  For these specific MoviNAND devices, we skip
> these operations.
>=20
> Specifically, there is a bug in the eMMC firmware that causes
> unrecoverable corruption when the MMC is erased with MMC_CAP_ERASE
> enabled.
>=20
> References:
>=20
> http://forum.xda-developers.com/showthread.php?t=3D1644364
> https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485=
184813224730/posts/21pTYfTsCkB
>=20
> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Chris Ball <cjb@laptop.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

I think you owe Greg a backport of this to 3.0.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-eQ+DTMxkxAw/Y1J1jRgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGY9S+e/yOyVhhEJAQqRWhAAwv8S+rccjsn6LBZI369X3lqK5xKCpybs
eGBicIH8Cu32aR5N2tO6noGyrElnO+lE0UNSGUK5wwEs6pG+a98S+o+wm4ZgI7QU
EFtZKoPAS23+EVjvAQJMQLNQfuSF9NMti05I3QFL70JF48JZ5qru128g8PuZaKqe
M5jxuyAyqseJWHG1oxxmmg5dznlb2vRZ9IkZAX5EafRVTI0aFlvTUtEOou3I9Dcc
mVpAWTcGH6dDcUv4hDmxrlPhfdJ51O4cxV25LU2otc8VtGlchp7xo4xGNLRl8nLt
8X28wX9qACrVoS9zPEQ7SQn3KXiGLpjk1Tk8/Q5nyJuh0Dogn/TgXo0kCjcrKUv7
b+D0tWo8nCvdejfHGF/V1I/o71Zyw4aDi32YhoUV0hXRv0BQfJdo3HG8xZ0DVQol
w6AM2C87nPglt1oiYIm/+uMZJpv+kS8uaNdVmZ1nWvywG0rNIPfeMGG3iLIgbQEq
MNK/H07pjUYO4W34/w1KthTOlbeCHF1jzPHHaMCVTshVFV+kDAKTYD3y38RQOpY1
dUDLtXedxQHf7bSuJujowkxhG5DFsAYJpBwGa1YZOxUJAp/OVI9zHeUWG6anc1b3
nwbgCNXOUaaBYkSjstGw2tbz2usZuNfEbjhFozkJitrLt699y1oVcbiFjQPH9wh6
QtUXhskMY6s=
=7ZHW
-----END PGP SIGNATURE-----

--=-eQ+DTMxkxAw/Y1J1jRgG--
