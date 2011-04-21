Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1DUPwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:52:21 -0400
Received: from home.keithp.com ([63.227.221.253]:47419 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1DUPwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:52:20 -0400
From: "Keith Packard" <keithp@keithp.com>
To: "Torvalds\, Linus" <torvalds@linux-foundation.org>
Subject: [PULL] drm intel fixes
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Airlie, Dave" <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Date: Thu, 21 Apr 2011 08:52:09 -0700
Message-ID: <yun7hanzjo6.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Here's a couple of minor fixes for intel modesetting.

These should resolve the following bugs:

    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D35977
    References: https://bugs.freedesktop.org/show_bug.cgi?id=3D35903
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D35796
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D32612

These didn't uncover any regressions in testing compared with -rc2. We
have found an S4 resume regression in -rc2 compared with .38 on the
Piketon platform which we're still chasing.

the following changes since commit 6221f222c0ebf1acdf7abcf927178f40e1a65e2a:

  Linux 2.6.39-rc2 (2011-04-05 18:30:43 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git drm-in=
tel-fixes

Chris Wilson (2):
      drm/i915: Sanitize the output registers after resume
      drm/i915: Initialise g4x watermarks for disabled pipes

Mathew McKernan (2):
      drm/i915/tv: Remember the detected TV type
      drm/i915/tv: Only poll for TV connections

Sitsofe Wheeler (1):
      drm/i915/tv: Fix modeset flickering introduced in 7f58aabc3

 drivers/gpu/drm/i915/intel_display.c |   73 ++++++++++++++++++------------=
---
 drivers/gpu/drm/i915/intel_tv.c      |    9 ++--
 2 files changed, 45 insertions(+), 37 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNsFKpQp8BWwlsTdMRAn0HAJ4nCqZga5w7fKr8E5BgXupFMLww2ACgzU25
emvV3yr9vpkl1LzD6m91MSM=
=VKmE
-----END PGP SIGNATURE-----
--=-=-=--
