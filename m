Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1I0GWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:22:41 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:50581 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1I0GWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:22:40 -0400
Date: Tue, 27 Sep 2011 16:22:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the mfd tree with the arm tree
Message-Id: <20110927162234.9331686758ee3c9f1b079db7@canb.auug.org.au>
In-Reply-To: <CAKnu2MoTz5cv9m+x84NeEbO-6YaK0QwwSaHpFwfBWiBG+GrdLw@mail.gmail.com>
References: <20110927134534.af4c3bdad6918111a2e03034@canb.auug.org.au>
	<CAKnu2MoTz5cv9m+x84NeEbO-6YaK0QwwSaHpFwfBWiBG+GrdLw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Sep_2011_16_22_34_+1000_4QclpEE8i1qo_wL0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Sep_2011_16_22_34_+1000_4QclpEE8i1qo_wL0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, 27 Sep 2011 07:52:28 +0200 Linus Walleij <linus.ml.walleij@gmail.co=
m> wrote:
>
> Nothing mentioning the AB3559 should be left after the merge, so the
> IRQ_AB3550_END should be gone.
>=20
> delete IRQ_AB3550_END and
> #define NR_IRQS IRQ_U300_GPIO_END

OK, I will fix this up tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Sep_2011_16_22_34_+1000_4QclpEE8i1qo_wL0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgWuqAAoJEDMEi1NhKgbsx8IIAKDP2h/POQexnkLI5crbTuRV
vSbXjlTQZkRb8HxUGrYiGN6HbJ/rpTOMU8xy7Jen+6usDebe+dt3EEOdKimyD8mt
THM+5J0k1Rd8fYACNd7SEWG7bQRMQsmzHKNro7B+U9X2kQolP7oyKl+oBfrMkX1j
wzuss3dsMWUshxqKRDKuuPOq8yqSbjfmf03mXTLuNWOLPr8RDYMqyXlxO3+T41pt
Nc6UeXh1EbpFICZlBi+vb1/Cg5XMgBZ83k+FTt4Rz0RqmsF1uTeUsEi3CIEUZumT
EaDRAUz5Oat4GxSvqzM1rZNkvpdFNtN72U0TwcXnOLZHclK63ccpmFi/zdmPf4Q=
=DY7i
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Sep_2011_16_22_34_+1000_4QclpEE8i1qo_wL0--
