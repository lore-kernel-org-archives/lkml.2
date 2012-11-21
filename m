Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2KUCqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:46:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2KUCqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:46:08 -0500
Date: Tue, 20 Nov 2012 21:46:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.7-rc6-tag
Message-ID: <20121121024528.GA11912@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.7-rc6-tag

A fix for a regression introduced in v3.7-rc0 by git commit eb90fa0
(xen/privcmd: add PRIVCMD_MMAPBATCH_V2 ioctl).

 drivers/xen/privcmd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Mats Petersson (1):
      xen/privcmd: Correctly return success from IOCTL_PRIVCMD_MMAPBATCH


--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQrEBlAAoJEFjIrFwIi8fJliEH/RX+ObjKIfn4vlB/6qG3d36a
ji9dzQCiPpizJMuW8EKQyyYfRFOBiCO9wp81HomBN/e6OILVSLWqqGKUT402HKID
dbowrlW6Um5EgMmKBEl1Jrs3SUjPw977xmTP0Vhz1n8xvyWTDCXXq851ybVkbcO+
+EjK3E7EJn631EMX3ZLWm+D/lODUOR2JIj3JDPNe+OvrBp7vcAk5hUJ1jXcv3tYn
+0L1An2+N+UOaSSAZNknM+YrLL4hbIPkGrdgFVYeqK6+H08A4Hi3lEuNKCAxxeQT
8T8mYorBWCV4rahv5xzlSUNpSwKUpEPD3JACbUy/lKvBLv6JeHdbMKZm47X9Xc0=
=zT9a
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
