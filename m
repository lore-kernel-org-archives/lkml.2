Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2EJDBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:01:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34873 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2EJDBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:01:46 -0400
Date: Thu, 10 May 2012 13:01:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the xfs tree
Message-Id: <20120510130134.0efffc5ba1f3a80c614e8f29@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".xfs_extent_busy_trim" [fs/xfs/xfs.ko] undefined!

Caused by commit e459df5b5b93 ("xfs: move busy extent handling to it's
own file") (and aided by 425dcd6c2289 "xfs: clean up busy extent naming").

I have used the xfs tree from next-20120508 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPqy+OAAoJEECxmPOUX5FEg74QAJVF0uhoISzQGp4g9eRqPPNG
R+FBKOkg0mFwSJz0LoOke7jM+xrvaYm9qGSVXXJkvp1kl0H0Q+H9If1fnaRKrWHh
ttVWh2RN7FmhvLjDcr+iLJqj4e/sZTfDPlcEb1n1w9P0zV/lIZl3ly6PJT4TbzJ8
kLUGtUwHIKW4BD0GQ4SVppHp10El5Hdlr5iAH8ZuUM0IL6H6oEsZowD2iNWXJu07
OThDTpGQd3MutBtJto/ahXSUmDXLVIF/ZtyAWWXrrDEZZrAef0SYoANRUih8tJyd
HaAFMKW2u22/5tWZxcA5xuSJFYKzWr1i2Y7l7MEiGTS+JW87kgz1XcykLLY1t4zk
4RtkEEif+Rq9fHtASTPWyep68K1xYJaczH63G3/aiAPqMI5H0QHr81m1rWglE/hy
9u+kS3tDMJWQmkGJrCwiWsc/zSWXh1rbuJ5j3FWdCPqiiOuPYusLM256H8AO9I+4
mcUkeGhYT2IjsD5MwFlvSEnOhyELRWIvL6HYwvObZOMtBkhMRRfOByvwasAuw/mV
rP3l+/MfzL1KHjzCPgD8ZAGd1wcFTr30+PvL6libBi4YWjujrpXocrvrEZe0YYEB
pFEVUrENqFmq6Irnq9J2JPf/ygLB3nYvLkbqk8i5mJ8taCcEH+SXhAQ4N71BKeQ7
yhZy1IC1IZwgh2/hWQuh
=QHex
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq--
