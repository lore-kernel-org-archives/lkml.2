Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2FEOgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:36:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59450 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab2FEOgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:36:39 -0400
Date: Tue, 5 Jun 2012 15:36:37 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes + new pci ids.
Message-ID: <alpine.DEB.2.00.1206051535280.32686@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-158993614-1338906997=:32686"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-158993614-1338906997=:32686
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT


Hi Linus,

this is just radeon fixes and a bunch of new PCI ids.
The fixes are for a deadlock, an audio regression, and a couple of audio 
fixes.

Dave.

The following changes since commit 99becf1328d8d71dd6f4480e3591d7dcdb389e57:

  Pull 'for-linus' branches of git://git.kernel.org/pub/scm/linux/kernel/git/viro/{signal,vfs} (2012-06-04 15:09:08 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 7aaa61b3476462b69f1ac7669fcca8d608ce3cb5:

  drm/radeon/kms: add new SI PCI ids (2012-06-05 15:11:12 +0100)

----------------------------------------------------------------
Alex Deucher (6):
      drm/radeon: make audio_init consistent across asics
      drm/radeon: fix gpu_init on si
      drm/radeon/kms: add new Trinity PCI ids
      drm/radeon/kms: add new Palm, Sumo PCI ids
      drm/radeon/kms: add new BTC PCI ids
      drm/radeon/kms: add new SI PCI ids

Christian König (1):
      drm/radeon: fix vm deadlocks on cayman

Rafa³ Mi³ecki (2):
      drm/radeon/audio: don't hardcode CRTC id
      drm/radeon/hdmi: don't set SEND_MAX_PACKETS bit

 drivers/gpu/drm/radeon/ni.c          |   21 +-
 drivers/gpu/drm/radeon/r600.c        |   15 +-
 drivers/gpu/drm/radeon/r600_audio.c  |    5 +-
 drivers/gpu/drm/radeon/r600_hdmi.c   |    1 -
 drivers/gpu/drm/radeon/radeon.h      |    5 +-
 drivers/gpu/drm/radeon/radeon_gart.c |   19 +-
 drivers/gpu/drm/radeon/radeon_kms.c  |    2 +-
 drivers/gpu/drm/radeon/rs600.c       |   12 +-
 drivers/gpu/drm/radeon/rs690.c       |   12 +-
 drivers/gpu/drm/radeon/rv770.c       |   18 +-
 drivers/gpu/drm/radeon/si.c          |  477 ++++++++++++----------------------
 drivers/gpu/drm/radeon/sid.h         |   19 ++
 include/drm/drm_pciids.h             |   17 +-
 13 files changed, 255 insertions(+), 368 deletions(-)
--29444707-158993614-1338906997=:32686--
