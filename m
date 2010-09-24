Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0IXCTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 22:19:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60727 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab0IXCTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 22:19:34 -0400
Date: Fri, 24 Sep 2010 12:19:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>
Subject: linux-next: manual merge of the trivial tree with the net tree
Message-Id: <20100924121924.8fb5dfb5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_12_19_24_+1000_T+cqp0Y/sTELpsH9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Sep_2010_12_19_24_+1000_T+cqp0Y/sTELpsH9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/bnx2x/bnx2x_link.c between commit
62b29a5dd0930e0c956b6740f32d5b3bbaf20136 ("bnx2x: Adjust alignment of
split PHY functions") from the net tree and commit
0b1974de66f9ed44f1423449628f4926bf95b854 ("Fix typo: configuation =3D>
configuration") from the trivial tree.

The former removes the text updated by the latter, so I used the former.

Jiri, you might like to drop that hunk from the patch in your tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_12_19_24_+1000_T+cqp0Y/sTELpsH9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnAqsAAoJEDMEi1NhKgbscFMIAI9K95g49TcXKFQSPcro1zOi
IQBCtOB1mnsXQCXj/OfopUqzUfHQdSmy8e/oAmbmEjXJAK5JI8hWUPNSDl2ZCYZ8
xcmnjA9g0/kbsuH56ij+LRZz8X0u0t8sdqvaM/x6rELKRoB+mb8fEhVJq+ZRP2nX
lvqOPG7SQUJKDxvJPw9kM/W+ylBzToS+F3SQsLaYOx7j1M15DDPhL34FI54wlTwA
ZGUQgMry1xGUSe5TEg7OOxRUkiLb8hzOz8lL7VTcT3Hs9MhPhVpNfWA4qRFOYDII
xQs8rB/wLqO+GbwHH+A+R4ncK3Nkzidb+1+MJd0+CLo4T0o85275o+Of9pjU5lU=
=yBi9
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_12_19_24_+1000_T+cqp0Y/sTELpsH9--
