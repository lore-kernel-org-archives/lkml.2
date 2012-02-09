Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab2BIVai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:30:38 -0500
Received: from home.keithp.com ([63.227.221.253]:40236 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab2BIVah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:30:37 -0500
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "drivers\, Intel" <Intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 09 Feb 2012 13:30:33 -0800
Message-ID: <868vkbd79i.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here are a few bug fixes for drm/i915. This fixes switching from
interlaced to non-interlaced mode at boot time, as well as a bunch of
regressions caused by bad DP bandwidth computations.

The following changes since commit acb42a3b611d7ad4cb173c3b37674b549df2ffeb:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (=
2012-01-27 07:56:25 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux drm-intel-fixes

for you to fetch changes up to 617cf884810b44384fe8e9431e9babeb80a2ff37:

  drm/i915: fixup interlaced bits clearing in PIPECONF on PCH_SPLIT (v2) (2=
012-02-08 13:54:18 -0800)

=2D---------------------------------------------------------------
Chris Wilson (1):
      drm/i915:: Disable FBC on SandyBridge

Daniel Vetter (2):
      drm/i915: fixup interlaced bits clearing in PIPECONF on PCH_SPLIT
      drm/i915: no lvds quirk for AOpen MP45

Keith Packard (2):
      drm/i915: Force explicit bpp selection for intel_dp_link_required
      drm/i915: fixup interlaced bits clearing in PIPECONF on PCH_SPLIT (v2)

 drivers/gpu/drm/i915/intel_display.c |    8 +++++---
 drivers/gpu/drm/i915/intel_dp.c      |   20 +++++---------------
 drivers/gpu/drm/i915/intel_lvds.c    |    8 ++++++++
 3 files changed, 18 insertions(+), 18 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTzQ6+TYtFsjWk68qAQidpg/+PllmsukK42kcZVxKFHd87U7cLkV5D4+i
Dnfgu1cWqmukZ5loV1L/kiPQR8sD87sSg/i2+VhvWZ+6dL8UWoyCC5gTsm6WxpSm
q59TQnAnQE2tBdA5tRwq70fvYZ17V1SzQmlrVE0Q1wX1RmxwdtHsfDdNstd7lU64
oE/CKVdrwO3E2LHYbMy9Ojtm6W4Zt3GK4HIidzdlb3iLcBFuTSUu6ZNdUZgzVWu9
ix4O1hyIb6MIBC9tfgCeWAylcVHjEy2JywbRiy/Ns9L3F6nFEc0kHooyGcmp2Pr2
hao6bEygvo5DHpb6BPBrVUPY/vFOrPc5WT5/+SN5+8vvbnfffjFnxagrIt7q7ASp
aISsTS+g6U/xqhdfl8999kYlqrLeoLZmcd3Atxqja073H06MX8Dn1DZkEc71xULP
GqVjNRHN7Mn2zzr3eePkMv+PBfGVurxKH2oV+0QA2aqQqFrAt3nz3NYqJiC6JOUt
DvI8CK7vDjKHidDqa21llGBV1yn4JpYMtfHPqUcym526IE9nJFVus0iL1Oi/0lt6
kPCqTrC15gEnmxoBdkc2dOfitJrStmLVPXobRyydrMvz23n0tfkVP6gUVIMIMrwa
DjBYTRgHk6K0VmpA9ISIdKnY7f/Wdv5xyWNd6P8oQtQPksTUMTXk3JaMxwfLtoK0
Raib/5u0QT4=
=NbUQ
-----END PGP SIGNATURE-----
--=-=-=--
