Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab2CTCOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 22:14:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55317 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384Ab2CTCOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 22:14:36 -0400
Date: Tue, 20 Mar 2012 13:14:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weston Andros Adamson <dros@netapp.com>
Subject: linux-next: build warning after merge of the nfs tree
Message-Id: <20120320131427.b166ba88d4ea86cea3ec8d7f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Mar_2012_13_14_27_+1100_lDFFRlPUlSWdYknZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Mar_2012_13_14_27_+1100_lDFFRlPUlSWdYknZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced lots of this warning:

include/linux/nfs_fs.h: In function 'nfs_display_fhandle_hash':
include/linux/nfs_fs.h:416:1: warning: no return statement in function retu=
rning non-void [-Wreturn-type]

Introduced by commit d8e0539ebdff ("NFS: add filehandle crc for debug
display").  But made obvious by commit 855fa894a2b2 ("SUNRPC/NFS: Add
Kbuild dependencies for NFS_DEBUG/RPC_DEBUG").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Mar_2012_13_14_27_+1100_lDFFRlPUlSWdYknZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZ+gDAAoJEECxmPOUX5FEbwwP/11bpEdNujL/IORj2uOEuZwJ
JenRgENzKBYhNAkZjOL9fJ3173cyBMWJnuDDdE60Z8NNHBmonw6hhXEQRfyk0rZe
ywGdTjI/3eRTlr2D6N/el94Sg9gD3m/2Fnh533xF8roo4xqDoQ+UeXmFlSIQ20qA
HNVAh0J79W0G2QfRoLkMITGwYzVW9UXhFLNwRWVVKrnnkKp+xzGDhGJqdkX+ZEqe
d+uPaW69yRtQuOzQeSNolyfDxmJUm8/DZYm1TXUPMFEZC8JfFTGkaxJMgh8dW+5j
kaHHOFnRMCF6MEMTs/ws0d1Kqro3oRERSJqCp7wsB1Bus2ht+hAn2TtON0Mv9O49
ef22dbBza31iykKtgCf+zfbcKuU/daT80Kgk5/66Yp3I45FOokqEZWLMYxKvSgqj
GowAsQ4P4owfGMdx2/cwQ3TtFftLAxXa2gpyzB+Ir0yQdCiIfd2McGCPyoxRAD3I
YEa1g+8gvXZia0HqxbLZ+4qp2EiLvGNXfxHWBFK8K8F+IzzJwcpKdhjcs1vkOBJp
q04r8TCZp6cS0Bj1WY3ES433fXhieWzae+HrzQUrfgo1K+zUXlK+SicnpID83kHp
5IsC0MQhvLHI4NOgijLkMH6RV1i1sQE2xpgPBgTpGsn7qcPVEOjy60p/j1CPFyEL
YhzASI+E8yvtH6sj2Zdh
=+/iJ
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Mar_2012_13_14_27_+1100_lDFFRlPUlSWdYknZ--
