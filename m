Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1I3BSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:18:20 -0400
Received: from home.keithp.com ([63.227.221.253]:48621 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab1I3BST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:18:19 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 29 Sep 2011 18:18:02 -0700
Message-ID: <yunpqiikeut.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here are three tiny patches, two new bug fixes and one regression fix
that disables FBC on Ironlake and older chips.

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~keithp/linux drm-intel-fixes

Keith Packard (2):
      drm/i915: Enable dither whenever display bpc < frame buffer bpc
      drm/i915: FBC off for ironlake and older, otherwise on by default

Simon Farnsworth (1):
      drm/i915: Enable SDVO hotplug interrupts for HDMI and DVI

 drivers/gpu/drm/i915/i915_drv.c      |    4 +-
 drivers/gpu/drm/i915/intel_display.c |   22 ++++++--
 drivers/gpu/drm/i915/intel_drv.h     |    3 -
 drivers/gpu/drm/i915/intel_sdvo.c    |   88 +++++++++++-------------------=
----
 4 files changed, 47 insertions(+), 70 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhRjLQp8BWwlsTdMRAqHCAJwPW/Nmnte7qm0WDrR4ni9Kfm/qQgCg6d1R
nuMtW30BnY+gvEXOgbf6MbA=
=tUNe
-----END PGP SIGNATURE-----
--=-=-=--
