Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844Ab0EZDC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 23:02:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52644 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933621Ab0EZDC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 23:02:56 -0400
Date: Wed, 26 May 2010 04:02:36 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1005260401180.2908@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just some minor drm/agp fixes, nothing too serious, AGP s/r regression, 
HDMI EDID regression fix.

Dave.

The following changes since commit b486787ee4797d6e42a9bd3a6f079385ad0f4472:
  Alex Deucher (1):
        drm/radeon/kms/pm/r600: select the mid clock mode for single head low profile

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Adam Jackson (1):
      drm/edid: Allow non-fatal checksum errors in CEA blocks

Jerome Glisse (1):
      drm/radeon/kms: release AGP bridge at suspend

Jiri Slaby (1):
      agp: amd64, fix pci reference leaks

Prarit Bhargava (1):
      drm: Fixes linux-next & linux-2.6 checkstack warnings:

Randy Dunlap (1):
      nouveau: fix acpi_lid_open undefined

Stefan Richter (1):
      drm/radeon/kms: suppress a build warning (unused variable)

 drivers/char/agp/amd64-agp.c                |   28 +++++++++++++++++---------
 drivers/gpu/drm/drm_edid.c                  |    5 +++-
 drivers/gpu/drm/nouveau/nouveau_connector.c |    3 +-
 drivers/gpu/drm/nouveau/nv40_graph.c        |    8 ++++++-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    1 +
 drivers/gpu/drm/radeon/radeon.h             |    1 +
 drivers/gpu/drm/radeon/radeon_agp.c         |    5 ++++
 drivers/gpu/drm/radeon/radeon_atombios.c    |   13 ++++++++++-
 drivers/gpu/drm/radeon/radeon_device.c      |    2 +
 9 files changed, 51 insertions(+), 15 deletions(-)
