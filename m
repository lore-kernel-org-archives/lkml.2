Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2HMO32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:29:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:28182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2HMO3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:29:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="180411275"
From: Jani Nikula <jani.nikula@intel.com>
To: ionic@ionic.de
Cc: daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, jani.nikula@intel.com
Subject: [PATCH 0/1] hopefully fix null pointer dereference on i915 load
Date: Mon, 13 Aug 2012 17:33:01 +0300
Message-Id: <cover.1344867962.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <50254887.6030209@ionic.de>
References: <50254887.6030209@ionic.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mihai, could you test the following patch to see if it fixes the problem,
please?

BR,
Jani.


Jani Nikula (1):
  drm/i915: ensure i2c adapter is all set before adding it

 drivers/gpu/drm/i915/intel_i2c.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
1.7.9.5

