Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2LROpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:45:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18438 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab2LROps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:45:48 -0500
Date: Tue, 18 Dec 2012 09:45:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.8-rc0-bugfix-tag for 3.8.
Message-ID: <20121218144541.GE4518@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.8-rc0-bugfix-tag

which has two fixes. One of them is caused by the recent change introduced
by the 'x86-bsp-hotplug-for-linus' tip tree that inhibited bootup (old function
does not do what it used to do). The other one is just a vanilla bug.

Please pull!

 arch/x86/xen/enlighten.c              |  7 ++++---
 arch/x86/xen/smp.c                    |  2 +-
 include/xen/interface/event_channel.h | 13 +++++++++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

Konrad Rzeszutek Wilk (1):
      xen/smp: Use smp_store_boot_cpu_info() to store cpu info for BSP during boot time.

Wei Liu (2):
      xen: Add EVTCHNOP_reset in Xen interface header files.
      xen/vcpu: Fix vcpu restore path.


--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQ0IGRAAoJEFjIrFwIi8fJ0AMH/2ztTwEJotcMty/TQWHiMXD7
3w8PshmA9v7VJzN2a+l9AWTfIp5yvtGrl9q//o5DINB6TnyUY8ZiWj8JRuqfT9dS
Qnubb8+xmbKUSQq8ML5qJMLOea72OZSGc9qihQx3FdLvf6aCBUZB+WricfU0F9R7
2kO3RVwCo+JgGr5dKL1L4azQPgKDUIUSwSfJnY5pLCxiZYlfRsebjfJcjhKwb2Vq
x0L5o9VfQxrQ+Xsjr993PAR9iLUkOdmkHtWQNIPXPI8SvqRyIsoWL0wq+NRzFYHR
V5RmSkUp9HO0CsYRCPb4TfApFEUBUPSrnYqWTCBXPsmRPhu+lrHGDCEioYc9b8o=
=9fGK
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
