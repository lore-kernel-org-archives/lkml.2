Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829Ab2JLEAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 00:00:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45469 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2JLEAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 00:00:45 -0400
Date: Fri, 12 Oct 2012 15:00:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20121012150041.5831853d10f2ef0694a5d2f4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_15_00_41_+1100_lPcjTWelnPo_Tyst"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_15_00_41_+1100_lPcjTWelnPo_Tyst
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/m68k/kernel/process.c between commit 2a5e5beb88c5 ("vfs: define
struct filename and have getname() return it") from the vfs tree and
commit d878d6dacee2 ("m68k: switch to generic sys_execve()/kernel_execve()")
from the signal tree.

The latter removed the function that the latter modified, so I did that
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_15_00_41_+1100_lPcjTWelnPo_Tyst
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd5XpAAoJEECxmPOUX5FE17kP/RT9fHq3Vu/dxDoNWCeFs+cy
J7YzWP13aW8ig2FIbNJj9NxKi8M5dncLDcGtkCVMzp1V2MwiXTE93BSYJFnJ78dh
Z3i9TP6kk/At7YMMgH4wMBOYoUj/mXvJhYdgpameOEITkLNUahjxYE/nXLjokKqd
v5M+qv23h58+li09wdXIOA++43R/2Q+wIiANwTNT+IGAVeQQKHVT1ChhizsRj4bz
X4vI2PJCHP/zHm4wM/BWmsrarJLwnPH5xcbStLdZRQVwNWPJzn2S3SGJlg2h0/Om
WipTgRHjJZyA59Ku6d+3CiazG83vI0IgBgCRpnIPFuyLMTRoOJ84sam5VA5P2cHm
W4ZVpbI/qA5tUrtJdQxKcH6zNoJMldrj8+zJ27ACSf5hHNsMsbVIDvbsyuVYXvqD
Wg2k0RCfyN4aWa3nG6IkOVAmAzNp3i0w4qLBxz0ILBVlzG0j6/PplsAZpOUlaq7o
p5X/Bg2ZRt91E4qRsYhU2Sj+pObJOxrO5q5EAeOvy9ItOK/FQWwj6QO6cUHPoWpt
CXMD8Rwc12it2cOQGxR+GgJZh0p4EbKuqeGlCFMBskIvMGRsaoAqgLhbVDZnB8f0
J71kF9IBSgdFPzIGCeB2U620+vqSRElfpl/r7yxnRaFdU54xMJLmelicF1xvr9+R
YFMe0p3mmA3LtbikswjQ
=A0Xt
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_15_00_41_+1100_lPcjTWelnPo_Tyst--
