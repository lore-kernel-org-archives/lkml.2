Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0D3Qsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:48:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab0D3Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:34 -0400
Date: Thu, 29 Apr 2010 16:14:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: linux-next: build warning after merge of the block tree
Message-Id: <20100429161442.7a0a4285.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Apr_2010_16_14_42_+1000_c+CzC06X+zni7a3I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Apr_2010_16_14_42_+1000_c+CzC06X+zni7a3I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the block tree, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

block/blk-lib.c: In function 'blkdev_issue_zeroout':
block/blk-lib.c:190: warning: comparison of distinct pointer types lacks a =
cast

Introduced by commit 3f14d792f9a8fede64ce918dbb517f934497a4f8 ("blkdev:
add blkdev_issue_zeroout helper function").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Apr_2010_16_14_42_+1000_c+CzC06X+zni7a3I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvZI9IACgkQjjKRsyhoI8xjfgCcCmxyUkDIkgHcrPsFRdsr67Fr
FWsAoK7j+21OeC/eT51YzGZZ7g7AXMn3
=AXII
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Apr_2010_16_14_42_+1000_c+CzC06X+zni7a3I--
