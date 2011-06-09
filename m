Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1FIG6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:58:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47158 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab1FIG6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:58:14 -0400
Date: Thu, 9 Jun 2011 16:58:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Vossen <rvossen@broadcom.com>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20110609165808.8b36f634.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Jun_2011_16_58_08_+1000_nb8S27KVHF8LEm4n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jun_2011_16_58_08_+1000_nb8S27KVHF8LEm4n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/brcm80211/brcmfmac/wl_iw.c between commit e1c78de9a462
("staging: brcm80211: fix for 'multiple definition of wl_msg_level' build
err") from the staging.current tree and commit 8817f75429a1 ("staging:
brcm80211: removed wl_ (vendor specific acronym)") from the staging tree.

I fixed it up (using the latter change) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__9_Jun_2011_16_58_08_+1000_nb8S27KVHF8LEm4n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8G8AAAoJEDMEi1NhKgbsw3oIAJo1Ae3Q6dWJXnXOpFzHzUrI
O55FlTC5xpBFMVnxRZnIGDeCWN9LdzWntzcIJmK/iUwuvhLOT531KngoOOfFLGDz
m9/GKY+OEEbDigmqfKyNMe9Y2tRsT5lannIi/MObh1tNO61+e9pGtIqicpn4Ad7r
ZuPKh+0EkJ1ubslz+OsN8c9t4joq3hCK9yqfcfNKqFhC/XrTX5ubhjJ2HjqgfXgx
q6QaVT3pyIOyqQF78sQfBvrWYGbk+M9crUkBjF4nCT8E/ZP2g7XFCStft5LiSUQN
p0SAHlSvscbLUq6iRQ7FrLc44zZnUrf5Ekugadhs5qbNZz3Ldjmvg0svbuj3InE=
=s27Q
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jun_2011_16_58_08_+1000_nb8S27KVHF8LEm4n--
