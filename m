Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2GJGuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:50:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40969 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2GJGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:50:35 -0400
Date: Tue, 10 Jul 2012 16:50:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Alessandro Rubini <rubini@gnudd.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-Id: <20120710165033.ab9ffbee81e2aeb03cad8d00@canb.auug.org.au>
In-Reply-To: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jul_2012_16_50_33_+1000_TQzqAXBCGaEJ7u.I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jul_2012_16_50_33_+1000_TQzqAXBCGaEJ7u.I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 10 Jul 2012 16:41:30 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/i2c/busses/i2c-nomadik.c between commit af97bace2cca
> ("i2c-nomadik: move header to <linux/platform_data/i2c-nomadik.h>") from

Also commit 235602146ec9 ("i2c-nomadik: turn the platform driver to an
amba driver")

> the i2c-embedded tree and commits 32e42c687e0a ("ARM: ux500: Remove
> unused i2c platform_data initialisation code") and 8214fd238a66 ("i2c:
> Add Device Tree support to the Nomadik I2C driver") from the arm-soc tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as necessary.
> Please check this and talk to each other ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jul_2012_16_50_33_+1000_TQzqAXBCGaEJ7u.I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+9C5AAoJEECxmPOUX5FE2UYP/0A9Mh+vwUUR3HpngD15sR1z
0NDme8UGObFnWMY+0XOFeRs4h+JIDeOfjqG9q5iNchL3RLZIxlSrDEES7dYM62vV
q6nPkLxGOyYTm1RvbJ7A+9N8ZP9LFf1zWaLbG0RffHp6n7+jBAY6ppOaMSLS7o/G
0N5btt+rNU+qzNPRgIYuaic8QRXIv7f9s6LJxEenPULO5F2QmVweV0KGQFR5gQ5c
qXHZN/c89QVbbnowpLkyIJ1e/Z6fQzJEkkYfC4lXIQHvb5jsAfmL5DDCMn5qbhF7
C6zX7gqglM1lwBi+FoeD++I3ix/V6LlQxkBdCpYSX7u/tO111OBharfhep7ovPbw
GHM0btkbb0c92NKM9jNw4y1GqyFBysP2e3qbZnCdSnSi/ei3nhz0JhcKA8XJNqM5
dQTYd+5xop9hoFCYOokH4Ja/t+E11/MnrhhlrAt9aQ1KXEOLI1xPPd5Me2VfwKV5
ysFFLvdtWXL9uQPHF1fMRLgMhF95UjB3Kl5WSaHmCVpdVWCvxxiURvtUK/heNVH0
AFL/BztBAsked7sawMZ1WR2/lcS8I4KWn8AOgdy62Y7/debnjTRKC7Ii60JnYrFM
lxT6ASZGVzTu3YIw2pCH/uMtUAtC0NTu1x/zbfboPc0+Kww+NFhBPc/jjRicjG+1
UOZmzw/TkiXI8fm3fSjn
=pZg/
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jul_2012_16_50_33_+1000_TQzqAXBCGaEJ7u.I--
