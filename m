Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2EGB7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:59:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46364 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984Ab2EGB7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:59:51 -0400
Message-ID: <1336355988.8274.263.camel@deadeye>
Subject: Re: [ 23/47] [PATCH] Revert "usb: Fix build error due to dma_mask
 is not at pdev_archdata at ARM"
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chen Peter-B29397 <B29397@freescale.com>,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>
Date: Mon, 07 May 2012 02:59:48 +0100
In-Reply-To: <20120504204246.865253021@linuxfoundation.org>
References: <20120504204246.865253021@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7GefHYFhYKAC+WECPnJx"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7GefHYFhYKAC+WECPnJx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> This reverts commit d39514c14bd941232976b68e2750dc725b90e724 which is
> e90fc3cb087ce5c5f81e814358222cd6d197b5db upstream as it causes oopses on
> some ppc systems.
[...]

Is this needed for 3.2.y as well?

Ben.

--=20
Ben Hutchings
Hoare's Law of Large Problems:
        Inside every large problem is a small problem struggling to get out=
.

--=-7GefHYFhYKAC+WECPnJx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6cslOe/yOyVhhEJAQrQyg/9FwTZX+ZKt1FMDjKqZPQb2qM0a/UsOT2i
tGDhR6NnwD9jizFmmW4Q+gg1mRF49eHMU30Z5tnTfWbuS0DECi943f4NXhZk9VbK
fzu8P397bwE2burqWR2XA4Unp3MXhBWF3UlGH3nJUNkgjs1TZ/IzUweIFb9sVzcv
NZ/KvBWN1RUQERS2e63KoQPvwpORa0RMhseMk3GYrUrQKRZ1nMWUwY2WymH+i4eR
ya8aOQ4G+M5uovkG+mzkQ+3Nj3VW/pgbft3o7q64QOlq7vtNDsnr5vFLJfX0QF+Q
EumXw9QCEQeML6nP69Fr2NhpLzYeqKoe8m6dzf/6okDQlrT6DpA6Y3HfEXe4YjGZ
yf5NFYdeCcBBxouKpgO/g59IHMDhjNOOgl/5jswIFlGhaT3W4Q4unIF1gTfgoixI
hQ4allHFAkcLrKeR3VtrA14o6aluyCXGSXxd8GOnj7fyAaElDKuYsBIpGnSJ2eyV
MXwQw60mOp6C9kxc+cVx4vpZEqVIS6csQEUExUrviFlQAOxce5HxzL1BxO3Sd3fW
P+6HtslVZuUdLxWIaDgIB0NdKFxwwHowafRwDPLiuYdBegZTHbHLeIJF97psp5hN
Y24jNiCeqNjRzzPQWTohpa42W3G7H8Fibq4XWZcd980xFs4tl7GbRJv86ysqzxB0
fOHovjIeFYU=
=PZP8
-----END PGP SIGNATURE-----

--=-7GefHYFhYKAC+WECPnJx--
