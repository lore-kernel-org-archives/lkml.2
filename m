Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0IUCVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:21:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0IUCVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:21:07 -0400
Date: Tue, 21 Sep 2010 12:20:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bob Copeland <me@bobcopeland.com>, Bruno Randolf <br1@einfach.org>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20100921122058.bb402193.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Sep_2010_12_20_58_+1000_vwDhPX/VINABVHjs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Sep_2010_12_20_58_+1000_vwDhPX/VINABVHjs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/ath/ath5k/base.c between commit
d8e1ba76d619dbc0be8fbeee4e6c683b5c812d3a ("ath5k: check return value of
ieee80211_get_tx_rate") from Linus' tree and (probably) commit
bb18dec05909c96a13754f4e070e5d604cb2b805 ("ath5k: reorder base.c to
remove fwd decls") from the wireless tree.

I fixed it up (I think - I just applied the patch from Linus' tree to the
new position in the wireless tree file) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Sep_2010_12_20_58_+1000_vwDhPX/VINABVHjs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmBaKAAoJEDMEi1NhKgbslUUH/RqwcquTHPn7r+afCb92fckI
vOrtpmK5gRcYiBgP57Rm2IfJRD/XYkcd9vCupcM5cbri6aNpq682FdY4G3PTR0wC
3kHl2tXOOiNtzpClglWbycem9OaLxQydfNN2hNQu0sfBUbG0OGHmoxdYKdnFZxsT
j1uF3qC4IguyVmkQXoyQou3FSGxovg/7lvmOuPW0kpz6RyI9VlSg0Q3bsBJTE5t/
lhVm16526pIAV+p7eiSUOZU38JUkCXk2Ow15KqQ8QanMuHqA4v5EU6YT2iUYG7RD
05O9vHDQhILQh38G4FmbOXOCG/t5g+6Rbul+/oQZb4p39biscli05K0SujJHGwQ=
=9cy/
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Sep_2010_12_20_58_+1000_vwDhPX/VINABVHjs--
