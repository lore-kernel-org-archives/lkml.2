Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2AXCVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:21:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55754 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2AXCVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:21:32 -0500
Date: Tue, 24 Jan 2012 13:21:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: manual merge of the s5p tree with Linus' tree
Message-Id: <20120124132123.6957dd9c43aa692fa12e9c81@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Jan_2012_13_21_23_+1100_q=emRr2hg5=N_8rr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Jan_2012_13_21_23_+1100_q=emRr2hg5=N_8rr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-exynos/cpu.c between commit cc511b8d84d8 ("ARM: 7257/1:
EXYNOS: introduce arch/arm/mach-exynos/common.[ch]") from Linus' tree and
commit 566fcbb817fb ("ARM: EXYNOS: Add DMC1 and allow PPMU access for
DMC") from the s5p tree.

The former removes this file, so the latter patch now needs to be applied
to arch/arm/mach-exynos/common.c (I think).

Maybe the s5p tree should be rebased onto v3.3-rc1 (or merged with it)
since there are other conflicts as well due to duplicated patches (same
patch different commit).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Jan_2012_13_21_23_+1100_q=emRr2hg5=N_8rr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHhWjAAoJEECxmPOUX5FEDk8QAIN4xmLSL9x4WRKgm2QbB2b2
Eknm+5H6150TjXpFDrPY2Dh0mJdOuFc4wpe/WI+m2Eg9cOBikYG2TGxBagSu92Wm
CtIiL+gd5Mr9HlqD1rhdUrOpgcYxhxfSdn9IvpXxMXt3ixhs37CSU4s9635Nv0mw
9osBzFr9joSklnaUAANzXxI6+Kfuazd4RDJP+ccPxIbvSn8PVxm1dDPCJT417UH9
5TfrcoVrHc4CrQg2sUs1ib1tifpgUNY2tIq+5n8xSvP76Tl9YEDlhXCCBHks1+zE
8UZLxumKpUr/fmeGLXpXSCsQYVVTEPUQ54kfePmS0bMPMKxtbUqDxB0V8CpZdzGe
wPrkEJi15NRX9E4dy5qV1Oex7BcBh/0YFWjwKo4u4X1vETA2brsQED2jcWk8GKaG
DdtY1TdoICawvQ0iHu4xbdARHESut2VLCjm4GnkKN0SBc7HbYIKCrwqs94JEYZrq
2wQ02x3DV9KzxiT8jk0enbuhhBTQ9r+jXad0FmmiLWh8tkRg4d/eoVhZJrDN18T1
BqY2hnfHxVUNnIs0MjYL5GDYCmD1Z8hUiHWZ0ATgwP28ri7M6xjBg+LfWPhw6D9T
aZd9WR8T/2nKJza27JHx5IsGzqkHH8UU5SPiJCsFpfrHHblLiGxwNxtUTrDmsi87
YEYMFqvrqyom9kI5HITk
=XPrm
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Jan_2012_13_21_23_+1100_q=emRr2hg5=N_8rr--
