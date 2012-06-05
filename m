Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2FEXBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:01:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab2FEXB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:01:29 -0400
Date: Wed, 6 Jun 2012 09:01:13 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux RAID <linux-raid@vger.kernel.org>,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PULL REQUEST] md fixes for 3.5-rc
Message-ID: <20120606090113.07c78064@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dbfA5hYzufi4TAR0+cGkz6F"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dbfA5hYzufi4TAR0+cGkz6F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 a couple of little md fixes for 3.5.
Thanks,
NeilBrown


The following changes since commit 1e2aec873ad6d16538512dbb96853caa1fa076af:

  Merge branch 'generic-string-functions' (2012-05-26 16:57:16 -0700)

are available in the git repository at:


  git://neil.brown.name/md/ tags/md-3.5-fixes

for you to fetch changes up to aba336bd1d46d6b0404b06f6915ed76150739057:

  md: raid1/raid10: fix problem with merge_bvec_fn (2012-05-31 15:56:30 +10=
00)

----------------------------------------------------------------
md: 2 fixes for 3.5-rc

One sparse-warning fix, one bigfix for 3.4-stable

----------------------------------------------------------------
Jim Kukunas (1):
      lib/raid6: fix sparse warnings in recovery functions

NeilBrown (1):
      md: raid1/raid10: fix problem with merge_bvec_fn

 drivers/md/raid1.c      |    4 ++++
 drivers/md/raid10.c     |    4 ++++
 lib/raid6/recov.c       |    7 ++++---
 lib/raid6/recov_ssse3.c |    7 ++++---
 4 files changed, 16 insertions(+), 6 deletions(-)

--Sig_/dbfA5hYzufi4TAR0+cGkz6F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT86PuTnsnt1WYoG5AQJDyQ//XdufTOXoRhRK4iOFGDa/k2MZJb/HgkIi
xbD1yBypyd86JzdY6W+zGhZ4La+AeC8+uPRncrmLVmHyXIfPRNZtbWu9fIP9p1vU
lZqA4FmCfhmMb3OBupelsj5/4RGCx2cUyBC/jgH4YoCw6sjJ4EbWX/TOoyWrvvzs
iS6zjzpbnForUQynWQRKeaCjBknGYCBUaf5wAR12odxnl+N45FMHW4ic4ONjM3RJ
SNMg22ZEXC0YK/JXKIykh568vH2c+L9l6/dik3uB7sr7BVmSmJdgApqEhDoRD2Xk
05VMv/xB3/3Z5WDwDIda8xF7wcS0GpIcELRIqZjcBjmkeLVzvpJoBUWKbkEVWQYl
8ERdv8ukheNtpaAjX+7/fOP2pobLbYBFmBnQPjxM8wM4qIj+EuVdJXAA9vpAswt/
SRVleLkyfEM/G7UcSQgD4pr8HpSxmARrWw20QTnJhf/fzZIzUb4L94e/apTSesAF
157rkJI8H5KcESsjuXRcVJSXRCQMOoA4v1KYk1shLKTz/E/S+dCaVVQEXwP0VolB
5R92hZSjMWMmGR6uXB5XlB+BTZbF7nzOd5IMIAYmlrtPvVnIrm9dkMYr0jX443Vn
jV+RTC2SPdvHNNncnCZT1kVc3UZ/nWlqRXvEaKxtja8OOVpDUqyKjwY7EtQjKbba
TtnR/yOxnrc=
=1RHl
-----END PGP SIGNATURE-----

--Sig_/dbfA5hYzufi4TAR0+cGkz6F--
