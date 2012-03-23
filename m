Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab2CWVAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 17:00:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51897 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2CWU77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:59:59 -0400
Date: Fri, 23 Mar 2012 13:59:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.13
Message-ID: <20120323205956.GA32369@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.13 kernel.

All users of the 3.2 kernel series must upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
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
 tools/perf/arch/powerpc/util/header.c        |    2 -
 tools/perf/arch/x86/util/header.c            |    2 -
 tools/perf/util/color.c                      |    9 ++++----
 tools/perf/util/header.c                     |    4 +--
 tools/perf/util/hist.c                       |   30 +++++++++++++---------=
-----
 tools/perf/util/sort.c                       |    3 ++
 tools/perf/util/strbuf.c                     |    7 +++---
 tools/perf/util/ui/browsers/hists.c          |   12 +++++-----
 tools/perf/util/ui/helpline.c                |    2 -
 19 files changed, 73 insertions(+), 58 deletions(-)

Anton Blanchard (3):
      afs: Read of file returns EBADMSG
      afs: Remote abort can cause BUG in rxrpc code
      perf tools: Incorrect use of snprintf results in SEGV

Arnaldo Carvalho de Melo (1):
      perf tools: Use scnprintf where applicable

Benjamin Herrenschmidt (1):
      powerpc/pmac: Fix SMP kernels on pre-core99 UP machines

Eric Dumazet (1):
      tcp: fix syncookie regression

Greg Kroah-Hartman (1):
      Linux 3.2.13

RongQing.Li (1):
      ipv6: Don't dev_hold(dev) in ip6_mc_find_dev_rcu.

Ryusuke Konishi (1):
      nilfs2: fix NULL pointer dereference in nilfs_load_super_block()

Stanislaw Gruszka (1):
      iwl3945: fix possible il->txq NULL pointer dereference in delayed wor=
ks


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPbORMAAoJEDjbvchgkmk+HP8P/iVq5PESITCIbk4umb3bwT91
7CQ3Xvh3qZ15GEAjSynynFN9P58WhiVShR0g1c7Ejg7dNMed9XHaJT6yGqxZGGXH
p/78hmCXHC/hXmAQFFV0FHa88sg3Mx0KsUGRLiYUH5f/2Pi+L8NU4fXVISW9Vau0
9qhp5R9cuwUkO8Wh55LyUChAY/jYcrj8OBOQBlB22z17q4sx9xwsEgqqEfwymMgP
wFQ9P88QkovSSk8OwAMdbsM+wael0OmuAHprKU9YdCE+LFug3SdaegTJgKUFJ8v5
iQHXWmp0VRjnY5EQyCJ2W4fjXHrdy6dlgaYJcM/r+xfwAoMMQ0y2F34iQ1FmPfSt
sn2iIAJHQcp9fzfZfZw2roLXWYHxINd9+XCv5l+3CLsHHejF/AX/T2XwdjTLLYdU
cS98ROUtgblOgZt6a7DWQfjAITOxddDhup7xN4JoWp4LsDZQzl3KCP7jwccf+nJ4
dY1h/hWq6WqK0d9uk8sJkTcBHHdP9M/+Vf12FIYdSCCimHS4xaQQ5ruUjy9WPBA0
DfgIpe2CMjedKwWa+6RWAU4VeNC4SwbBSrbtrPtQZGKijAVyi/fBKy2sinpLgYvn
TINLnNzDHSmkd1m/PJCj0VvmdQfy+/smzP2zdBxrMCUaHuUP6idDOcPDoVcpQ+/2
DRVtF6U5xS7GqBQE/G53
=+imi
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
