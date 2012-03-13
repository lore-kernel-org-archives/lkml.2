Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073Ab2CMIrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:47:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51787 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab2CMIrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:47:48 -0400
Date: Tue, 13 Mar 2012 19:47:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120313194727.9d5939c174d54ea1569403f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_19_47_27_+1100_Mw6hsGs//UN58C_n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_19_47_27_+1100_Mw6hsGs//UN58C_n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-versatile/localtimer.c between commit e9f07fbc5f5b ("ARM:
plat-versatile: convert to twd_local_timer_register() interface") from
the arm tree and commit e129440af638 ("ARM: versatile: Map local timers
using Device Tree when possible") from the arm-soc tree.

I did the obvious thing and removed the file (as the former does), but
there is probably more to be fixed up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Mar_2012_19_47_27_+1100_Mw6hsGs//UN58C_n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXwmfAAoJEECxmPOUX5FEJYYQAJX3qbd/bSVia2/rAkUEpsM0
d/k/lwT/HuFYlFZOuGr7/PB91dBmOYLkg/5S2LoBZyU9jy5lw56+/n387lWZMF5r
Aw/zMNlT3dHXZLCe3QdZCf6hPQuoCjufAGrQv3pGdwoaWaw4vCpaRqm2V+o9Tn2h
D5iCVqVTghLIcQ9d1UV1M8/Bh0+Og6YpT4pEi4YFeZ/8LwnHtKGHDkaRcLlzss3P
bRRHeG7QMjzbOFR4OYpzBgtUPA6FVyK1iWsgOvno+XAzuC+evXCZJ+YerrTZSOFi
is5yA/tFab1KnidRMcoA/AXcAjTioBmf0HqIIbvfuYvtow79N5/dr1eH96TaZTVg
BTvHWFtyX3Otd4wlPVZ8EierAvBb0jAiHy0mfgw7n2PTqUFfsAqPg++Xc4vtLRKq
eztm8CL3OOikeVHp9FdCC9GYeGoI0l1BoUh0BG8R7mw1d1SwXrnge+lY5nos0p+l
675ul1KP60CFQXJkEGkhSz351ENAbIUbxv+ZPhzQytlgYvCAZP9rY/byG7pibhwk
DM4NF7ydgh/4EPkU9WUNA0EFjNiIfYZAGPuktKWb1ngelNy5Fe3+wBr8QLwbvJmo
WTOYyBhLCLNOgLStb9qS4r+ARLEcAplxfFMu4u7EuKKAznI0vEUdPUxuPKARN0Pw
uySh5XAQjpooIlQJ6dsz
=+ozR
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_19_47_27_+1100_Mw6hsGs//UN58C_n--
