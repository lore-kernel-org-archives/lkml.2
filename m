Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0IQDuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 23:50:32 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42433 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab0IQDuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 23:50:32 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>
Subject: [PATCH 0/2] Add device id for Intel B43 chipset
Date: Fri, 17 Sep 2010 11:50:24 +0800
Message-Id: <1284695424-6294-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is another device id for Intel B43 chip. Since there is already an id
sets for B43 in intel-agp and i915. We tried to modify the kernel and
xserver-xorg-video-intel and they work fine on 8086:2E90/2E92 chipsets. I
believe this id sets is valid[1], and another patches has been sent to bug
tracking system of freedesktop[2].

Since this is a blind try, please review the patches and if there is no more
modification needed, please consider apply them.

 [1] https://upgrades.intel.com/Public/PublicLandingPage.aspx
 [2] https://bugs.freedesktop.org/show_bug.cgi?id=30221

Ike Panhc (2):
  apg/intel: Support for another B43 device id
  drm/i915: Support for another B43 device id

 drivers/char/agp/intel-agp.c    |    7 +++++--
 drivers/char/agp/intel-agp.h    |    9 ++++++---
 drivers/char/agp/intel-gtt.c    |    3 ++-
 drivers/gpu/drm/i915/i915_drv.c |    1 +
 4 files changed, 14 insertions(+), 6 deletions(-)

