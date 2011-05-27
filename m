Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1E0G7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:59:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48628 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab1E0G7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:59:31 -0400
Date: Fri, 27 May 2011 16:59:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: linux-next: build warning after merge of the final tree (ext3 tree
 related)
Message-Id: <20110527165906.97310c97.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_May_2011_16_59_06_+1000_=I6/hHar=ZMnpQhY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_May_2011_16_59_06_+1000_=I6/hHar=ZMnpQhY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (gcc 4.5.2, powerpc
ppc44x_defconfig) produced this warning:

fs/ext3/inode.c: In function 'ext3_get_blocks_handle':
fs/ext3/inode.c:976:8: warning: array subscript is below array bounds

Introduced by commit 20024a79a97b ("ext3: Add fixed tracepoints").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_May_2011_16_59_06_+1000_=I6/hHar=ZMnpQhY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN30u6AAoJEDMEi1NhKgbsu4MIAJ63R3JyriV1vLofHa/PTg4u
WRIZACPKuA62fIakLatq712zSdPio03OzBSuRiQwuHw3II1CuFBr4GRtj2xJYU0r
FdIhEJcnuX8jLMyfUbJ6JjIwdrfzX4Tzar3Ie0WXfvbgi9qVHU2kGXnwC7ljKAUC
JqenSF2D+VNl33tAItSsUzmdObcUcq41zxIKmfZbeTgCuAtlR9ip/Fxrcj6jshMn
VNMN4nCJXzGXDxC4nn8ySPgOhI1202pjFwLx3gu2TYoYc2j5QdOdWCnz+rtsPtJ/
GczU6DeLQt03UANtaA98FjOt2wPaTV1T8SscuRMcL9hNLfpqNXKhBnCv3JyxyBU=
=6DX/
-----END PGP SIGNATURE-----

--Signature=_Fri__27_May_2011_16_59_06_+1000_=I6/hHar=ZMnpQhY--
