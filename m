Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2AEDk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:40:57 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43125 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2AEDkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:40:55 -0500
Date: Thu, 5 Jan 2012 14:40:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the battery tree
Message-Id: <20120105144042.4e03850089cce56a7e9312e4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_14_40_42_+1100_Wt5wvfxwae63Lh1l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_14_40_42_+1100_Wt5wvfxwae63Lh1l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

After merging the battery tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "sysfs_create_link_nowarn" [drivers/power/power_supply.ko] undefined!

Caused by commit 8351665195ce ("power_supply: allow a power supply to
explicitly point to powered device").  That symbol is not exported to
modules.

I have used the battery tree from next-20120104 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_14_40_42_+1100_Wt5wvfxwae63Lh1l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBRu6AAoJEECxmPOUX5FEM58P/39RwpaO86H//pLtZH0Psy3M
cH5DZuBLDGjhPfTa2W2jchC5ubLdWVV8bo3qPtsBHaad5Axx2ZXQ4AFlbwksDta7
KQI5pJ0BPGSIwM8Uuwd+HuCXWNu8wOytugoGB93bwxfK6aNaZEVlRGBqQgaQ3fGU
URqklXVmFrr0qVC/LU5A9tVvZhQI21IxugbhBMiSIc0IX2w7M01tO2UyEqxKoCJD
ZT9SGLFkf901OpWx8Nt1HlLS0HdbMMDXgjmdo6bIzSoI20WBkxLMsI/ZcZVyOoow
4ifHU4HcYPYdlSR/1vUP67VNsqVS28E8CI88tD1UpewcXdKCsvsJgwBt2W1jgoXV
HF2OzDxesr5orytkhkdoRlvQp+3o36Fu5S09t2qeRixqqjLWbpbbChy9hNorBuQt
WvZyO6lHCy3xWwQj5lkPz2B0QTfMUwiLjg7e5ncQOC6/1m3GqeGVIm5YxhUpEliS
YIocisC2XwalXHoqg7oV9JlbTEnC8K0oELtVnx2XocqGOhoapwvEHIAtBJZKK1Zy
umMcM3rJZKNScK+62TUDG4IwmG+G5ybZnzk87ETYeUBhSe8h9WxzbipVqkm/kMgI
NWFvpI2JkBO5IEx04wm565LjWrjmQ1cZMVeyWK672wyqMiTVYzIvgIuUwpY7QzIa
uBM2dTzEXixDAaDjJORp
=luo3
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_14_40_42_+1100_Wt5wvfxwae63Lh1l--
