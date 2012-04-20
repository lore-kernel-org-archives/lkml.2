Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2DTQWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:22:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24198 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2DTQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:22:49 -0400
Date: Fri, 20 Apr 2012 12:17:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.4-rc3-tag
Message-ID: <20120420161746.GA28366@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4F918D58.007F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag for v3.4-rc4:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.4-rc3-tag

which has a some compile warning fixes and mechanisms to work
around misbehaving backends. Also there is fix to the internal
mechanism for dealing with pages brought in from a guest (and
one fix that I had to revert last minute). Lastly a fix from Julia
to return proper error code.

Please pull!

Julia Lawall (1):
      xen/grant-table: add error-handling code on failure of gnttab_resume

Konrad Rzeszutek Wilk (4):
      xen/blkback: Fix warning error.
      xen/xenbus: Add quirk to deal with misconfigured backends.
      xen/resume: Fix compile warnings.
      Revert "xen/p2m: m2p_find_override: use list_for_each_entry_safe"

Stefano Stabellini (2):
      xen/gntdev: do not set VM_PFNMAP
      xen/p2m: m2p_find_override: use list_for_each_entry_safe

 drivers/block/xen-blkback/xenbus.c         |    2 +-
 drivers/xen/gntdev.c                       |    2 +-
 drivers/xen/grant-table.c                  |   13 ++++--
 drivers/xen/manage.c                       |    1 +
 drivers/xen/xenbus/xenbus_probe_frontend.c |   69 +++++++++++++++++++++------
 5 files changed, 65 insertions(+), 22 deletions(-)

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPkYwmAAoJEFjIrFwIi8fJYksH/0PixxaeMs0QyNw8Pa2lm98n
iDAsCdXCiO06p1FqiBD+BOJDBheqhB1l13jxQln0NjFG4kFiVQcygxPOxdeZAN9u
6BTFQE0d2Ox81YXkvP57gqC5KEX/0xBtE7bQ4gn648dNj5c5TAcx4qYdbYrWoh92
hIv5wA9H2pA2BjM7E0Hhowe3AcQ59IioLFtF3/rviB0rqB105eWRjQUW74Mb3lXY
F5nHDbIIlzG8dCEQ/xrxo5nbfQszVru57q67mIY8gp6PepquuC5PvpZuiUxz/9n8
WtPS7L8OLq/Rdsi064ZTiWYNokVKzvOkW3iGhQUdd/EBuhGs/ZxZyJ1a3OVorNg=
=PGfF
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
