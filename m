Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2HWVT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:19:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32114 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab2HWVTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:19:25 -0400
Date: Thu, 23 Aug 2012 17:09:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.6-rc3-tag
Message-ID: <20120823210915.GA25652@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please pull this following git tag:

git pull  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.6-rc3-tag

which has three bug-fixes. The tag has a brief writeup of what they are - but
basically one is a revert for a that went in v3.6 and is not yet ready. The
other two are fixes  - one for a one-off bug that has been for some time in the
kernel. The other is a fix for code that went in v3.5.

Please pull and here is an double-checked output:


 arch/x86/xen/enlighten.c   |  118 ++++---------------------------------------
 arch/x86/xen/p2m.c         |   95 ++++++++++++++++++++++++++++++++++-
 arch/x86/xen/setup.c       |    9 +++-
 arch/x86/xen/suspend.c     |    2 +-
 arch/x86/xen/xen-ops.h     |    2 +-
 drivers/xen/platform-pci.c |   15 ------
 include/xen/events.h       |    2 -
 7 files changed, 113 insertions(+), 130 deletions(-)

Konrad Rzeszutek Wilk (3):
      Revert "xen PVonHVM: move shared_info to MMIO before kexec"
      xen/p2m: Reuse existing P2M leafs if they are filled with 1:1 PFNs or INVALID.
      xen/setup: Fix one-off error when adding for-balloon PFNs to the P2M.


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQNpvsAAoJEFjIrFwIi8fJAOYH+wYTi6aVft6X3MeWRaNZFkBs
ZtlK0NZGmT7Mv57LeLN/6GzFRVA/jD28z3khNOJMTcbwA6sx4I1c1fdcFY37ZZ02
1/nnKSRvFvAR9aiuUr8pRbJ2rmXBd5mQuQACzLSlKCqL0slqyaiIkZjhMcxfzBBa
bCTpVj3g6LJAL3XefHpP9MwkEszqHDj9aJFjzOIp3lOdih+SV52pqmpGKZUeLXv3
MUZME+D/A67HVVgSYGkBf245bqGaQq3me683W5VBc4Q+/5UTB3vXJOmw6wYhyida
UJFrJT258Ib0IvQW1wAAOOIbnPOpSHqDy+1RMrc6+5ytXlayaXLDsRdfKFO7M4c=
=nohE
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
