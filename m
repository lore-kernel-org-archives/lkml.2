Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab2EaENj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 00:13:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49608 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2EaENi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 00:13:38 -0400
Date: Thu, 31 May 2012 14:13:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120531141329.6f82889bcfaa30ca83a30937@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_14_13_29_+1000_N2T9wMkkJD.QaJRD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_14_13_29_+1000_N2T9wMkkJD.QaJRD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/memcontrol.c between commit 78ccf5b5ab83 ("mm: memcg: print statistics
directly to seq_file") and others from Linus' tree and commit "memcg: add
mlock statistic in memory.stat" from the akpm tree.

I just dropped the akpm patch for now.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_May_2012_14_13_29_+1000_N2T9wMkkJD.QaJRD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxu/pAAoJEECxmPOUX5FEOl0P/1enCMBmn17UrdGWK+fpd1Do
A3g/8YZiaOQRYRvgvQSfM1KiQWpOcXDCYB7CacAuE4BVZ779kh/uy3sdblygXivu
CcLb+woKrbLoEURD9mndWk8+RA6/2eZlFKHq/sfC5aLmBaw+sEuHOdHFn65sSUEa
+sswaLg6Y37QPf6oI52NRR7cqebia5OhiiqohOSUsGWCyvG+JiWHr9LbuYoXVfyi
q9mSz/mofs4rb9BLDN0oXPbTKfef8YQczkhvzS0v6rkiJn/H9K9L/eG3CwbSVPx9
XGjgQ+3Ju8CrdXClJntkxAd0LloN+GSQy0Ye/dnrW6L3HSVTU/TSDtE3kyVl0Yp+
tPgHmVzRcXMFBjDclYvIpGS3usH5teEsVf9tVbfrkpolYNnshfATZ2N4Xo6Kqfsx
j3HUPCvdLPllrS4UsTTuNA/3VUk3M/Z/UYnN4EZVkWklLyG+2C/2ZBfmm/dZOMZ3
QzL1NosJvBxU+NqLW+/hzsrNpEXeuvscYlVL4alh+9dnSUnaP55Uz+Gn4t4yuhz/
HSOb8/xjr8g1cfKyW6Vp/d1pvZMW+Sy7WcTkqtrRhE3J4Aj1wbGfDkX9fBsmDyLt
tZ1cpiGTB5ujx7Yss2StqLeAFD2ww64A4Tx0kzt6eqhO0XCfe2m1D88429hm8LIZ
/LK3+BtqjSNSVZzftgbG
=uXsA
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_14_13_29_+1000_N2T9wMkkJD.QaJRD--
