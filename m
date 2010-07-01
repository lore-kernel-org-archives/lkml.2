Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab0GAXdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:33:53 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:45826 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0GAXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:33:52 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes since 2.6.35-rc1
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Thu, 01 Jul 2010 16:33:43 -0700
Message-ID: <87iq4ykca0.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh=
/powerpc (2010-06-01 14:13:14 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

The last pull request didn't seem to stick, so trying again.  The
highlight here I'd say is EDP panel setup fix, which is making a lot of
newer hardware work it looks like.

Adam Jackson (1):
      drm/i915/gen4: Fix interrupt setup ordering

Andy Lutomirski (1):
      drm/i915: Fix CRT hotplug regression in 2.6.35-rc1

Carl Worth (1):
      Revert "drm/i915: Don't enable pipe/plane/VCO early (wait for DPMS on=
)."

Chris Wilson (2):
      drm/i915: Move non-phys cursors into the GTT
      drm/i915: Account for space on the ring buffer consumed whilst wrappi=
ng.

Dan Carpenter (1):
      drm/i915: take struct_mutex in i915_dma_cleanup()

Dave Airlie (1):
      i915: fix ironlake edp panel setup (v4)

Dave M=C3=BCller (1):
      drm/i915: Use RSEN instead of HTPLG for tfp410 monitor detection.

Jesse Barnes (4):
      drm/i915: don't queue flips during a flip pending event
      drm/i915: gen3 page flipping fixes
      drm/i915: don't access FW_BLC_SELF on 965G
      drm/i915: change default panel fitting mode to preserve aspect ratio

Li Peng (1):
      drm/i915: Turn on 945 self-refresh only if single CRTC is active

Prarit Bhargava (1):
      drm/i915: fix uninitialized variable warning in i915_setup_compressio=
n()

Zou Nan hai (1):
      drm/i915: Fix incorrect intel_ring_begin size in BSD ringbuffer.

 drivers/gpu/drm/i915/dvo_tfp410.c       |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c     |    2 +-
 drivers/gpu/drm/i915/i915_dma.c         |    8 +++-
 drivers/gpu/drm/i915/i915_drv.h         |    3 +-
 drivers/gpu/drm/i915/i915_irq.c         |   76 ++++++++++++++++++---------=
----
 drivers/gpu/drm/i915/i915_reg.h         |    5 ++-
 drivers/gpu/drm/i915/intel_crt.c        |    6 ---
 drivers/gpu/drm/i915/intel_display.c    |   74 +++++++++++++++++++++++++--=
---
 drivers/gpu/drm/i915/intel_dp.c         |   27 ++++++++++-
 drivers/gpu/drm/i915/intel_drv.h        |    1 +
 drivers/gpu/drm/i915/intel_lvds.c       |    4 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |   10 +++--
 12 files changed, 154 insertions(+), 64 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwtJdcACgkQHUdvYGzw6vcZNwCfVy1FjC4dCQxfmnyhaPsoaXgU
iyEAoIkDkvi6FRZcEstaPj79yrwPI2z0
=XO+A
-----END PGP SIGNATURE-----
--=-=-=--
