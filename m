Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1L0Xdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:33:53 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37372 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1L0Xdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:33:50 -0500
Date: Wed, 28 Dec 2011 10:33:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Rajeshwari Shinde <rajeshwari.s@samsung.com>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111228103349.32f3e490c087d3345f038873@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_10_33_49_+1100_niPYlkN4mJy+Fg4l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_10_33_49_+1100_niPYlkN4mJy+Fg4l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s5p64x0/cpu.c between commit 95af214becab ("ARM: 7246/1:
S5P64X0: introduce arch/arm/mach-s5p64x0/common.[ch]") from the arm tree
and commit ebc433c2890f ("ARM: S5P64X0: Add HSMMC setup for host
Controller") from the s5p tree.

I just removed the file, but the s5p tree patch may need applying to
arch/arm/mach-s5p64x0/common.c.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_10_33_49_+1100_niPYlkN4mJy+Fg4l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+lXdAAoJEECxmPOUX5FEQgIP+wTsoZtHQZ1nUe4OL0jzqmS4
L8QuoN961BuSzeQYVCmPxjmR8arWGrdieTgXeD/I3pVKEWKpmjfz4negluVTwfq1
1CN2CJggS4YtoNpIOk3Xz9x9b544xucjmTCCX0342/+emGb6cJIGm/53ySwTVe/m
LEbTj6FBjA3rd3oJeliZBDbkm7e/6lKMvxj2n56u0hB6iL3wgg1PkKF1DIwxUF1e
2m41CbwQA0SvvY+J8ZuCVCuE7crNtFT7DL81c2ixImIzXbGl0w6Gp+5px43/fW6Y
2/Dltd3A8IvUJKVHxo2pf7GrIT2yBz2DTzqNebbwib0f3lzc9Z0MbRhH1ANTs2PQ
LxwofwvjHCBsyru2b1rSWRv6fluvLrmyR4cG4tZgoJImyDIwMRQP86D3jdEgnkyU
006jq1Yb0wAcYiVQmIn5q0Oy1EHVjqyOrggNGoUZn6IojE0U/Qgx/71gad96RRpH
BQVgQcvpIqdIW0qCro6VOp/hE8m8ns8KAtwoCDj/qs6mhsiOOzWOEP/jX4c94jhS
ggydsMfksigqM66CocQN5ObPByGHbA2UkacPWk3CMp4VKtoYiPX6hf/LIW68J/Ai
f6wAZssmd6FQnD1zWF9Hc1XNkiFeq+h6BJi9UpDBzwUgvZGEhtfar1iA0hk3T0kc
aDC4LSON4ZxNEwzhxFWy
=ENU1
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_10_33_49_+1100_niPYlkN4mJy+Fg4l--
