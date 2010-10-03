Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0JCXrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 19:47:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35510 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab0JCXrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 19:47:48 -0400
Date: Mon, 4 Oct 2010 10:47:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the bkl-trivial tree with the hfsplus
 tree
Message-Id: <20101004104740.822b987d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Oct_2010_10_47_40_+1100_34YX2yz1qMbYW2L_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Oct_2010_10_47_40_+1100_34YX2yz1qMbYW2L_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the bkl-trivial tree got a conflict in
fs/hfsplus/ioctl.c between commits
94744567fef9602c3d8218a1d8f58c04cce354f6 ("hfsplus: split hfsplus_ioctl")
and 6333816ade7e04a96ec0a34a8378c455e4f7c4dd ("hfsplus: protect setflags
using i_mutex") from the hfsplus tree and commit
65c7297b0322453d238b2d23918a3a8b3a223c3b ("drivers: autoconvert trivial
BKL users to private mutex") from the bkl-trivial tree.

The second of the hfsplus tree commits seems to supercede the bkl-trivial
one, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Oct_2010_10_47_40_+1100_34YX2yz1qMbYW2L_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMqRYcAAoJEDMEi1NhKgbstjkH/34x+oxDNDrkS85XroV7agJv
3sLyReIWS6P+r22xF9BNp7PrjauAVoi/AU1ccWZGUyFAm+PDC3+iJWP/I30Djzcm
X3ouf5TC9tvYw4EGef19jR7igkZxKchVTVKrxN13oiCiblRfMPSGfuKMH/li0iKU
wXrTUHHUy+AxhxUz8N8lNdrDLwF8oSq5mPZ89GmX4HYnIH+LZe2SSv1f7b2hJKQS
f30Pvb71J6WG0GLU/ZfnswtQY1kAIYbuxKt907dAbe/ok3sEf5PuXIfQ4FIYuZSI
64BMu/ISVDJD8uRa0+wHwqrdLWXQkdQZaNn0J2R0ELvNq2LdbfRQ1s0vMHtDdlY=
=1kHn
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Oct_2010_10_47_40_+1100_34YX2yz1qMbYW2L_--
