Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2B0FYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:24:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59260 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2B0FXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:23:50 -0500
Date: Mon, 27 Feb 2012 16:23:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120227162341.87ff40134443747c9d9dd0ab@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_16_23_41_+1100_2_qWy=A=Pz.WvG98"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_16_23_41_+1100_2_qWy=A=Pz.WvG98
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/irq/manage.c between commit b4bc724e82e8 ("genirq: Handle pending
irqs in irq_startup()") from the tip tree and commit "irqs: fix handling
of pending IRQs at request time" from the akpm tree.

It looks like the former is a superset of the latter, so I dropped the
latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_16_23_41_+1100_2_qWy=A=Pz.WvG98
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSxNdAAoJEECxmPOUX5FEwaEP/05rDaEeCvazZhIoFOtyfbEo
7tcm9j/gpTaCEaJR3ahnT5V7UZrO4ILN5uMoQTbRF8m/MgfW+/9KIdSN02FpuaYI
8Kdg3cT5Jmu+L+w1YyE5tUiylQl5kDO7IVT6arBpvTAyp5Rh3TW2YDyyux10dfhP
Rdqg230wAPNQw1cr/hK5HvVeov7btpxFFQffiJIqGNnN/FaoYkmRmhILWwedWcuR
RjCFWZioHxbQHoX4wJbD/9pJioj3NZyF1T1EaCPfVZofWzyulbvr1F+QEuMzEf5T
LxvrYapT1VVBiegNWkEMuhO3ZKjngEYFZc1y8fELva9og5vu7FxNqlwvxN60kh11
jzQPvZqN+4YBIYww5hxrCLy6N2pAuv0Okk3MlVXOO6CzZz6LR/91mK9EGca0+8ea
Np1OBD1mTvXVU0EAhWjAxKlasINROGqtBGee5l1JQqta86TfH6AAHKvIgTi+F1tk
c3fkiza4PGx46ijVJ8JaQ8+iVj1NjbSUBhj7NzHHEjEU4f7mHwbrL3qiPG2XOn+H
8ySaaRZGAy1DtPdhJNcR92kodgle+MRWxbSfUK6/aXugvbCjh1L1hAeLv1WWxN73
gxHjQ8PoSG1/5pIXDCMh0AvA//oghUzt4UOLy0SY4xx60uqGF5fPsYV+/kHHkKws
awd0cvcTuyQumMraDz8n
=0dd/
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_16_23_41_+1100_2_qWy=A=Pz.WvG98--
