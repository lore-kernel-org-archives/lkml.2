Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2CNSan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:30:43 -0400
Received: from home.keithp.com ([63.227.221.253]:60397 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758184Ab2CNSaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:30:09 -0400
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "drivers\, Intel" <Intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org
Subject: [PULL] drm-intel-fixes
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 14 Mar 2012 11:30:02 -0700
Message-ID: <86haxravdh.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Jesse sent me a couple of trivial sprite plane fixes.

The following changes since commit 91982b58d35720b75b894c60e1e3133daa455b53:

  drm/gma500: Fix Cedarview boot failures in 3.3-rc (2012-03-05 14:08:31 +0=
000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux drm-intel-fixes

for you to fetch changes up to b250da79a0c972ef7f6d58ebd1083cab066e6c82:

  drm/i915: support 32 bit BGR formats in sprite planes (2012-03-07 10:52:1=
3 -0800)

=2D---------------------------------------------------------------
Jesse Barnes (2):
      drm/i915: fix color order for BGR formats on SNB
      drm/i915: support 32 bit BGR formats in sprite planes

 drivers/gpu/drm/i915/i915_reg.h      |    2 +-
 drivers/gpu/drm/i915/intel_display.c |    1 +
 drivers/gpu/drm/i915/intel_sprite.c  |    6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBT2DjqjYtFsjWk68qAQjx6w/+Ipw1AGG7ZbZkNYI1/HUeciNxPwXrTPYG
HEl7xQENC6xGOUeokz9zhXDOGANHqZ7Rils8TCUB6ysp6H6BunizdomKemKB50p9
qjksL1hMbZ1G4qKFal52Ah3+zeBjsplQbgH0yu69niV5IkS7bzw+//VqvvjbFLFU
CCyRmlD5dKjTSmjKfWSf7yH8Hg+n9VhD/yrlSexSCUWHW+/b6IFh8+KVDS51kb0c
4kbfxk9+W6+W3i+mGgiabooH9apSmeyuqzaGMOslUvVH7otsgHFJfBJTAC5rROxP
l+DvEvOj1hSgWHB+ggzZtdGHdY/KU9j4jY5/5sTgL6ysF+BmoNrwxqGlhPBVsG2A
rIKLrDCOwfO7qXYxH5fCtX+dMoG8TyYaE76dd+iwY82d9U1kIBiP6+MI2qrK+K9Z
Of29jW4BQfAMT0hKlqCIqbZ6Jk9mmxfDRjoBevdVlyD5WPUULw4ZvyIdmTTeXcot
x5yXcGy6vGJPn+Wit+Ucropl2oKPJnVqzxPszm5KkgogkPLMoSt1niMA1EiDFjQV
yjYQ8I8REzpdYTnuUZNYQ9YrlayjxqHq7BducEGgnpWwgkxjqAUx299w4U5A1wbr
C/wJnFl3Ta8LCS+FuYMcI6VoYhZ3z/iac0Cwtk+UgFn/MTd9xG5ZRuPqU5XLR1iE
dPeN99svevU=
=VTAo
-----END PGP SIGNATURE-----
--=-=-=--
