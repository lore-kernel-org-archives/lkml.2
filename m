Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872Ab1FYEMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 00:12:19 -0400
Received: from home.keithp.com ([63.227.221.253]:55288 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1FYEMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 00:12:17 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 24 Jun 2011 21:11:57 -0700
Message-ID: <yunhb7eblde.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here's a few minor fixes for the intel drm driver.

This should fix:

 * Lost interrupts on Sandybridge from the BSD ring
 * Sandybridge forcewake error during suspend/resume
 * Performance regression due to discarding GTT mappings
 * Broken 9xx display at startup due to lost call to intel_enable_plane

The following changes since commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f:

  Linux 3.0-rc4 (2011-06-20 20:25:46 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-fixes

Ben Widawsky (1):
      drm/i915: save/resume forcewake lock fixes

Chris Wilson (1):
      drm/i915: Apply HWSTAM workaround for BSD ring on SandyBridge

Eric Anholt (1):
      Revert "drm/i915: Kill GTT mappings when moving from GTT domain"

Keith Packard (1):
      drm/i915: Call intel_enable_plane from i9xx_crtc_mode_set (again)

 drivers/gpu/drm/i915/i915_gem.c            |   10 ++++------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    4 ----
 drivers/gpu/drm/i915/i915_irq.c            |    1 +
 drivers/gpu/drm/i915/i915_reg.h            |    1 +
 drivers/gpu/drm/i915/i915_suspend.c        |    5 +++++
 drivers/gpu/drm/i915/intel_display.c       |    3 +--
 6 files changed, 12 insertions(+), 12 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOBWAOQp8BWwlsTdMRAuskAJ9DOSsroK76OXEXTeGJOpQotT6bzgCeJanV
7V/jdG/8+PfwtimyTU5k0Cs=
=jLku
-----END PGP SIGNATURE-----
--=-=-=--
