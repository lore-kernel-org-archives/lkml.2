Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1LIM76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:59:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:34808 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1LIM75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:59:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83996287"
Message-Id: <20111209124216.701131933@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Dec 2011 20:42:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>
Cc: Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Pierre-louis Bossart " <pierre-louis.bossart@intel.com>,
        "Zhenyu Wang" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] Intel HDMI ELD fixes v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith,

The complete set of fixes for passing HDMI/DP ELD to audio driver.

 [PATCH 1/5] drm/i915: fix ELD writing for SandyBridge
 [PATCH 2/5] drm/i915: rename audio ELD registers
 [PATCH 3/5] drm/i915: dont trigger hotplug events on unchanged ELD
 [PATCH 4/5] drm/i915: HDMI hot remove notification to audio driver
 [PATCH 5/5] drm/i915: DisplayPort hot remove notification to audio driver

 drivers/gpu/drm/i915/i915_reg.h      |   22 +++----
 drivers/gpu/drm/i915/intel_display.c |   75 +++++++++++++++++++------
 drivers/gpu/drm/i915/intel_dp.c      |    1 
 drivers/gpu/drm/i915/intel_hdmi.c    |    8 ++
 4 files changed, 76 insertions(+), 30 deletions(-)

Thanks,
Fengguang

