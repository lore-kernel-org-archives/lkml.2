Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab1F1Ray (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:30:54 -0400
Received: from home.keithp.com ([63.227.221.253]:43596 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759959Ab1F1R2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:28:54 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 28 Jun 2011 10:28:50 -0700
Message-ID: <yunhb79hnl9.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


A couple of forcewake fixes and and a patch to make page flip work on
IVB.

Sorry for the large diffstat; the IVB fix first splits out page flipping
into per-generation functions and then applies the IVB-specific version,
so the bulk of the change is just shuffling code around.

The following changes since commit 483f1798998ede75b2575cc1813c3d89ba64a34e:

  drm/i915: save/resume forcewake lock fixes (2011-06-22 10:28:33 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-fixes

Ben Widawsky (1):
      drm/i915: forcewake fix after reset

Chris Wilson (1):
      drm/i915: Use chipset-specific irq installers

Jesse Barnes (2):
      drm/i915: split page flip queueing into per-chipset functions
      drm/i915: add Ivy Bridge page flip support

 drivers/gpu/drm/i915/i915_drv.c      |    3 +
 drivers/gpu/drm/i915/i915_drv.h      |    3 +
 drivers/gpu/drm/i915/i915_gem.c      |    4 +-
 drivers/gpu/drm/i915/intel_display.c |  305 ++++++++++++++++++++++++------=
---
 4 files changed, 230 insertions(+), 85 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOCg9SQp8BWwlsTdMRAnB7AJ9zAjH7rZdNn/ad9E7avhdAm6185gCfdrar
eEEhx0qeEu/JwO2OzF6YuuE=
=L1TQ
-----END PGP SIGNATURE-----
--=-=-=--
