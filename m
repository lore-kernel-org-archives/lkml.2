Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2KURuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:50:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43655 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2KURuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:50:06 -0500
Date: Wed, 21 Nov 2012 19:42:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Jan Kara <jack@suse.cz>
CC: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Tagging of -stable patches
Message-ID: <20121121174250.GB13262@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121121174445.GE30250@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Content-Disposition: inline
In-Reply-To: <20121121174445.GE30250@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 21, 2012 at 06:44:45PM +0100, Jan Kara wrote:
>   Hello,
>=20
>   I have a question regarding tagging of patches targetted in -stable
> kernels. We have this 'CC: stable@vger.kernel.org # something' tag. Now
> inconvenient thing is that when I create a patch and have such tag in it,
> then git-send-email will mangle the address because of the #. Now even if
> git-send-email started to ignore the part after #, we don't really want

I started a discussion with git mailing list about that, fix coming soon
;-)

> stable@vger.kernel.org to get the patch since it is eligible for -stable
> only after it is merged upstream. So the CC form of the tag seems to be
> kind of inconvenient. Won't it be better to have some different tag?

the stable "robots" know that they should only take a patch once it hits
upstream. Don't worry, just cc stable and let them handle the rest.

cheers

--=20
balbi

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrRKaAAoJEIaOsuA1yqREdrcQAKTxYLPX+l3bzskPn9k2fU2X
r/0xRBtQ6fKQr5H3B8YtXSwJaNEICR12IKNFjuB0ICrUQqY92EN2tZaVduH0ybxY
AntvKL/o/Tb0W62/WQARJeO/NVRUoUltyb7d4XA6L16BzZreLrTvzBLDm9kLTkFh
9L/2o5CZKkVYnIVNvaejGyFei/l3OAXh5fcfUN2LL7sOE1wE5Xhw40l/BEAA5TQE
BI47mWwogp5mdZnVin0xEYrgDtVdyXrWdbEEaJFrinklUTYW8VheII2LlCg9Y1gb
bJkoM9J6GUEG8dFF+1rgqiiCs+s9PHYhqJ7JFdl6FCQ5IZubXkFzKYXuA33E10dx
k54Kj/HoQ7m10agz8WQL3Jw/xjyV8YJWqZuH+xHHbl5BD/tMv4YuAc0eYY7SNvI2
ojsPvcskH7ZetdZH+bTKZMXkdFNTVQVxgVSKW0WuktCw1A7DOat34Sz7xP2GsA1C
haEjzaXZ1GR1tH9Y6NOoqJ0ogXAw67Vj4jOXk36EknNyhmjUmDXEh4YCe6RggK3+
sOHFhbVEGiOvny2FDCpQ4a6b3ukzAZNGntgpRSrBFjbDpEO1AyBH7IZoTuhErri1
wAAMOxt2LSa81vrk3tfizgCs/PyU/y9XFQu9KUOGkPWjvgAXVRpIRdg0PYVY0QhP
U6CrYpV7dBz88bF2eG5Z
=LyAO
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
