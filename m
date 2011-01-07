Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1AGDEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:04:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52398 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab1AGDEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:04:23 -0500
Date: Fri, 7 Jan 2011 14:04:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: linux-next: build warnings after merge of the final tree (ext3 tree
 related)
Message-Id: <20110107140414.43d5b980.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Jan_2011_14_04_14_+1100_.EPpf+g2_I7yzAJl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jan_2011_14_04_14_+1100_.EPpf+g2_I7yzAJl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) produced these warnings:

fs/ext3/balloc.c: In function 'ext3_get_group_no_and_offset':
fs/ext3/balloc.c:53: warning: comparison of distinct pointer types lacks a =
cast
fs/ext3/balloc.c:53: warning: right shift count >=3D width of type
fs/ext3/balloc.c:53: warning: passing argument 1 of '__div64_32' from incom=
patible pointer type
include/asm-generic/div64.h:35: note: expected 'uint64_t *' but argument is=
 of type 'ext3_fsblk_t *'

Caused by commit 3e5eb5c509e311fdea2468be913ec264edd4f617 ("ext3: Add
batched discard support for ext3").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Jan_2011_14_04_14_+1100_.EPpf+g2_I7yzAJl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJoKuAAoJEDMEi1NhKgbsdCAIAIDuEGuN/p52szV6V2REkk8B
H1wusQ8JlUxUw6uuLSdU61vTuHVVjvtOZXWINzsd0hjJsIRypYDWm+WNIOrA6of3
IEKP6d6KLWb9qNUKsFag/LWfTpiE5Ifd7nee6uPCbqhPDrWvlbqwGuGn+ATAV2dd
htj10uLFOfIFv1Laq8SI3l20w6fvkaIhZSWVJE4bIjrD3AWxyrkrnBsOkeX50xq9
Rox4iOQPlh3O8JdYNgYx6JYLKTVQh3h0hisNl++j9gw9+5JMlHFwBr/25gRhnoGN
fYUNEvXpFvci0CW2lqvTwJuGxgnx2/QAqR9gX/JmRfkBkhDSamUt2yZqTtdVhKI=
=X3kk
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jan_2011_14_04_14_+1100_.EPpf+g2_I7yzAJl--
