Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1KSGzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 01:55:04 -0500
Received: from home.keithp.com ([63.227.221.253]:38918 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1KSGzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 01:55:02 -0500
From: "Keith Packard" <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>
Subject: [PULL] drm-intel-fixes
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Intel drivers <Intel-gfx@lists.freedesktop.org>
Date: Fri, 18 Nov 2011 22:54:51 -0800
Message-ID: <86ehx4lhz8.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Hey Dave:

Here's a pile of fixes to the intel driver. This pull includes the three
patches you already merged in, but it merges cleanly so I didn't rebase
around them.

The following changes since commit 37be944a0270402f9cda291a930b0286f6dc92f5:

  Merge branch 'drm-core-next' of git://people.freedesktop.org/~airlied/lin=
ux (2011-10-28 05:54:23 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~keithp/linux drm-intel-fixes

Adam Jackson (1):
      drm/i915: intel_choose_pipe_bpp_dither messages should be DRM_DEBUG_K=
MS

Ben Widawsky (1):
      drm/i915: forcewake warning fixes in debugfs

Dan Carpenter (1):
      drm/i915: fix if statement (bogus semi-colon)

Daniel Vetter (4):
      drm/i915: disable temporal dithering on the internal panel
      drm/i915: only match on PCI_BASE_CLASS_DISPLAY
      drm/i915: Ivybridge still has fences!
      drm/i915: add constants to size fence arrays and fields

Eric Anholt (3):
      drm/i915: Fix object refcount leak on mmappable size limit error path.
      drm/i915: Turn on a required 3D clock gating bit on Sandybridge.
      drm/i915: Turn on another required clock gating bit on gen6.

Jesse Barnes (1):
      drm/i915: enable cacheable objects on Ivybridge

Keith Packard (12):
      agp: iommu_gfx_mapped only available if CONFIG_INTEL_IOMMU is set
      drm/i915: Use mode_config.mutex in ironlake_panel_vdd_work
      drm/i915: Module parameters using '-1' as default must be signed type
      drm/i915: Move common PCH_PP_CONTROL setup to ironlake_get_pp_control
      drm/i915: Remove link_status field from intel_dp structure
      drm/i915: Treat PCH eDP like DP in most places
      drm/i915: Let panel power sequencing hardware do its job
      drm/i915: Make DP prepare/commit consistent with DP dpms
      drm/i915: Try harder during dp pattern 1 link training
      drm/i915: Remove trailing white space
      drm/i915: Initiate DP link training only on the lanes we'll be using
      drm/i915: Use DPCD value for max DP lanes.

Rakib Mullick (1):
      drm, i915: Fix memory leak in i915_gem_busy_ioctl().

Takashi Iwai (1):
      drm/i915: Fix inconsistent backlight level during disabled

 drivers/char/agp/intel-gtt.c         |    7 +-
 drivers/gpu/drm/i915/i915_debugfs.c  |   57 +++++-
 drivers/gpu/drm/i915/i915_drv.c      |    6 +-
 drivers/gpu/drm/i915/i915_drv.h      |   19 +-
 drivers/gpu/drm/i915/i915_gem.c      |   14 +-
 drivers/gpu/drm/i915/i915_irq.c      |    1 +
 drivers/gpu/drm/i915/i915_reg.h      |   21 ++-
 drivers/gpu/drm/i915/i915_suspend.c  |    2 +
 drivers/gpu/drm/i915/intel_display.c |   33 ++-
 drivers/gpu/drm/i915/intel_dp.c      |  411 +++++++++++++++++++-----------=
---
 drivers/gpu/drm/i915/intel_panel.c   |    3 +-
 11 files changed, 359 insertions(+), 215 deletions(-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIUAwUBTsdSuzYtFsjWk68qAQjUpg/3VePh26L71ru/eMC9VCkbZLMQdW1jz7gd
2mpoeMtqHpj1X7qSJfBF1H/7vUxAnN00BouBpQZ4rv/bd5zCmxNh/QZkOaYhuqQW
6hUK1Lbb6G+BWMWxvRyWgrr5pv5YLi1SLGwc67q7Zl7ZxtxwtPm6x5GMIKidqxUE
9h9jilHfLMjnoANVTt52XNnv+8nsEDiwwPX0ujuitF6mi3dGJm7nC8zN2mZppkTn
80wGJfZpBUZ0Eu7o6+95YGghpvLpYC8ujboIoTP+SRd4lIVjfACR1I7n9Vxgyon4
STb8FRewkuKfOFldyCK0y+TEDE9sr0nzjbeofX8pS15WaWaV7vcGfir7cB5n8TcF
gyM4zSNnUbpwt4a4rbp7mQgaJQBwrBX3HVgQLNf/0Am/+araQCoBNaW/vhLCwpQJ
KF5jrky9jQ1I2sm3Jre/V5CqriTlHkDOhvK9SHFHEPfvoGxWccTpAuY4F8T4Sfgz
D1VaBXlNh45prH+NLAIET4W8jT3D7/pFYrQZ/0B8pv+06cNGLtp5aX8xOxGkCidx
f9XGkOud4SVmp2oCbLWjlZ3Y+vQgvJHn/npE+UIkh4GXBZ10yHsd/rIwaAI9dUu6
9Ybsd1Z7i7QF/P9a0cWut96Ia3o4VvbvFdLGInYZwEjexKtgqmrYxeyUWem3BnuT
lQsBsR1jJg==
=Cdqy
-----END PGP SIGNATURE-----
--=-=-=--
