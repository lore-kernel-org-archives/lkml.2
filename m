Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2JBBNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 21:13:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52005 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2JBBNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 21:13:16 -0400
Date: Tue, 2 Oct 2012 11:13:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20121002111308.e46f7017cb8bdd5fef826914@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_11_13_08_+1000_Lyg9BuuTf1FTqqVK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_11_13_08_+1000_Lyg9BuuTf1FTqqVK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
Documentation/feature-removal-schedule.txt between commit 9c0ece069b32
("Get rid of Documentation/feature-removal.txt") from Linus' tree and
commit 251658e5185e ("[media] Schedule removal of i.MX25 support in
mx2_camera.c") from the v4l-dvb tree.

I just removed the file and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Oct_2012_11_13_08_+1000_Lyg9BuuTf1FTqqVK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaj+kAAoJEECxmPOUX5FExcsP/jz0IzscQROXTjPQVU21keAN
AIBlDuCZ9KLeD8vp/xT6+onqNX98iNnK5c861Bz9Hdz4rEWlJMn7Uue1CSzrOIxa
1p067qBLM2HNife/+CB6QIgSsVG48pYp02at6YIhjws868qMh23NvQYFNMJiSkcc
dsD2P5cJncC5qtc4aex7oxhXvywkSzCeZCxS03Zeu81ohvbhsL8vOBV2UsqfX91x
uF7E0dbFiyc1gMA9IK3Py/S4sWRDFtri8qEGmHHR+TUuBZCNqhKQ6xts7xWbLunv
nCjBYqtmm69hkP8Fpnb6K1EQoy+v40RxByaBkFJhVrzQTC4AwHaWsyOJBQw4Li8K
Z2y2hVrHTepdZufV0Heum5RmYgHmNmKAaoXkiC0dO3igmK476lU9+oSepnFb4/RB
U8HljvyiRB8APoxAfmupN9P/4e/5AbT7Z0IvKn9foHSBWfqtp5G6bJA9MdLcquaI
ZplCdypNZoyM9FuHt+VZpUqjeeOzssEFCcK9tlNwCccmrnIwXQGkMmnzijHNU3U+
vasYl1s1BnM0ticlHiteNXS2mhXmj6oPV10PAkyWIr5kJqAf13KW9WZqTLeOwz/c
vCW99YWZ2jHl/jqCXgfYWnk8uBEgr+stU4dx6pxBesDzGqaTSzU4434SH7SVdZxy
Mr2yrZj6BW/gjB/nf1uZ
=m/Nc
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_11_13_08_+1000_Lyg9BuuTf1FTqqVK--
