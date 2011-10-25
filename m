Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1JYIS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:18:58 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33575 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab1JYISz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:18:55 -0400
Date: Tue, 25 Oct 2011 19:18:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Voss, Nikolaus" <N.Voss@weinmann.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the tty tree with Linus' tree
Message-Id: <20111025191840.329d2a862d549ec6fe6b242f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_19_18_40_+1100_F0fs+N+_PyQS9yTl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_19_18_40_+1100_F0fs+N+_PyQS9yTl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/atmel_serial.c between commit 0d0a3cc183c5
("atmel_serial: fix atmel_default_console_device") from Linus' tree and
commit 4cbf9f4864bd ("tty/serial: atmel_serial: auto-enumerate ports")
from the tty tree.

I just used the tty tree version (which may not be completely correct).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_19_18_40_+1100_F0fs+N+_PyQS9yTl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpnDgAAoJEECxmPOUX5FEl+gP/2rYffmrtjqmam+EJ0L+Kdg3
gmVuy/kMHfOi2jzoG8V4xAZZdSxSoribRV5WN1exyfmlx9jrVLAdwLAyYLcokPql
lR0tVWPxpMatC96kGOa/iJJEzxArYSItvYUANNA4klyOIvDER7bHPd8+1zPHpbeJ
hAooqb38grxZjMDrNCtn5Q1KBccQh14ei3aGXoqpaES4yLqsJ8qSCYTa7BlCqvbb
2NOtTDt/AdjfDRu/0tweAHazsruU9v72SrBDLXxwGqY+swg2xEsZe9sTr3pCpAUD
AC3AVFgHP9BXMLLNTnojeoTW1YTMeX2qu2ZGistN8KnOKl6x+kGv1Y6wcwMhOqYJ
DRFTIQdDLSlUGVd5JKQMYBsiMd6DBDl2kf9xyJJMcfDPTWeUcG45d/Y2fGN5UTdq
LMiIB+3oGXFE7YeUSEmwvoJ3zi8qURO1mecR0hom+nBadYMUbPG2zSze8taEKsCy
w5WPB0I2cFR3/RRy1gRNUAOgngx3rO6cbd7sQHEOm2xaRFUnWPvT4T6/eth4B/Da
616LQgA1McvooEFQJyntJ70OniXpQji31y4UF+6szn8QiOaKekrFKKTU48t8ySrg
vDU5qonBGUW7J1Ze+v8/EXnBwQJH95AlpAARAOC490GM+pzYG+hV8dOQL+dd+bQU
G80Xs3MONZAYo29yyXYs
=VohI
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_19_18_40_+1100_F0fs+N+_PyQS9yTl--
