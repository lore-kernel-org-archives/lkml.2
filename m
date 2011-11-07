Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1KGGda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:33:30 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:44777 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1KGGd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:33:29 -0500
Date: Mon, 7 Nov 2011 17:33:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Left overs from the module.h slpit merge
Message-Id: <20111107173318.12d4a5ce67a522b000d4a78c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_17_33_18_+1100_VXfMbeq=b4G.mlt3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_17_33_18_+1100_VXfMbeq=b4G.mlt3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Now that you have merged th module.h split, there are a few patches that
are needed.  They are caused by interactions with other trees that you
have now merged in the past couple of days.  Paul has all these patches
(as *patches*) in a git tree at
git://openlinux.windriver.com/people/paulg/modsplit-post-merge .  You
could just fetch them form there and apply them to your tree.  They are
reasonably urgent as there are some build failures in your tree at the
moment that these fix.

[PATCH] arm: Add export.h to recently added files for EXPORT_SYMBOL
[PATCH] device-mapper: dm-bufio.c needs to include module.h
[PATCH] device-mapper: using EXPORT_SYBOL in dm-space-map-checker.c needs e=
xport.h
[PATCH] drivers/md: change module.h -> export.h in persistent-data/dm-*
[PATCH] powerpc/powernv: include export.h in hvc_opal.h for THIS_MODULE

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_17_33_18_+1100_VXfMbeq=b4G.mlt3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOt3uuAAoJEECxmPOUX5FEaksQAJhBGRVLgjXFVKo19EHX6Ctd
Yz8L1sgvPVcdAwloQoLw2dKCOhGmWZVWzeZzhx2lX3cJSKegP25GiNrMRsnv7ugL
O1QeQRiJyqcVP94l0Aq0JtZmKX7UbzUOtlsB+9+ODg0dgzsb7jo86TKtFgNDMMGF
GSGvEtXKJfrgv4LoYuS3vA1oI5L1yuWUd6KXgQBTUEtVq9R8oQgnHjaWaAISKr4I
5rRQSpa3t+mr+9kXQWzqzv2JwjQrG8W/L333fNZ1VfrwmTA1l6WlR/8bFl5Si4iF
fMrXUFvHcEl7iY3morozwgEqefRJL61YFvHVTe6CyB1x3AOCuaZ6IQ1HDQ9b46Iw
lLas0SzilCYy/4v2JBdDKSJIJtK7lIZgdR7pFeifV7flhQt/5a/djAHW/xQJFrVK
h+C6B2rUVttolP+kthNBjxy8bvlF5ozM6fp1Epcxf9yU0fV8Svl2ZYeze7m9tKbz
nfPqqJ1WegY/P+dXudDLz2/cfyVRKdQfL57r1qjvyEV5jwKlh8PKqKi8jwlTWkss
zNYcJaBT77j3XifrsjFE/iFSku+gJzqlNEdKzx3FgMyxBdISZ5R0s7r0quO4LgME
jr7s3st9WvmdQ8cqMwfMexlwjfMvRnDaUbrCcCCbQV2orjhy872o2P/9PWCQfN74
uFRmtxe4EAGVRw7XwCNk
=1bTO
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_17_33_18_+1100_VXfMbeq=b4G.mlt3--
