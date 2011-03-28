Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1C1HEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:04:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57220 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1C1HEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:04:42 -0400
Date: Mon, 28 Mar 2011 18:04:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
Message-Id: <20110328180434.d24e4465.sfr@canb.auug.org.au>
In-Reply-To: <4D902E2C.2010701@fusionio.com>
References: <4D8E36CC.7080707@fusionio.com>
	<20110328042311.GA15481@elte.hu>
	<AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com>
	<20110328160812.b4d19eb5.sfr@canb.auug.org.au>
	<4D902E2C.2010701@fusionio.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Mar_2011_18_04_34_+1100_3Mv0ARUP2HKItBwY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Mar_2011_18_04_34_+1100_3Mv0ARUP2HKItBwY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Mon, 28 Mar 2011 08:43:56 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>
> Yes, and I merged your patch to fixup the build (on PPC, as I recall).

That was an earlier build problem.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Mar_2011_18_04_34_+1100_3Mv0ARUP2HKItBwY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkDMCAAoJEDMEi1NhKgbsNvQIAJwhpfHvJC8h0ITlgiQud0b4
RfUFlx3uRnCITdqfi6Dx+LU8lKjGPy13rQnWSKIthdevAu19Wyb1uCj33uF1on6l
VUSM6wVe7GmPkCFm86xE+6uxY6bycDPu+KX46o83PaMGiCArKgGw/o7GB4rkb6Pr
LnyLTM7l0mnHwM/oGDUxHoHtk3C5LhS34EggUqD9PP77/7yhenlaxdDoNAaqtq7s
Ur56ZSp0dZHlVjYHCwyh1Pu5ZdvDN4wct6PeoaEzAGKCOdm9+zQA6X+wdxkdbV5S
iis+4fR8CJh52ESBUnTdqSXByj8QpcnN+0XEJ07jP8RXWVIrOKyqZlx8tCBJwpo=
=DCa6
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Mar_2011_18_04_34_+1100_3Mv0ARUP2HKItBwY--
