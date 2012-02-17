Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2BQDlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:41:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49900 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab2BQDli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:41:38 -0500
Message-ID: <1329450094.3258.34.camel@deadeye>
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
From: Ben Hutchings <ben@decadent.org.uk>
To: Divy Le Ray <divy@chelsio.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 17 Feb 2012 03:41:34 +0000
In-Reply-To: <4F3CADB7.1030802@chelsio.com>
References: <4F35DB79.6070104@chelsio.com>
	 <20120211140701.GA5194@neilslaptop.think-freely.org>
	 <4F38A526.70900@chelsio.com> <4F3CADB7.1030802@chelsio.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LokhhtfyEjgUXYscDoIO"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LokhhtfyEjgUXYscDoIO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-15 at 23:18 -0800, Divy Le Ray wrote:
[...]
> The following changes since commit 38118a598df73d5a9fd72bf04910e8298db82a=
46:
>=20
>    linux-firmware: brcm: add firmware for bcm43236 usb device=20
> (2012-02-11 19:20:10 +0000)
>=20
> are available in the git repository at:
>    git://git.chelsio.net/pub/git/linux-firmware for-upstream
>=20
> Divy Le Ray (3):
>        linux-firmware: rename t4fw.bin
>        linux-firmware: add t4fw-1.4.16.0.bin firmware for cxgb4 driver.
>        linux-firmware: update cxgb3 driver firmware to revision 7.12.0
>=20
>   WHENCE                  |    4 +++-
>   cxgb3/t3fw-7.12.0.bin   |  Bin 0 -> 31812 bytes
>   cxgb4/t4fw-1.3.10.0.bin |  Bin 0 -> 241664 bytes
>   cxgb4/t4fw-1.4.16.0.bin |  Bin 0 -> 298496 bytes
>   cxgb4/t4fw.bin          |  Bin 241664 -> 17 bytes
>   5 files changed, 3 insertions(+), 1 deletions(-)
>   create mode 100755 cxgb3/t3fw-7.12.0.bin
>   create mode 100644 cxgb4/t4fw-1.3.10.0.bin
>   create mode 100644 cxgb4/t4fw-1.4.16.0.bin
>   mode change 100644 =3D> 120000 cxgb4/t4fw.bin

Are there any versions of the cxgb4 driver that will specifically
request cxgb4/t4fw-1.3.10.0.bin?  If not, what's the point of keeping it
around after changing the cxgb4/t4fw.bin symlink?

Ben.

> Cheers,
> Divy
>=20
>=20

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-LokhhtfyEjgUXYscDoIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATz3Mbue/yOyVhhEJAQokWw//fQ3JnBJy/4NqkCIaZRELgwsYcBMhI3uu
K0qlteoTPjP1GvTWPMWnXhPDaSn02ZBFJ4Myx9NNzTHFom5tWUt32syrNVmwk1W9
VByi+LSCYA7Oqk5cicE63n9Lp+pvWQCiHE6mSGkKfYjfsbHjf2T3jtm/f8j/cwxR
hCv3aLVKhByybLhnFxeG/VB2d9M1IuTnJIIMC1Y7WCL4nUkjVDYpb2ljLNIcOOFU
4bdVhRiyskaunOHx7EUa0vO3riZP+m2WEN/7i171xwN05W6VpeL73WVpxGZFUpjq
+OwfFJg10E9uTFX+Sztd8kQBOlDS1TyB67wu2FNXytoLGNfBVv01yf86roIMCYSw
Wmx1oJGIsUKZ0DLpmP70M6fsw0krV8ViqlNbnN+DNY0NIHb+yCjmfpxuqaEz72Dt
nO/xudw4xKUs8TBxghry5kanCuTfNUx2QwKjyrE3hnCdod+8hpsQRMaqbz8xc63A
3Bq5KtDEJVhn33DYY6YeNW+5xkJLL0AZb++7OHg9/gBwpCfL3WtOgdhA2wWXo7MN
Zx50KJvZ8W5BOKe6XWRvBWQZ/8zDTHzxroP2lttTlYc5h+aHl/4ceJwnqXJ1dvO0
fVtQaXDGI75TjSGwyGUYYqU75mmdyeDP0yYycNhLQOTX31aF0sWW7VteziUXiAwt
JDANGg7CiAY=
=qHxt
-----END PGP SIGNATURE-----

--=-LokhhtfyEjgUXYscDoIO--
