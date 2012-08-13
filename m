Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2HMKSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:18:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:37944 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2HMKSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:18:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="179927201"
From: Jani Nikula <jani.nikula@intel.com>
To: maciej.rutecki@gmail.com, alferpal@gmail.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Cc: daniel@ffwll.ch, jani.nikula@intel.com
Subject: [PATCH 0/2] GMBUS EDID read bit-banging fallback
Date: Mon, 13 Aug 2012 13:22:33 +0300
Message-Id: <cover.1344852255.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <201207271346.49259.maciej.rutecki@gmail.com>
References: <201207271346.49259.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex, Maciej, please test the following to see if it fixes the issue
[1], thanks.

BR,
Jani.


[1] https://bugzilla.kernel.org/show_bug.cgi?id=45881

Jani Nikula (2):
  drm/i915: extract connector update from intel_ddc_get_modes() for
    reuse
  drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads

 drivers/gpu/drm/i915/intel_crt.c   |   36 +++++++++++++++++++++++++++++++++---
 drivers/gpu/drm/i915/intel_drv.h   |    2 ++
 drivers/gpu/drm/i915/intel_modes.c |   31 ++++++++++++++++++++++---------
 3 files changed, 57 insertions(+), 12 deletions(-)

-- 
1.7.9.5

