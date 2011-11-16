Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1KPN3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:29:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:23087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1KPN33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:29:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,521,1315206000"; 
   d="scan'208";a="75649615"
Message-Id: <20111116132004.299754849@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 16 Nov 2011 21:20:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>
cc: dri-devel@lists.freedesktop.org
cc: intel-gfx@lists.freedesktop.org
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] HDMI ELD fixes for 3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith,

Here are 3 fixes on HDMI/ELD audio.

The third one adds a ->hot_remove hook to drm_connector_funcs. Please review.

[PATCH 1/3] drm/i915: fix ELD writing for SandyBridge
[PATCH 2/3] drm/i915: dont trigger hotplug events on unchanged ELD
[PATCH 3/3] drm/i915: hot removal notification to HDMI audio driver

Thanks,
Fengguang

