Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab1LGUyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:54:17 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37709 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab1LGUyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:54:16 -0500
Date: Thu, 8 Dec 2011 07:54:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the memblock tree
Message-Id: <20111208075405.911cefd2ee3c2ed81cdc5f4b@canb.auug.org.au>
In-Reply-To: <20111206143808.3fa5f3785538a37c9686734d@canb.auug.org.au>
References: <20111206143808.3fa5f3785538a37c9686734d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Dec_2011_07_54_05_+1100_O4iM2CW8HhXlAxs2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Dec_2011_07_54_05_+1100_O4iM2CW8HhXlAxs2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 6 Dec 2011 14:38:08 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the memblock tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> arch/powerpc/mm/numa.c: In function 'get_node_active_region':
> arch/powerpc/mm/numa.c:143:11: error: dereferencing pointer to incomplete=
 type
> arch/powerpc/mm/numa.c:144:11: error: dereferencing pointer to incomplete=
 type
> arch/powerpc/mm/numa.c:145:11: error: dereferencing pointer to incomplete=
 type
> arch/powerpc/mm/numa.c: In function 'mark_reserved_regions_for_nid':
> arch/powerpc/mm/numa.c:960:29: error: storage size of 'node_ar' isn't kno=
wn
> arch/powerpc/mm/numa.c:960:29: error: unused variable 'node_ar' [-Werror=
=3Dunused-variable]
> cc1: all warnings being treated as errors
>=20
> Caused by commit 9d0d131f9f6d ("memblock: Kill early_node_map[]") which
> seems to have misspelled CONFIG_HAVE_MEMBLOCK_NODE_MAP as
> CONFIG_MEMBLOCK_HAVE_NODE_MAP in include/linux/mmzone.h.
>=20
> I have dropped the memblock tree for today - we can try again tomorrow.

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Dec_2011_07_54_05_+1100_O4iM2CW8HhXlAxs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO39JtAAoJEECxmPOUX5FENrYP/iSXC6VOB7PXRm2Wo1OG8QW6
Y0g9KGL7L1uCq/pOJ71CTwgde3XGLPzLZw+7Ald5VDPtL4KBoqo354J5xxU/XGOW
Xqjwz3UOrKXHv2ZBjrgg8XgL4mHxcamldsQrTcGDzb+6grm+eWRfEfm7wFJcjPX/
CQRwqAsfa5s0TvdvOnYvJvgu6Ce7KZO7QX7ihgThTnY//IXeRbnYlMISbHhsCwzk
SNuhG5kPiOFXG6on8zT3o7VZdZ1Om6KMRC1w+92SuI3KUmqyZjV5OvpKHvyjATan
kLk77cRJurwLHp99OBFn46NiBB3t5TkMjzPMgPcCgHoN0hHGwNwYZqN04QH7pP/u
7+a/hKhMHjvRzc+BQ9Ae7j78J8IKpJvzMGrgcZ4eXyC5Obj2XCjo5t3z6i7BDIV3
O4AYLFUc6qXWiUrc3W8OiuoPfnOkp8UisyFFxwOOVLeL7arm2Yv36q/odqlTvpWL
khRxfxif7I5kZ4JeqIu+p8f4mn9A92NeghvpJJjrO1S7Z6VW8uBDuGEm5VFvAheI
P5LMueCCirX5qlRNDPCmdBiwu73/PohLI0F7zvZRNFkGABvbemkAGaOK3fV4GCMX
DWKCV1b74wPSx+FSc8vD8nefXZjuOpYBy6xLLfXoHSqO4vJMRNdIqddWFxk+rEoe
ch9CQrDt09HCWoSmDaYv
=q47H
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Dec_2011_07_54_05_+1100_O4iM2CW8HhXlAxs2--
