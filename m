Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab2BNEoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 23:44:13 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19113 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2BNEoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 23:44:12 -0500
Date: Mon, 13 Feb 2012 23:41:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-fixes-3.3 or
 stable/for-linus-fixes-3.3-rc3 (tag) for 3.3-rc3
Message-ID: <20120214044103.GA24072@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F39E696.0045,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-fixes-3.3-rc3

or if I screwed up the tagging, the following branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-fixes-3.3

which has two fixes for VCPU offlining; One to fix the string format exposed
by the xen-pci[front|back] to conform to the one used in majority of
PCI drivers; two fixes to make the code more resilient to invalid configurations.

Jan Beulich (1):
      xenbus_dev: add missing error check to watch handling

Konrad Rzeszutek Wilk (3):
      xen/bootup: During bootup suppress XENBUS: Unable to read cpu state
      xen/smp: Fix CPU online/offline bug triggering a BUG: scheduling while atomic.
      xen/pci[front|back]: Use %d instead of %1x for displaying PCI devfn.

Stefano Stabellini (1):
      xen pvhvm: do not remap pirqs onto evtchns if !xen_have_vector_callback

 arch/x86/pci/xen.c                       |    2 +-
 arch/x86/xen/smp.c                       |    7 +++++++
 drivers/pci/xen-pcifront.c               |   10 +++++-----
 drivers/xen/cpu_hotplug.c                |    3 ++-
 drivers/xen/xen-pciback/pci_stub.c       |    8 ++++----
 drivers/xen/xen-pciback/xenbus.c         |    5 +++--
 drivers/xen/xenbus/xenbus_dev_frontend.c |    4 ++++
 7 files changed, 26 insertions(+), 13 deletions(-)

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPOeXaAAoJEFjIrFwIi8fJYJYH/ibaujA2OsQR7XRdS8XCK9Kq
XynnOgv0qFWFu0anPpU8gbxNxps/2pVByeILdDeVUVbx1kNnwyYkGyWm5PiUBMcv
Za0W/vlcFm78FUBMp8r9jPfwLNagmuKw/Z53ad8ojnTsERcQ+Ca6KR4RIsVoVqoP
v1/F9a3bWrlWYP32qt3AOTibkoHn8jI25RqdSM5w53/ZosRBBLxMGV51bG2zN0v3
RCzkkYV3RJGPuad0hYHHrVTevrsDE3MXBArmwzu5JTmwwU0GpvnP0z3IMg4xrAN3
QYACMFpnWexZ/9dgP/tsfJlEbq41X3wl+TAg27QBS5JjhHidru2hCm8wj+X7R3I=
=V3bN
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
