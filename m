Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750845Ab0HPEAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:00:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46266 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab0HPEAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:00:22 -0400
Date: Mon, 16 Aug 2010 14:00:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chen Gong <gong.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning in Linus' tree
Message-Id: <20100816140011.f899996d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Aug_2010_14_00_11_+1000_ThbiMGUjPQemIghv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Aug_2010_14_00_11_+1000_ThbiMGUjPQemIghv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the slab tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

/scratch/sfr/next/drivers/hwmon/coretemp.c: In function 'coretemp_init':
/scratch/sfr/next/drivers/hwmon/coretemp.c:521: warning: unused variable 'n'
/scratch/sfr/next/drivers/hwmon/coretemp.c:521: warning: unused variable 'p'

Introduced by commit 851b29cb3b196cb66452ec964ab5f66c9c9cd1ed ("hwmon:
coretemp: enable coretemp device add operation failure").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Aug_2010_14_00_11_+1000_ThbiMGUjPQemIghv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMaLfLAAoJEDMEi1NhKgbsnDMH/AjxqvyeF6YlAFAmm/apW/zz
tLMLbmVOmhcOGvAZlZBteQb9y1XHCfOWUCzI6igtnaV7+WaU3xDVKxRDXaCmMep4
nL4E8bCsFMfdavQFtXHNywr8DjJN8Z1lJdRpdV4Jm+3wV75cVI3C2+Ut8BrZi//v
AJ5gdWFOs1bN0PFpNGAPuTBonTgglrukl1XUHiU8XTkb5l7kXb+LiVCYuPvuBp+K
917z5LKCDjgjq/HCBHPGPyCJwxMM73elWlTRsH9ST7vAghl13Wzyr7QXItXwx6u+
YO4UrTY9l42giyDaVJ0sLDaOVqRZ5fGiH2fN/AWc66p6zsg3CSX+MBj1KWgzRl8=
=jJwY
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Aug_2010_14_00_11_+1000_ThbiMGUjPQemIghv--
