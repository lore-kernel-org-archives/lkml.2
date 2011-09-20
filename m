Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab1ITD4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:56:04 -0400
Received: from home.keithp.com ([63.227.221.253]:35417 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab1ITD4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:56:02 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel drivers <Intel-gfx@lists.freedesktop.org>
Subject: [PULL] drm-intel-next
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 19 Sep 2011 20:55:57 -0700
Message-ID: <yunfwjrhnoy.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


This is a single patch which cleans up almost all of the whitespace
errors in the i915 driver. It currently merges cleanly with your fdo
drm-core-next tree.

I've checked this patch quite carefully, examining the .o files with
objdump -s to make sure nothing significant changed. The only thing that
found was a couple of debug messages which had blank space before newlines.

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~keithp/linux drm-intel-next

Akshay Joshi (1):
      Drivers: i915: Fix all space related issues.

 drivers/gpu/drm/i915/dvo_ch7017.c       |    2 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c       |    4 +-
 drivers/gpu/drm/i915/dvo_ivch.c         |    6 +-
 drivers/gpu/drm/i915/dvo_sil164.c       |    2 +-
 drivers/gpu/drm/i915/dvo_tfp410.c       |   14 +-
 drivers/gpu/drm/i915/i915_debugfs.c     |   38 +-
 drivers/gpu/drm/i915/i915_dma.c         |   44 ++--
 drivers/gpu/drm/i915/i915_drv.c         |   16 +-
 drivers/gpu/drm/i915/i915_drv.h         |   70 ++--
 drivers/gpu/drm/i915/i915_gem.c         |   12 +-
 drivers/gpu/drm/i915/i915_gem_debug.c   |    2 +-
 drivers/gpu/drm/i915/i915_gem_evict.c   |    2 +-
 drivers/gpu/drm/i915/i915_irq.c         |    6 +-
 drivers/gpu/drm/i915/i915_mem.c         |   14 +-
 drivers/gpu/drm/i915/i915_reg.h         |    8 +-
 drivers/gpu/drm/i915/i915_suspend.c     |    8 +-
 drivers/gpu/drm/i915/i915_trace.h       |   46 ++--
 drivers/gpu/drm/i915/intel_acpi.c       |    2 +-
 drivers/gpu/drm/i915/intel_bios.c       |    4 +-
 drivers/gpu/drm/i915/intel_bios.h       |    2 +-
 drivers/gpu/drm/i915/intel_crt.c        |    2 +-
 drivers/gpu/drm/i915/intel_display.c    |  222 ++++++------
 drivers/gpu/drm/i915/intel_dp.c         |   26 +-
 drivers/gpu/drm/i915/intel_drv.h        |   12 +-
 drivers/gpu/drm/i915/intel_opregion.c   |   90 +++---
 drivers/gpu/drm/i915/intel_overlay.c    |  146 ++++----
 drivers/gpu/drm/i915/intel_panel.c      |    6 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c |   76 ++--
 drivers/gpu/drm/i915/intel_ringbuffer.h |    8 +-
 drivers/gpu/drm/i915/intel_sdvo.c       |  228 +++++++-------
 drivers/gpu/drm/i915/intel_sdvo_regs.h  |  558 +++++++++++++++------------=
---
 drivers/gpu/drm/i915/intel_tv.c         |   58 ++--
 32 files changed, 867 insertions(+), 867 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOeA7NQp8BWwlsTdMRAl3kAKDlWPoCwBrs63PnBTMIMhhWny+PXACfeLhl
eRSAMcDerI+amcSSVJ+30FU=
=c7+B
-----END PGP SIGNATURE-----
--=-=-=--
