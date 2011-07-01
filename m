Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab1GAXFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:05:05 -0400
Received: from home.keithp.com ([63.227.221.253]:39573 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914Ab1GAXFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:05:03 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 01 Jul 2011 16:04:59 -0700
Message-ID: <yuny60ha9gk.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Another forcewake fix, a NULL pointer oops, some error-path cleanups, a
UMS for IRL fix and another IVB fix. The UMS for IRL fix (from Jesse)
contains a bunch of code motion, hence the fairly large
diffstat. Otherwise, these are all tiny fixes.

The following changes since commit 0d72c6fcb5cd215eeab824fac216ea42c5b574aa:

  Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kern=
el/git/keithp/linux-2.6 (2011-06-28 11:15:57 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-fixes

Ben Widawsky (1):
      drm/i915: Don't call describe_obj on NULL pointers

Chris Wilson (1):
      drm/i915/overlay: Fix unpinning along init error paths

Jesse Barnes (2):
      drm/i915: move IRQ function table init to i915_irq.c
      drm/i915: apply HWSTAM writes to Ivy Bridge as well

Keith Packard (1):
      drm/i915: Hold struct_mutex during i915_save_state/i915_restore_state

 drivers/gpu/drm/i915/i915_debugfs.c  |   16 ++++---
 drivers/gpu/drm/i915/i915_dma.c      |   31 +-------------
 drivers/gpu/drm/i915/i915_drv.c      |    8 ---
 drivers/gpu/drm/i915/i915_drv.h      |   32 +-------------
 drivers/gpu/drm/i915/i915_irq.c      |   80 +++++++++++++++++++++++++-----=
----
 drivers/gpu/drm/i915/i915_suspend.c  |   19 ++++++---
 drivers/gpu/drm/i915/intel_overlay.c |   17 ++++---
 7 files changed, 94 insertions(+), 109 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFODlKbQp8BWwlsTdMRAp9tAJ9wjYbfX2fQa0fZFgN8r9wB7GIeJwCgzzfV
s5pfrFO0tdawc9C2y1CpftU=
=H2RJ
-----END PGP SIGNATURE-----
--=-=-=--
