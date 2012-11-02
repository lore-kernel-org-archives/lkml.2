Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab2KBPoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:44:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33072 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab2KBPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:44:12 -0400
Date: Fri, 2 Nov 2012 11:44:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.7-rc4-tag
Message-ID: <20121102154332.GA3923@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stabl=
e/for-linus-3.7-rc4-tag

which has the following fixes (copy-n-paste from the signed tag):

<tag>
Bug-fixes:
 * Use appropriate macros instead of hand-rolling our own (ARM).
 * Fixes if FB/KBD closed unexpectedly.
 * Fix memory leak in /dev/gntdev ioctl calls.
 * Fix overflow check in xenbus_file_write.
 * Document cleanup.
 * Performance optimization when migrating guests.
</tag>

Nothing major - rather just incremental fixes.
=20

 arch/arm/xen/hypercall.S                 | 14 +++++--------
 arch/x86/include/asm/xen/hypervisor.h    |  1 -
 arch/x86/xen/mmu.c                       | 21 ++++++++++++++++++-
 drivers/input/misc/xen-kbdfront.c        |  5 ++++-
 drivers/video/xen-fbfront.c              |  5 ++++-
 drivers/xen/gntdev.c                     | 36 +++++++++++++++++-----------=
----
 drivers/xen/xenbus/xenbus_dev_frontend.c |  2 +-
 include/trace/events/xen.h               |  8 +++++++
 8 files changed, 61 insertions(+), 31 deletions(-)

David Vrabel (3):
      xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF
      xen-fbfront: handle backend CLOSED without CLOSING
      xen-kbdfront: handle backend CLOSED without CLOSING

Jan Beulich (1):
      xen/xenbus: fix overflow check in xenbus_file_write()

Konrad Rzeszutek Wilk (1):
      xen/mmu: Use Xen specific TLB flush instead of the generic one.

Olaf Hering (1):
      x86: remove obsolete comment from asm/xen/hypervisor.h

Stefano Stabellini (1):
      xen/arm: use the __HVC macro


--3siQDZowHQqNOShm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQk+pDAAoJEFjIrFwIi8fJAScIAKuc0wQbCHv9kJZzzMphc9e+
Uf55JXpHOrXFykRlXADwrhws6Oav2x60Y1A4iImegGZMh0DC05TP74sGPuyhuJLx
EfBEiHKNCnBvvzu7f1NjyirFP37Is/atnaTbXKPm76mR8iEQWhKfm+kIVIl0uXG1
X9DM6lkyTIK8eCXO5/pIfPLyUvRYsMcx6wnb4MC+IPY57dGpNRIYdLfRXXykGjQZ
ILJSc9q1QYGvlFeP65++PlDe8c2a8D+upBZTrKOfJb/6yfUtwC30/tQ3uT/CSuZ5
yFKsH6eF1DykJ3R2iYD/iqzfZiC7Lx/anQQ7yQqjIHx3Bg7pWUVMc0zk9i/fdi8=
=Otce
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
