Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0KNWVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 17:21:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57840 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0KNWVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 17:21:03 -0500
Date: Mon, 15 Nov 2010 09:20:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch the davinci tree
Message-Id: <20101115092050.46b514fb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Nov_2010_09_20_50_+1100_+oJUz4NtVRjrvvZb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Nov_2010_09_20_50_+1100_+oJUz4NtVRjrvvZb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kevin,

Trying to fetch the davinci tree this morning produced this error:

fatal: Couldn't find remote ref refs/heads/davinci-next

I will use the tree from next-20101112 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Nov_2010_09_20_50_+1100_+oJUz4NtVRjrvvZb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4GDCAAoJEDMEi1NhKgbsRKsH/31gV2LhSBIR/JDjQqXWQrYj
F6GCkfyKABtGtNgLE/GfbppQ0t1JvwD68nXY5ebL4Bo00ZTkGniCt1mSckuUDqyE
h2QA/XGP5oNvAmKmaituifMy3OcvIrlbvNEI0az9TdiTCfXo0GMZkQBNNpHejSmi
oMECPchawvvP+dtyePwxtrT5OpzdII5QL4SEQ2zsnMjR52ypp6BlFmeEWohnpovS
YyxojpG0RIU7xCZdC76OCmQng3wdeZXWqmRLvF3tHdIGtODtpIsbB0mGJ84vwE2D
EheVOmOzuGKG0bMtWBJwjiviiaM2ToKplTI9fSi80w7wnvoPxf0KRR5h06nlx/8=
=yPIv
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Nov_2010_09_20_50_+1100_+oJUz4NtVRjrvvZb--
