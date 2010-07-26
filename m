Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0GZTNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:13:18 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:47857 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0GZTNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:13:17 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm-intel fixes since 2.6.35-rc4
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 26 Jul 2010 12:13:12 -0700
Message-ID: <87eieqf453.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The following changes since commit 815c4163b6c8ebf8152f42b0a5fd015cfdcedc78:

  Linux 2.6.35-rc4 (2010-07-04 20:22:50 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel for-linus

There's been a massive bugfixing spree in the last couple of weeks      .
jbarnes and chris have reviewed this series for sending to you, and I'm
running it on my development system, so I feel pretty good about sending
it despite being at rc6.

Adam Jackson (1):
      drm/i915: Make G4X-style PLL search more permissive

Chris Wilson (4):
      drm/i915: Explosion following OOM in do_execbuffer.
      drm/i915: Clear any existing dither mode prior to enabling spatial di=
thering
      drm/i915: Use the correct scanout alignment for fbcon.
      drm/i915: Fix panel fitting regression since 734b4157

Jesse Barnes (7):
      drm/i915: handle shared framebuffers when flipping
      drm/i915: add PANEL_UNLOCK_REGS definition
      drm/i915: make sure eDP panel is turned on
      drm/i915: disable FBC when more than one pipe is active
      drm/i915: don't free non-existent compressed llb on ILK+
      drm/i915: fix deadlock in fb teardown
      drm/i915: add pipe A force quirks to i915 driver

Thomas B=C3=A4chler (1):
      gpu/drm/i915: Add a blacklist to omit modeset on LID open

Tim Gardner (1):
      agp/intel: Use the correct mask to detect i830 aperture size.

 drivers/char/agp/intel-gtt.c         |   13 +++--
 drivers/gpu/drm/i915/i915_debugfs.c  |    3 +
 drivers/gpu/drm/i915/i915_dma.c      |    2 +-
 drivers/gpu/drm/i915/i915_drv.h      |    5 ++
 drivers/gpu/drm/i915/i915_gem.c      |    3 +-
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |  109 ++++++++++++++++++++++++++++++=
----
 drivers/gpu/drm/i915/intel_dp.c      |   53 ++++++++++++++++-
 drivers/gpu/drm/i915/intel_drv.h     |    3 +
 drivers/gpu/drm/i915/intel_fb.c      |    4 +-
 drivers/gpu/drm/i915/intel_lvds.c    |   23 +++++++
 11 files changed, 197 insertions(+), 22 deletions(-)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxN3kkACgkQHUdvYGzw6vfLzQCaA+ijYSe8luv/U2Ugt3pfxM4S
JJ4AnAu/gh2eo1V0dCLIu7ZUG+Cx4ET/
=bDbl
-----END PGP SIGNATURE-----
--=-=-=--
