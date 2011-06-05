Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1FEFsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 01:48:35 -0400
Received: from home.keithp.com ([63.227.221.253]:34338 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1FEFse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 01:48:34 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 04 Jun 2011 22:48:30 -0700
Message-ID: <yunoc2comkx.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Mostly mode setting cleanups and fixes.

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-fixes

Chris Wilson (5):
      drm/i915: s/addr & ~PAGE_MASK/offset_in_page(addr)/
      drm/i915: Replace ironlake_compute_wm0 with g4x_compute_wm0
      drm/i915/crt: Explicitly return false if connected to a digital monit=
or
      drm/i915: Remove unused enum "chip_family"
      drm/i915: Share the common force-audio property between connectors

Dan Carpenter (1):
      drm/i915: fix if statement in ivybridge irq handler

Daniel Vetter (2):
      drm/i915: Only print out the actual number of fences for i915_error_s=
tate
      drm/915: fix relaxed tiling on gen2: tile height

Hans de Goede (1):
      drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

Jason Stubbs (1):
      drm/i915: fix regression after clock gating init split

Nicolas Kaiser (1):
      drm: i915: correct return status in intel_hdmi_mode_valid()

 drivers/gpu/drm/i915/i915_debugfs.c  |    2 +-
 drivers/gpu/drm/i915/i915_drv.h      |    8 +---
 drivers/gpu/drm/i915/i915_gem.c      |   26 +++++-----
 drivers/gpu/drm/i915/i915_irq.c      |    2 +-
 drivers/gpu/drm/i915/intel_crt.c     |    4 ++
 drivers/gpu/drm/i915/intel_display.c |   89 ++++++++----------------------=
----
 drivers/gpu/drm/i915/intel_dp.c      |   15 +-----
 drivers/gpu/drm/i915/intel_drv.h     |    1 +
 drivers/gpu/drm/i915/intel_hdmi.c    |   16 +-----
 drivers/gpu/drm/i915/intel_lvds.c    |    8 +++
 drivers/gpu/drm/i915/intel_modes.c   |   30 +++++++++++
 drivers/gpu/drm/i915/intel_sdvo.c    |   14 +-----
 12 files changed, 87 insertions(+), 128 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN6xiuQp8BWwlsTdMRAqkAAJ9jx9TCodVjdnDd3AW5T6uDWSqQMQCeOyzF
EYZHBqI1eORaTiEGxLtqSp4=
=xmTu
-----END PGP SIGNATURE-----
--=-=-=--
