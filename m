Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2GUX5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 19:57:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54848 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2GUX5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 19:57:01 -0400
Date: Sun, 22 Jul 2012 09:56:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the vfs tree with the nfs tree
Message-Id: <20120722095651.ab20a748e1c22fad075890f3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__22_Jul_2012_09_56_51_+1000_4J.nqYp_CehaqkMx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2012_09_56_51_+1000_4J.nqYp_CehaqkMx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got conflicts in fs/cifs/dir.c,
fs/nfs/dir.c, fs/nfs/nfs4proc.c, ipc/mqueue.c, fs/open.c and fs/namei.c
between commits from the nfs tree and commits from the vfs tree.

These were all caused by the rebase of the vfs tree after it had been
merged into the nfs tree.  This is one reason you should not rebase a
published tree (especially so close to the merge window).

I fixed up all the conflicts which meant taking some files from one tree
and some from the other.  Now, unless the nfs tree is rebuilt (and tested
etc) we will have duplicates of a large number of patches in Linus'
tree :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__22_Jul_2012_09_56_51_+1000_4J.nqYp_CehaqkMx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQC0HDAAoJEECxmPOUX5FET4EP/jXnGocHw98ob5moAEZQz5fr
SvkVx56dDJe5mHUsx9C43nJWqmWUUtXeMxGydeDLugX7EmtWnll4fJfu1j42h+sI
4oufzWTQ+fK3hkbAY3io4+z7hesoSTOdJpLP286UXPQAY1+kCLKHx4Uf9zn/LpS8
sMwcqFj5jDr4Z3iE5Gh3ovepaQzHFEz6U+zb/d0+yEFaAQYwEHCCPgDaLDuNyHSk
ACGtjuxjAbb4xg/EDvUS7amCvdq8oW5bdKqNdMkoV5q8YfAkoITlpK0Rfv2Actvz
iRIqGvbG7ALXdwKhS4rq8ynF2g8gWuoTws8vi6MHWZcz3XcqyfuLmQAze9mayyLM
f7/CpdbgfZf8KTF8pusfbuqDCvQHS6KB03tdczfBYXZ4Hqk/7uW6Vts8pyHVfJs2
i+wolaQq9pkKSm5it8fOAXvSwG9ET/YRvha5ZnJY22m/dnmeT5EZ4Jik7xBDf0dl
cZucXtkypZDdnMt984P5mGCCN3HJTfAH63KNPLqVIdlfDw1F5E3m5Jt2O5faRiqT
5q0I87pocDot2R0DRtWcXyo3GtlcZyzoHzgbpJ/ir/Te3Ly22pT3Sf6LOSHBaa0i
FzJDctNU7SgZrXo2tC+V+D0M8xYe/uucybblvjRrv0tSTu7iPandbQaG0RF7olsc
ERyKFVevR7wEnrIx8JoN
=NAcW
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2012_09_56_51_+1000_4J.nqYp_CehaqkMx--
