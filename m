Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2AEDfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:35:48 -0500
Received: from home.keithp.com ([63.227.221.253]:54588 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757845Ab2AEDfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:35:46 -0500
From: "Keith Packard" <keithp@keithp.com>
To: "Airlie\, Dave" <airlied@linux.ie>
Subject: [PULL] drm-intel-next
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel drivers <Intel-gfx@lists.freedesktop.org>
Date: Wed, 04 Jan 2012 19:35:41 -0800
Message-ID: <86y5tmkeia.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here are the rest of the 3.3 pending changes.

This has a bunch of small bug fixes and overlay plane support for i915.

The following changes since commit 7a7e8734ac3235efafd34819b27fbdf5417e6d60:

  Merge branch 'drm-radeon-testing' of ../drm-radeon-next into drm-core-nex=
t (2012-01-03 09:45:12 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux drm-intel-next

Ben Widawsky (4):
      drm/i915: relative_constants_mode race fix
      drm/i915: Force sync command ordering (Gen6+)
      drm/i915: Update GEN6_RP_CONTROL definitions
      drm/i915: drpc debugfs update for gen6

Daniel Vetter (2):
      drm/i915: kicking rings stuck on semaphores considered harmful
      drm/i915: don't bail out of intel_wait_ring_buffer too early

Eric Anholt (5):
      drm/i915: Set two chicken bits implicated in missed IRQs on Ivybridge.
      drm/i915: Do the fallback non-IRQ wait in ring throttle, too.
      drm/i915: Work around gen7 BLT ring synchronization issues.
      drm/i915: Make the fallback IRQ wait not sleep.
      drm/i915: Add support for resetting the SO write pointers on gen7.

Jesse Barnes (5):
      drm/i915: add SNB and IVB video sprite support v6
      drm/i915: track sprite coverage and disable primary plane if possible
      drm/i915: add color key support v4
      drm/i915: don't disable a PCH DPLL that's in use
      drm/i915: only set the intel_crtc DPMS mode to on if the mode set suc=
ceeded

Keith Packard (1):
      drm/i915: Clean up multi-threaded forcewake patch

 drivers/gpu/drm/i915/Makefile              |    1 +
 drivers/gpu/drm/i915/i915_debugfs.c        |   86 ++++-
 drivers/gpu/drm/i915/i915_dma.c            |    5 +
 drivers/gpu/drm/i915/i915_drv.c            |    7 -
 drivers/gpu/drm/i915/i915_drv.h            |    6 +-
 drivers/gpu/drm/i915/i915_gem.c            |   10 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   63 +++-
 drivers/gpu/drm/i915/i915_irq.c            |    7 -
 drivers/gpu/drm/i915/i915_reg.h            |  161 +++++++-
 drivers/gpu/drm/i915/intel_display.c       |  206 ++++++++-
 drivers/gpu/drm/i915/intel_drv.h           |   40 ++
 drivers/gpu/drm/i915/intel_fb.c            |    6 +
 drivers/gpu/drm/i915/intel_ringbuffer.c    |   30 ++-
 drivers/gpu/drm/i915/intel_sprite.c        |  668 ++++++++++++++++++++++++=
++++
 include/drm/i915_drm.h                     |   40 ++
 15 files changed, 1290 insertions(+), 46 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/intel_sprite.c

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTwUajTYtFsjWk68qAQjt/g//QqxHT9g9J3CXebo69qjipMBqc9YrX/8g
5ggWKvdkexE0Jl9HWVEuaqU5GUsmxkr0nR8xSfQbcxO6Trin/kpiTUCVWCxC5HAy
15K0Ikv0IFzys0+ELVc8TCtD947AfdgsvygxF77GeEJU0QHHE8hNFecQhAC0AEcy
9ws9gHJiI4kWaKrva9DtwCLsELj9qVCNK6pKlqZzfukGOQ/BeoLsElLMJpmJ97Xq
8T1GfqAv/oEyXQYmAgk0IbXERCVvFQWNhERcnNlxBzXsAgG0u2fHtZu4U0H2gCCQ
tBH+PIB0eF1mwFMFv1GivPveCKoXt9haE6ikL6Ity6RS1RHyZb/tsUAtMawYbNy1
aUfuCBuBiOgLLss6cx25aNaWV4N3qxStAjo5VB+A3/zSOBMqTFdEu6EwgDeb4tmh
d8KXKKuw/Y2hyQybupwo4Em1hT8Fwft9Z9MTy83h3kBcaDgS4I2BSQHNscjsqLtC
NKSpO/ueDZ0TbUz4ny4FTmmbABOaQhJ60qIBRHaHNCL4NK91kM3otyd6eVdfDxr/
QJeEjAzT6lTu0aeymvuz6NYVzovjqxvzAE8JLe9P/Lpt1F2xxg8vIrvSIi2teszo
GOW7JyRCGuULyJneYqPxlL+35fOfvkcfaCKUrWLg5jxDmh8Yx/0xWC31PKUoIJd8
LpU034tGERU=
=31zv
-----END PGP SIGNATURE-----
--=-=-=--
