Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1ITD2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:28:21 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:40780 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1ITD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:28:20 -0400
Date: Tue, 20 Sep 2011 13:28:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luciano Coelho <coelho@ti.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110920132814.16d957ac9ddccb2e47ece1c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Sep_2011_13_28_14_+1000_42//hA_iD/0HhwlX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Sep_2011_13_28_14_+1000_42//hA_iD/0HhwlX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/wl12xx/main.c between commit 7a5e4877c14d ("wl12xx:
add max_sched_scan_ssids value to the hw description") from Linus' tree
and commit 221737d24f88 ("wl12xx: increase number of allowed SSIDs in
sched_scan") from the wireless tree.

I fixed it up (I used the wireless tree version) and can carry the fix as
necessary.

John, maybe you could merge the wireless-current tree (or the part of it
that has already been merged into Linus' tree) into the wireless tree and
fix these merge issues.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Sep_2011_13_28_14_+1000_42//hA_iD/0HhwlX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOeAhOAAoJEDMEi1NhKgbsSTEH/079362ctTHOd7P7+ThjAayC
BS9lug3dGJXkaRx6jB/Hhspbrrltf2WhMixNVGMt67AUsm+AWppXwyYEwzNTsjwZ
I/pBJH+vcdkO/AS0dY/OHqzMpjJEHy0sT4yT5rQvsa78EIpxod2vuVqoO5kgieSq
B0gW0r+/ieCXehvOAgSR6aIKCjGbUuizzC9mxpgR+GaRxgbx9lyJDwXaTr8GE5wD
0Z8CsXsky+BfxVEPtzH3e+/VPdmkYEmouZ4dV8HXYgvZarzH6hvR9has7h/FVNvS
rZ2jz09rJbnzac3kiba1uLeIvNK6iMhueztRVQ54d5qlWXVemB2aEXg82XAGa6Q=
=rC+K
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Sep_2011_13_28_14_+1000_42//hA_iD/0HhwlX--
