Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1FCXkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:40:12 -0400
Received: from home.keithp.com ([63.227.221.253]:36004 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1FCXkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:40:10 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PULL] drm-intel-next
In-Reply-To: <yun39k2gku4.fsf@aiko.keithp.com>
References: <yunr57z3b58.fsf@aiko.keithp.com> <yunfwodyom6.fsf@aiko.keithp.com> <yuntycs7v7z.fsf@aiko.keithp.com> <yun39k2gku4.fsf@aiko.keithp.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 03 Jun 2011 16:40:06 -0700
Message-ID: <yunei3apjqh.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here's another handful of fixes that I had merged to
drm-intel-next. Once these are merged, I'll move drm-intel-fixes and
start putting stuff there for 3.0.

The following changes since commit 9e3c256d7d56a12a3242222945ce8e6347f93fa0:

  drm/i915: initialize gen6 rps work queue on Sandy Bridge and Ivy Bridge (=
2011-05-18 15:14:39 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-next

Chris Wilson (5):
      drm/i915: s/addr & ~PAGE_MASK/offset_in_page(addr)/
      drm/i915: Replace ironlake_compute_wm0 with g4x_compute_wm0
      drm/i915/crt: Explicitly return false if connected to a digital monit=
or
      drm/i915: Remove unused enum "chip_family"
      drm/i915: Share the common force-audio property between connectors

Dan Carpenter (1):
      drm/i915: fix if statement in ivybridge irq handler

Daniel Vetter (3):
      drm/i915: Only print out the actual number of fences for i915_error_s=
tate
      drm/i915: not finding a fence is a non-recoverable condition
      drm/915: fix relaxed tiling on gen2: tile height

Jason Stubbs (1):
      drm/i915: fix regression after clock gating init split

Nicolas Kaiser (1):
      drm: i915: correct return status in intel_hdmi_mode_valid()

 drivers/gpu/drm/i915/i915_debugfs.c  |    2 +-
 drivers/gpu/drm/i915/i915_drv.h      |    8 +---
 drivers/gpu/drm/i915/i915_gem.c      |   28 +++++-----
 drivers/gpu/drm/i915/i915_irq.c      |    2 +-
 drivers/gpu/drm/i915/intel_crt.c     |    4 ++
 drivers/gpu/drm/i915/intel_display.c |   89 ++++++++----------------------=
----
 drivers/gpu/drm/i915/intel_dp.c      |   15 +-----
 drivers/gpu/drm/i915/intel_drv.h     |    1 +
 drivers/gpu/drm/i915/intel_hdmi.c    |   16 +-----
 drivers/gpu/drm/i915/intel_modes.c   |   30 +++++++++++
 drivers/gpu/drm/i915/intel_sdvo.c    |   14 +-----
 11 files changed, 80 insertions(+), 129 deletions(-)


=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN6XDWQp8BWwlsTdMRAoVvAKCudSYIz0pR6aRmq186V8n0KQd1CgCggEAB
fRf8+9zYDefAGo2jcEtLwLM=
=s3fB
-----END PGP SIGNATURE-----
--=-=-=--
