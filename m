Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2JZBCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:02:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50782 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab2JZBCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:02:02 -0400
Date: Fri, 26 Oct 2012 02:01:59 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes.
Message-ID: <alpine.DEB.2.00.1210260200200.5647@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-178829210-1351213319=:5647"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-178829210-1351213319=:5647
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Just radeon fixes in this one,
some new PCI IDs,
ATPX regression fix,
async VM regression fixes
some module options fixes.

Dave.

The following changes since commit b8e902f24fdd16c4373ddc37a4e150c4afe9c6db:

  drm/ttm: Fix a theoretical race in ttm_bo_cleanup_refs() (2012-10-23 10:15:21 +1000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (6):
      drm/radeon: add some new SI PCI ids
      drm/radeon: fix sparse warning
      drm/radeon: give each backlight a unique id
      drm/radeon: add error output if VM CS fails on cayman
      drm/radeon: fix ATPX function documentation
      drm/radeon: fix ATPX regression in acpi rework

Christian König (9):
      drm/radeon: fix PFP sync in vm_flush
      drm/radeon: fix cayman_vm_set_page v2
      drm/radeon: fix si_set_page v2
      drm/radeon: remove set_page check from VM code
      drm/radeon: fix header size estimation in VM code
      drm/radeon: fix and simplify pot argument checks v3
      drm/radeon: use vzalloc for gart pages
      drm/radeon: move size limits to gem_object_create.
      drm/radeon: move the retry to gem_object_create

Dave Airlie (1):
      Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes

 drivers/gpu/drm/radeon/atombios_encoders.c      |    5 ++-
 drivers/gpu/drm/radeon/evergreen_cs.c           |    1 +
 drivers/gpu/drm/radeon/ni.c                     |   45 ++++++++++-------
 drivers/gpu/drm/radeon/nid.h                    |    1 +
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |    6 +-
 drivers/gpu/drm/radeon/radeon_device.c          |   60 +++++++++--------------
 drivers/gpu/drm/radeon/radeon_gart.c            |   22 ++++-----
 drivers/gpu/drm/radeon/radeon_gem.c             |   18 ++++++-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    5 ++-
 drivers/gpu/drm/radeon/radeon_object.c          |   19 -------
 drivers/gpu/drm/radeon/si.c                     |   47 +++++++++++-------
 include/drm/drm_pciids.h                        |    3 +
 12 files changed, 122 insertions(+), 110 deletions(-)
--29444707-178829210-1351213319=:5647--
