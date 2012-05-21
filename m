Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2EUIOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:14:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48550 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab2EUIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:13:56 -0400
Date: Mon, 21 May 2012 18:13:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120521181347.51d96de343880746c9b285b4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_18_13_47_+1000_7LwTjl.3ia6kKmOP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_18_13_47_+1000_7LwTjl.3ia6kKmOP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/proc/base.c between commit eb94cd96e05d ("fs, proc: fix ABBA deadlock
in case of execution attempt of map_files/ entries") from Linus' tree and
commit "proc: unify ptrace_may_access() locking code" from the akpm tree.

I used the version of the conflicting code from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_18_13_47_+1000_7LwTjl.3ia6kKmOP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPufk7AAoJEECxmPOUX5FErrwP/2PiGWJ9Lb65/+cTt8uGchKy
F/4hsLPZz7IGYXmaifYsOZrw7LAWNhardCaZJtnI5ruk2kHBrVLLfJMdlSsl3R8C
7iS4/qNzC7+btJtT7hOrDzrr3t1JyabPDVbb9Xu4wdBYnWX/wClaB7BXa/tux32L
vGUaGxR8oSDJO7/izAvL3V+50T+gxVKg4R2/ahmQL0jpQ4VIdDiIeQBpcxu8WET7
IpT9U6dd7N5JyBrQFrUWeUJtstHvGQxQlEM8ueMPztWOvOhBmJU4439NEBQGjfSu
UPXBQ8FXWur/3TgkrFXiXoltmcMbjJLt1HSxlgBNRhX8yMG49M8yHKIAY8btcCDd
9XK/bV22JiVVoK0s2jFyY9vkt4R580j4B9Cr94JOtByvgJzI2CDetrZHdBijrEfm
vQz2sBcEoP6YX9PXzJ57c0FwvEZrvOLpibaVtqaNyaAJMPQuGWVNHiueZCPdWIlJ
gBkTx/a4MbQcnOFNWJmuQcYno4tIvYk0FC4Y16yNOE7WXDo7xSZK0pK2AiImMzzM
5YrDnTxY3vIJyIFKZfvGw+A9S2flo7kKdoiH3Y2I3xs61OsxeQ3w3aLd4vPesR+2
S8xrHH2rpFLyS4K0VJTsWYJ1FySBBL+GzaugVfS20thwLPL1wU7hQ5yQkb9YL3wr
MneL9g7aPXZE9BPBylLX
=hmrw
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_18_13_47_+1000_7LwTjl.3ia6kKmOP--
