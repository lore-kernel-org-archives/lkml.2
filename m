Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1GUQmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:42:12 -0400
Received: from home.keithp.com ([63.227.221.253]:51303 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1GUQmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:42:09 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes (drm/i915 driver)
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 21 Jul 2011 09:42:05 -0700
Message-ID: <yunaac7vb4y.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Two fairly useful bug fixes:

* Quirk for Lenovo U160 to prevent a black-screen when KMS starts up.
  We've gone round and round trying to make this hardware 'just work',
  it's time to give up and special case this box.

* Fix longstanding regression on old (pre-G33) hardware with tiled
  buffer alignment.

The following changes since commit d1ca1a004822983e2fc702d5382b4b9a5527cfbe:

  Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kern=
el/git/keithp/linux-2.6 (2011-07-12 14:18:00 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm=
-intel-fixes

Chris Wilson (1):
      drm/i915: Fix unfenced alignment on pre-G33 hardware

Keith Packard (1):
      drm/i915: Add quirk to disable SSC on Lenovo U160 LVDS

 drivers/gpu/drm/i915/i915_drv.h        |    5 ++-
 drivers/gpu/drm/i915/i915_gem.c        |   71 ++++++++++++++++------------=
----
 drivers/gpu/drm/i915/i915_gem_tiling.c |    4 +-
 drivers/gpu/drm/i915/intel_display.c   |   15 ++++++-
 4 files changed, 56 insertions(+), 39 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOKFbdQp8BWwlsTdMRApWTAKCm7uaXH608iRZxUWtNv5Pkn2iMHACgjvXu
A4OpDHAS3/de1fb2jLYfNmk=
=KJt6
-----END PGP SIGNATURE-----
--=-=-=--
