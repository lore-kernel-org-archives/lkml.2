Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1H2FXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:23:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46087 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1H2FWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:22:55 -0400
Date: Mon, 29 Aug 2011 15:22:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: linux-next: manual merge of the akpm with Linus' tree
Message-Id: <20110829152250.d6427f6ecee4dbd59718cc4f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Aug_2011_15_22_50_+1000_B4uU0FVvUBBnm=oJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Aug_2011_15_22_50_+1000_B4uU0FVvUBBnm=oJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the scsi-post-merge tree got a conflict in
arch/cris/include/asm/serial.h between commit 02016bc0381c ("cris: add
arch/cris/include/asm/serial.h") from Linus' tree and commit f8b20ed71f1b
("Fix the following build errors:") from the akpm tree.

There former appears to be a later version of the latter, so I dropped
the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Aug_2011_15_22_50_+1000_B4uU0FVvUBBnm=oJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOWyIqAAoJEDMEi1NhKgbs2uQIAIiVuSTsgpanPMKKc8SrgLY9
fuRN0dpMs2Nr6EEOJUak8VMuY7FNFONeZSgWgfd9msPqH0wzodtplRf16arT1aPL
j8WrpXvAxxATuZ0wYg6aH+VOjYVYzGHaQvbI5yOX3E6FzPk9zejECyyOoNlHK6Fg
BPQv4iHl+92+u8C1jGUrHRhT84+QzDQjMUqbLjny0P4poTUMVXTMMEuIETzVaIPP
QhRIwTTFLV0aUlG1XKz1Cp1Uv4+dLBW+G95yTaEnZdju21Oq7XXdez6plFTVyPNk
MZMUlDoJ06pr4OFcy9bzngvNQT0w6kyZko02D8A2vt/ErGeo/3a7RKyOxBGIAe8=
=HgJ0
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Aug_2011_15_22_50_+1000_B4uU0FVvUBBnm=oJ--
