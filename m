Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2DANPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:15:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40637 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2DANPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:15:12 -0400
Date: Sun, 1 Apr 2012 23:14:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next stats (Was: Linux 3.4-rc1)
Message-Id: <20120401231454.c06bf099eff31002e1b02f58@canb.auug.org.au>
In-Reply-To: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__1_Apr_2012_23_14_54_+1000_0_zxHSrRzwtLs8.C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__1_Apr_2012_23_14_54_+1000_0_zxHSrRzwtLs8.C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

All these stats are relative to next-20120319 (the last before v3.3).
Also merge commits are excluded.

Commits in next-20120319 (relative to v3.3):	9444
Commits in v3.4-rc1 (relative to v3.3):		9248
Commits in v3.4-rc1 common with next-20120319:	6847	74.03%
Further commits with the same patch_id:		 935	10.11%	(1)
Further commits with the same subject:		  63	 0.68%	(2)
Total (close to) common patches:		7845	84.82%

Non common patches:				1403	15.17%

(1) would include quilt trees and rebased git trees.
(2) would include some patches that have been fixed up (in Andrew's case
some of these fixes have been in linux-next as follow up patches).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__1_Apr_2012_23_14_54_+1000_0_zxHSrRzwtLs8.C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPeFTOAAoJEECxmPOUX5FE1gUP/10n7RO3/EBi+c2adRZ2f93h
dhJQhsrSd+hkzCK/i2NbIuiTXrWXxBcDegekdYHS09HuX1O7F0tftgrihpUXMIM7
N8ajGyCrMUJwIrP10EFlrsWWmepyzk9JZoj8SMasXGwv/zbvFFBRfceFJ3jtFPzO
98No8ZSLOmHc7z5P30TtP6+g51TK2ihUGwK3KhjF/aYZfK4+UL09dn1VRzIJb37D
qakA3jJZH1NbFW3wo3DF+POZYL1KAIhWAytKseLqzlNR5Vta8Lbnb3GWbi8yqo73
Bc+TGSFoAPEFzyJrKqSbw0a3CIiuKAefG8DrsSgdSC6udvoYeemOuSLIvaObX0D+
mlHaP8hKSeDr3Rqp15P8Mt6beXvScFLm5o469ebFLUsl48WSE4oEEYVqjyL2VNib
I//PiZ04LjfzDeoTvX9KAgRnZoIjHjcFrywMx/nvt2DhndPVTiQ/prcb/0aft3cg
wRz/bagsBIydWFmlV5dgWaVsncO2Bm6EarRGBeyB/cca48xE83+pM5yPtKpwNtVR
F6iUWN+W9nBK0z3oP9q71Pg59sMT6PlwnMsopjpX6YRtcotjYrc8mQcr4M9rBCno
WGrEWxNcfyVE0/mRpxNRv1gFn9EAROsMBxP169iz75GKo+0UvavkcGwvGCuNvRa2
pFs/NlMa+2a1utdgAzB2
=suDp
-----END PGP SIGNATURE-----

--Signature=_Sun__1_Apr_2012_23_14_54_+1000_0_zxHSrRzwtLs8.C--
