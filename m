Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1HBKIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:08:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53978 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab1HBKIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:08:44 -0400
Date: Tue, 2 Aug 2011 20:08:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: linux-next changes
Message-Id: <20110802200834.c7993f608603560002bc4b94@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Aug_2011_20_08_34_+1000_5iqsyphPrTw5mnVw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Aug_2011_20_08_34_+1000_5iqsyphPrTw5mnVw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Noone seems to have noticed, but I have mode the following changes to the
linux-next repository on git.kernel.org:

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git now
contains just the last 90 (or so) linux-next trees.  I have removed the
"history" branch from this tree as it was serving no real purpose.  You
can fetch a particular tree by using its name as a tag.  It is now aonly
about 40MB relative to Linus' tree (as opposed to 300M for the complete
tree.

I have put the old tree into
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git
which I will keep maintaining with the new trees, but is just there for
historical purposes.  It also no longer has the "history" branch.

If anyone had a tree left over that referenced linux-next through an
alternate, then you should probably change that to reference
linux-next-history until you have fixed it to not reference it at all.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Aug_2011_20_08_34_+1000_5iqsyphPrTw5mnVw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJON8yiAAoJEDMEi1NhKgbsC4YH/3bmLKd6U3+TTVW1FpPfG6et
+JYqYffoH2OP1YPAmBl/Nq4rJLzXRFm9vrl36Q5p7n+yaa0HqUmoV1Ers6OfB9Li
dI8LTa2/zvjWUnXqW5uTLUw+8nkt7oN/Ymh8EcuOkPK4HDOI24Ma+JDHU0wVXnnc
u+6krzn/LVxXIWExhttUoz8P8pgK2HsQKxR7BePT6Vil0uOP3j7xegX4DViHfiSg
iPpmvo/fCH4ESFv/SH/u/fMM9bP1v416TbmJo62EhqFTVFEUthcrb/q1iLqFXRZU
8Tkbrco1GgaMfZEBMWCbzFFcT3ngCUTvt9rB3Z+zQIvkwDA9bEWJ4lbpFpK0Ia4=
=TMuH
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Aug_2011_20_08_34_+1000_5iqsyphPrTw5mnVw--
