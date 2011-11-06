Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1KFXdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:33:21 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:44175 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1KFXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:33:20 -0500
Date: Mon, 7 Nov 2011 10:33:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20111107103313.6e1067675b2cd2f2de6bded7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_10_33_13_+1100_D8zptsq41phhrOqo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_10_33_13_+1100_D8zptsq41phhrOqo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos/Kconfig between commit830145796a5c ("ARM: EXYNOS:
Add ARCH_EXYNOS and reorganize arch/arm/mach-exynos") from Linus' tree
and commit 8f7e34205f6f ("Merge branch 'next/cleanup3' into for-next")
from the arm-soc tree.

I just used the version from Linus' tree.  Arnd, it seems that some of
these merges were done differently by Linus, so can you please clean up
the arm-soc tree now that it looks like Linus may have merged all its
content.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_10_33_13_+1100_D8zptsq41phhrOqo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOtxk5AAoJEECxmPOUX5FEPtgP/0K6zerJT/QuP284vXonr8QH
PENgu9tndc6YsMtn1Ex3WRbj8F74wzvY4UXCKoQdJK4K/sfia4XDTrwdL12Cxp3q
Y20czOp0gflhye8vAn3/9MrhBMpW4X2R0JEb2Y2pVaL5uF+nTrXR5rF7f/vxmAJw
+We742Py7h7aStVK3OKl02pSMlDTU0UNDvx2Z4F+4UPt+d9hGFGHcqal0CtmsirB
acdvrC4y/191YcH7D3nXka1BC/rG/zfGMhPjnY6vEZsxYzR7inNrtbE6ZRgjyeo2
Kv2nWH7Te2RzvLFYSeD2GkN3z09suaSnNedp3Wh6ZZARQsV9YuRwkcQQk/vJkUqx
eFFrVXIqYQz5macAp1HNqMp4SfNuwbagPS+JMXI+QYME3VLW7rLMOits8LAy1H3l
qpt0xYp4OUu3f2Hmbl4aG6Em1z26WpRqOQF2KOPQIPnMY3L6MiQ8Z430AKWF5LSJ
CTjc7p2McAw5gcEALgm5HllsLSy6AeBXn2+si4TKjc8wpAEwUEKhzKYdw7QmLKW8
hbjY3zh/jqqQy34sK5Rn94UaPZt0Y9GRd55o1uCEF4XK3kFtD7+lyNU9tSGVodU2
S8kCoQIYATsM6IhBcz+45ldV2XD8+yWAxogNYwZxgyIdLw0YnVFn3B4GdrDDaZ++
pjbfDqRhEUAukE5UU1hV
=IZzA
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_10_33_13_+1100_D8zptsq41phhrOqo--
