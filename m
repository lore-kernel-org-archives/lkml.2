Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2CWU7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:59:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58139 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2CWU7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:59:12 -0400
Date: Fri, 23 Mar 2012 13:59:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.26
Message-ID: <20120323205908.GA32316@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.26 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                     |    2 -
 arch/powerpc/platforms/powermac/smp.c        |    2 -
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    7 +++---
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    2 -
 fs/afs/internal.h                            |    2 -
 fs/afs/rxrpc.c                               |    3 ++
 fs/nilfs2/the_nilfs.c                        |    1=20
 net/ipv4/syncookies.c                        |   30 ++++++++++++++--------=
-----
 net/ipv4/tcp_ipv4.c                          |   10 ++++++---
 net/ipv6/mcast.c                             |    1=20
 tools/perf/util/sort.c                       |    3 ++
 11 files changed, 38 insertions(+), 25 deletions(-)

Anton Blanchard (3):
      afs: Read of file returns EBADMSG
      afs: Remote abort can cause BUG in rxrpc code
      perf tools: Incorrect use of snprintf results in SEGV

Benjamin Herrenschmidt (1):
      powerpc/pmac: Fix SMP kernels on pre-core99 UP machines

Eric Dumazet (1):
      tcp: fix syncookie regression

Greg Kroah-Hartman (1):
      Linux 3.0.26

RongQing.Li (1):
      ipv6: Don't dev_hold(dev) in ip6_mc_find_dev_rcu.

Ryusuke Konishi (1):
      nilfs2: fix NULL pointer dereference in nilfs_load_super_block()

Stanislaw Gruszka (1):
      iwl3945: fix possible il->txq NULL pointer dereference in delayed wor=
ks


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPbOQcAAoJEDjbvchgkmk+3dQP/iL9IlSnk+2wdoqVWZEDdPqP
IlekzngDkxU5ObArCqUZRRLPxYHPE1dsQpSRejfmCj0zZRrK/kw1+rZgClXlxzNg
GJmI28pzXlfThIXbruWUT7uX9/2f6GTTUuHhr9R1rBTOW0Q5L0cR6vqs+4j6OYSv
pWTgpvAv61bBdfFLyEHs3aWGmaWdfheUWYqGNrQ6n1rTjZriSsa/dDdmAQYFRcxW
eOeKvzBwM/s6Ilk7UCMp6wctTG9ThAM+c0Q1W6Tty4LGbYCZ4ipqXX6HjmYRd1Sp
aXQ4vHA1p5eVrb3oNQuqCZIus4yDUBiMdg4Lua/je2S0s9O2uK3pGYWehhqvbHKc
05WDOiEjTkqdMMBAco0IWDNX7dATxu753N59tLdcySFQ+omFvBxsXmwD+dw6/mvC
3qkqPhEohV7mqCKOzNV8oYiEWBk/NhukabLE1Q4ecJgCplsmb5EdGp31bmq9FFsN
6MWzgZy7VFCdY0l9+O1j8B0VcNn7tn777mNF/AOvLeF5bQAhp9RZV7vuh+tR8y8J
gmeUKsXAG7769ZMLWEKyDWsLImalvoAB+1/lkkRueNKV6Ml8UvrTvb7FEOs4muxQ
Yi4/Gjg9TBMQPac6N0JUM2D2KeaclbPoY1j4DeSqo3fHXZ5j1jRaXqr3yB8uW5lL
xvTi4jTu5uexY8nQ/zXy
=TJPK
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
