Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab1L1Hyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 02:54:52 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:49985 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1L1Hyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 02:54:49 -0500
Date: Wed, 28 Dec 2011 18:54:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20111228185438.63b46e806d8e11310b34ec9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_18_54_38_+1100_DHNbhTbdaUak/y2S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_18_54_38_+1100_DHNbhTbdaUak/y2S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/lglock.h between commit e30e2fdfe562 ("VFS: Fix race
between CPU hotplug and lglocks") from Linus' tree and commit
"brlocks/lglocks: clean up code" from the akpm tree.

Given the extent of the conflict and that this patch also conflicts in
several other files (fs/dcache.c, fs/file_table.c, fs/namei.c,
fs/namespace.c - presumably against the vfs tree), I have dropped this
patch (and the following
"brlocks-lglocks-clean-up-code-checkpatch-fixes") from the akpm tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_18_54_38_+1100_DHNbhTbdaUak/y2S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+ss+AAoJEECxmPOUX5FE9bAP/A0xGFMWdkIl/tIj8X0CxwmS
WxwGRsu0VYYfG34vpzQQW4V2dd0Kr307FvyH7heruP8/pat13pGLIvU08iordwgm
2Iq2Xcpwj6DNGW9FOYobAFf+CTnUyoGC+t6mFYlT3TWB73vNnjbTXHSYIMOoQO0a
YjE7gRNaFwbDZbpAA51IufDRAlwOs8qynspuamxwJbfTdacYZqUhS9p8LR91W2Mx
UVGslr1nEBkwY7A5ruK/b1rX5RiI1RgsdC++UeALVSvAqUOyRNkJ+ROaunq88BY/
gSS55mtqyqMAQcWzOmSi+V2bsWd4eQH76Emdf+8Jg7ks7k1ob8T+a/NW/8CTgsgf
1VzG9aXdG6wc3iF8LRZ2gwz2Y6CWC2TGA3FmaYgoHKgmpInqtYdc/atHnYx1cPwh
SsmVkk+zMUhP1pnKGsbGxr6O6MTlLkASOWAlZQHR+RHv3V8uTgI0IsMK3fIY3CLF
U7SLg/5bzCk6itgHCS4enmy039pgfWIWO7WUIBGbzinLnCQnE60YgWuLFGHgx6R8
3tE9BgyGaDsUiDOSna1WDVSx/qzB9H/B30qyHJ28tLm32joYZGN8jaCSs4ipjl2g
sON3SXocvu0zufGNodumIDhVq4eHICY9G/Ne6QKhOPd7HFOV0WOhwN8aue3yAU25
cAwFKOO72me6BwIMxssP
=YpGt
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_18_54_38_+1100_DHNbhTbdaUak/y2S--
