Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0CXRiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:38:20 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:45761 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab0CXRiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:38:18 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes for 2.6.34-rc1
Date: Wed, 24 Mar 2010 10:38:15 -0700
Message-ID: <87fx3pfwmw.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

The following changes since commit a3d3203e4bb40f253b1541e310dc0f9305be7c84:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6

This is the set of stuff I've queued since rc1.  The most important
change here is removing the ACPI lid status check that's breaking so
many people's laptops -- the majority of patches I've had this cycle is
people quirking away specific laptops.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

Chris Wilson (1):
      drm/i915: Avoid NULL deref in get_pages() unwind after error.

Dan Carpenter (1):
      drm/i915: fix small leak on overlay error path

Daniel Vetter (1):
      drm/intel: fix up set_tiling for untiled->tiled transition

Eric Anholt (6):
      drm/i915: Don't bother with the BKL for GEM ioctls.
      drm/i915: Enable VS timer dispatch.
      agp/intel: Respect the GTT size on Sandybridge for scratch page setup.
      agp/intel: Don't do the chipset flush on Sandybridge.
      drm/i915: Set up the documented clock gating on Sandybridge and Ironlake.
      drm/i915: Stop trying to use ACPI lid status to determine LVDS connection.

Joe Perches (1):
      drivers/gpu/drm/i915/intel_bios.c: fix continuation line formats

Owain G. Ainsworth (1):
      drm/i915: remove an unnecessary wait_request()

Priit Laes (1):
      drm/i915: Rename FBC_C3_IDLE to FBC_CTL_C3_IDLE to match other registers

Zhenyu Wang (1):
      drm/i915: Fix check with IS_GEN6

 drivers/char/agp/intel-agp.c           |   34 +++++++++++++++++++--
 drivers/gpu/drm/i915/i915_dma.c        |   46 ++++++++++++++--------------
 drivers/gpu/drm/i915/i915_drv.c        |    4 +-
 drivers/gpu/drm/i915/i915_drv.h        |    4 +-
 drivers/gpu/drm/i915/i915_gem.c        |   31 ++++++++++--------
 drivers/gpu/drm/i915/i915_gem_tiling.c |    7 +++-
 drivers/gpu/drm/i915/i915_reg.h        |   14 ++++++++-
 drivers/gpu/drm/i915/intel_bios.c      |    5 ++-
 drivers/gpu/drm/i915/intel_display.c   |   16 +++++++++-
 drivers/gpu/drm/i915/intel_lvds.c      |   52 +-------------------------------
 drivers/gpu/drm/i915/intel_overlay.c   |   13 +++++--
 11 files changed, 121 insertions(+), 105 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuqTgcACgkQHUdvYGzw6veyugCfV3agtSN2h7ofBU88bgz84qVL
OKoAnicxPx7zOZYy0H5tqHERa/X4BWEc
=xDrp
-----END PGP SIGNATURE-----
--=-=-=--
