Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2KGBPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:15:25 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39202 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab2KGBPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:15:24 -0500
Date: Wed, 7 Nov 2012 01:15:21 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon + core fixes
Message-ID: <alpine.DEB.2.00.1211070114190.1310@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

a single radeon typo fix for a regressions
and two fixes for a regression in the open helper addres space stuff.

Dave.

The following changes since commit 3d70f8c617a436c7146ecb81df2265b4626dfe89:

  Linux 3.7-rc4 (2012-11-04 11:07:39 -0800)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon: fix typo in evergreen_mc_resume()

Ilija Hadzic (2):
      drm: restore open_count if drm_setup fails
      drm: set dev_mapping before calling drm_open_helper

 drivers/gpu/drm/drm_fops.c         |   44 ++++++++++++++++++++++++-----------
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 2 files changed, 31 insertions(+), 15 deletions(-)
