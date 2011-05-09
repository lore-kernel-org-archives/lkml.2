Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1EIXv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:51:28 -0400
Received: from home.keithp.com ([63.227.221.253]:36831 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab1EIXv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:51:27 -0400
From: "Keith Packard" <keithp@keithp.com>
To: "Torvalds\, Linus" <torvalds@linux-foundation.org>
Subject: [PULL] drm intel fixes
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Airlie\, Dave" <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Date: Mon, 09 May 2011 16:51:22 -0700
Message-ID: <yun1v07whz9.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here are a few very small changes for Intel mode setting.

They should fix the following bugs:

    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D36314
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D36456
    References: https://bugs.freedesktop.org/show_bug.cgi?id=3D36246

The following changes since commit 0ee5623f9a6e52df90a78bd21179f8ab370e102e:

  Linux 2.6.39-rc6 (2011-05-03 19:59:13 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm-in=
tel-fixes

Alex Williamson (1):
      drm/i915/lvds: Only act on lid notify when the device is on

Chris Wilson (4):
      drm/i915: Release object along create user fb error path
      drm/i915/dp: Be paranoid in case we disable a DP before it is attached
      drm/i915: Only enable the plane after setting the fb base (pre-ILK)
      drm/i915: fix intel_crtc_clock_get pipe reads after "cleanup cleanup"

 drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
 drivers/gpu/drm/i915/intel_dp.c      |   17 +++++++++++++++--
 drivers/gpu/drm/i915/intel_lvds.c    |    3 +++
 3 files changed, 23 insertions(+), 7 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNyH36Qp8BWwlsTdMRAhiRAJsEh+Gzky0MrhkkiPyoPzrY+z8XVACfYfJZ
tFjw7iW6HfsN9ldneCrcmPA=
=qarT
-----END PGP SIGNATURE-----
--=-=-=--
