Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab0JSGMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:12:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60438 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab0JSGMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:12:45 -0400
Date: Tue, 19 Oct 2010 17:12:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ruslan Pisarev <ruslanpisarev@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gorskin Ilya <revent82@gmail.com>
Subject: linux-next: manual merge of the staging-next tree with the v4l-dvb
 tree
Message-Id: <20101019171233.9f3e1dad.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Oct_2010_17_12_33_+1100_vQa8FP1QT4B.Lu/x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Oct_2010_17_12_33_+1100_vQa8FP1QT4B.Lu/x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/cx25821/cx25821-audio-upstream.c between commit
d6a0215fc954bd16a21bad94a3292f080d9f6f04 ("[media] Staging: cx25821: fix
braces and space coding style issues") from the v4l-dvb tree and commit
bb59a4c539140592723e806e852ee171da0eb3eb ("Staging: cx25821: clenup
warnings found by checkpatch.pl tool in cx25821-audio-upstream.c and
cx25821-audio.h") from the staging-next tree.

Basically different versions of the same patch.  I fixed it up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Oct_2010_17_12_33_+1100_vQa8FP1QT4B.Lu/x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvTbRAAoJEDMEi1NhKgbs+h8IAIyp5HO++Xy0QlO9bdn/ExTM
Vn2egzu4a7FUVqGWJQ9RIrXpQPXcvfn21gmWwqhGGGATB0Eek3NcC8CplfshltuE
elmjhYY3LBoPPGrK6eyGhqVsmE0HUd3ldwX+anrznmfEm8cANBbVC815+MTfQyl/
VVDv54msxXLUx63zBJq0WEjVpHCZAdb6rXMNPrW8ZnooCavNC2ehfyR7mgjns/pz
QuCx0B0ZIrdcInZf89bjG8tbSYxy7H0kBdHsuGpJU40NPNxzFBRm4zeIwxiNeS7X
zd7Mzle1c2hRlR/oZV2HdQ/QZAB+NYCwLqVlrgUDvd/xpBwtRVnLhjZbAxzBN+8=
=KX92
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Oct_2010_17_12_33_+1100_vQa8FP1QT4B.Lu/x--
