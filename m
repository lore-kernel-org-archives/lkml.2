Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1ECBn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:43:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52510 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1ECBn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:43:57 -0400
Date: Tue, 3 May 2011 11:43:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Schocher <hs@denx.de>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the 52xx-and-virtex tree with Linus'
 tree
Message-Id: <20110503114353.30d1f949.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_May_2011_11_43_53_+1000_GmgpIWvEuPb4l4Qm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_May_2011_11_43_53_+1000_GmgpIWvEuPb4l4Qm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the 52xx-and-virtex tree got a conflict in
drivers/video/sm501fb.c between commit e6a049807105 ("video, sm501: add
edid and commandline support") from Linus' tree and commit b6c19191c13e
("video/sm501: add edid and commandline support") from the
52xx-and-virtex tree.

These are slightly different versions of the same patch.  I used the
version from the 52xx-and-virtex tree (that removed a use of
__devinitdata).

Also, another between commit 4295f9bf74a8 ("video, sm501: add OF binding
to support SM501") from Linus' tree and commit 9d83d245a352
("video/sm501: add OF binding to support SM501") from the 52xx-and-virtex
tree.

Again, different versions of the same patch.  The former has a whole hunk
that appears to fix a memory leak.  So I used that.

I fixed it up and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_May_2011_11_43_53_+1000_GmgpIWvEuPb4l4Qm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNv13ZAAoJEDMEi1NhKgbswjAH/2F7nRvK8aYz+cgjDwLd/BTw
I/P2xk3BYLjL39MaX16hDxFUUgR5bHDi5WAY7yAGuYpLF7PUbq79TW+Qj7+sADIv
fVxppyttW9U8Vr781xZH3pz+kdkucxkwnlJ2vI55uVhhGgJlLquZEhz2PAv62M6i
9XDzRi7Nd7hFHwhW/IV1bfpgJtPy5p5w57H9nzNldk+rlu0TVQKp6pIzsn+fDClb
fvvMQO+d8lKnk4iQZtb9NN8mFU1tkDsYBN7vUfLYsl4fL8oj4xR5rz2M1rcT59VS
GLP9EM92C5KMneCI7nRyGTfbBx+LuSrEMLREtjCqNV3e6JiFTGdHtbyc8HioKVo=
=xboV
-----END PGP SIGNATURE-----

--Signature=_Tue__3_May_2011_11_43_53_+1000_GmgpIWvEuPb4l4Qm--
