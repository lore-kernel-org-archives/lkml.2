Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2FLBcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:32:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50777 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab2FLBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:32:04 -0400
Date: Tue, 12 Jun 2012 11:31:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless-next tree with the net
 tree
Message-Id: <20120612113148.24f733ee30acb204faedce3a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Jun_2012_11_31_48_+1000_5u9GJPzGwVjZY4_b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jun_2012_11_31_48_+1000_5u9GJPzGwVjZY4_b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in MAINTA=
INERS between commit ce466579b1c9 ("wireless: add my new trees to MAINTAINE=
RS") from the net tree and commit 491b26b40222 ("wireless: update wireless =
URLs") from the wireless-next tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc MAINTAINERS
index f6e62de,c5fd905..0000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -4351,9 -4339,8 +4351,9 @@@ F:	arch/m68k/hp300
  MAC80211
  M:	Johannes Berg <johannes@sipsolutions.net>
  L:	linux-wireless@vger.kernel.org
- W:	http://linuxwireless.org/
+ W:	http://wireless.kernel.org/
 -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
 +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.=
git
  S:	Maintained
  F:	Documentation/networking/mac80211-injection.txt
  F:	include/net/mac80211.h
@@@ -4363,9 -4350,8 +4363,9 @@@ MAC80211 PID RATE CONTRO
  M:	Stefano Brivio <stefano.brivio@polimi.it>
  M:	Mattias Nissler <mattias.nissler@gmx.de>
  L:	linux-wireless@vger.kernel.org
- W:	http://linuxwireless.org/en/developers/Documentation/mac80211/RateCont=
rol/PID
+ W:	http://wireless.kernel.org/en/developers/Documentation/mac80211/RateCo=
ntrol/PID
 -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git
 +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.=
git
  S:	Maintained
  F:	net/mac80211/rc80211_pid*
 =20

--Signature=_Tue__12_Jun_2012_11_31_48_+1000_5u9GJPzGwVjZY4_b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP1pwEAAoJEECxmPOUX5FETGIQAJuHF5QNEj8iU0UDaLcWZsmD
IrxfnEe2UF/hn8yq8H4bInP6YuXLm+oDxxnUw2gKRdGZee9/AGx1ubf/VbYZoM0U
i1EqtIH9YT2g+Jv9A1CwgwaZjOP/d4qAU8OKz6khk2apu5E5DF0Pi7aX57ym+1n5
iaTv+P/OfFClkma947tnTGhnFU7Q533Z8UCPdJ+da4cAc6eAnfzi6j5ocx40hEcZ
oseluY+qcjvHb/4skr1D3F6mzb+W9DF5YHjZTziZAhlzFCaxnE0IiMAzddFjgb8B
T1Ve+t1VhwSuM7i3v8Rl4QFkW7laURhdtyK1hmaj37TOQkNL+Cb3/kojpohqOR+P
/WB8T0H+4orCWLXVsVbepkUXYYlXY1+OSFYQFdcuXAdS64mcLu0ebDOd9ULUm3Fj
jGD2lHxdn5ws+wnf1lvU6HCwONZuuIc2L8btLeh/bd5/ULLKoC2GHHWq5toZTAah
cqhKc79YRV9c1ZCIU5VzHbgOmLFL4XxiA9TpHYmksfR/E79jHDONOaczMtWWHUUa
v1fdT4OeyR06g9H6nCtHHSVd6aDPvzOzqWPlQF79mIzGifuCRxmeQ3bA0fTVUr5+
pqSyKMTzwOfREJw4+5dUHz3IB9JmzoiYOkm4ap6YyZDEFevy7IAN9PMk/RlDOZ9C
16D1dPo9j/YPwm0T5d8z
=cL6d
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jun_2012_11_31_48_+1000_5u9GJPzGwVjZY4_b--
