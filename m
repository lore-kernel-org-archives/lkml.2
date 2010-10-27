Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab0J0ADP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:03:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37906 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760584Ab0J0ADN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:03:13 -0400
Date: Wed, 27 Oct 2010 11:03:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the final tree (tty
 tree related)
Message-Id: <20101027110307.e754ef59.sfr@canb.auug.org.au>
In-Reply-To: <20100927153151.9bf66022.sfr@canb.auug.org.au>
References: <20100927153151.9bf66022.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Oct_2010_11_03_07_+1100_vevi.uZmd01Qw2K5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Oct_2010_11_03_07_+1100_vevi.uZmd01Qw2K5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 27 Sep 2010 15:31:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>=20
> drivers/char/nozomi.c: In function 'ntty_ioctl':
> drivers/char/nozomi.c:1831: warning: unused variable 'argp'
>=20
> Introduced by commit dd612b1a8edb7fb3a117c388bfb520476e04ed18 ("tty:
> icount changeover for other main devices").

This warning is now in Linus' tree ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Oct_2010_11_03_07_+1100_vevi.uZmd01Qw2K5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMx2w7AAoJEDMEi1NhKgbsIwEIAJT8ixBzhy8rRXsV+yAZGtFi
7UIlK4CtJIAz/nUzlui+GkCr15Dmr9NFuHs/MO0WpcxY1IphNrZqxbtM//oMkE82
+fU2Jtckknv/YPKjKEd6NwNPvzOdH5m3mdHf4vEGKY4isujw+xSgL0plzJ91fb4/
NvUkz9pTD+VczmyKTDsEAc2b4ClaOu5++HVkcwJkAGsQQA8jliSul3UTbYjHP2ZU
jTag12vB0Wl+yqwaXBW0G/5RPA36k+VM5oWtWrky/HIBzFYN90v24xkd4pn4YDId
4UOSNbCU87RBq0SImaOkfKza0+BhzvqZlJwQEsAt2aLRYXe2riT5B5VWDugG2/k=
=dRDR
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Oct_2010_11_03_07_+1100_vevi.uZmd01Qw2K5--
