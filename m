Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2IQOXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:23:49 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab2IQOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:45 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsCABEvV1BbdWObgWdsb2JhbABEhUC2VSIBARYmJ4IgAX8wbSISiAS6WpIJA5Vikwk
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870753"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 0/7] staging: sm7xxfb: code improvements and cleanup
Date: Mon, 17 Sep 2012 16:12:46 +0200
Message-Id: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch adds some improvements and code cleanup.

Tested with SM712.

Javier M. Mellid (7):
  staging: sm7xxfb: clean fb_fix_screeninfo and fb_var_screeninfo
    initialization
  staging: sm7xxfb: clean smtcfb_fix's id initialization
  staging: sm7xxfb: cleanup on smtc_alloc_fb_info
  staging: sm7xxfb: annotate iomem pointers
  staging: sm7xxfb: rename some smtcfb_info fields
  staging: sm7xxfb: rename pFramebufferPhysical to mmio_base
  staging: sm7xxfb: remove smtc_VRAMBaseAddress

 drivers/staging/sm7xxfb/sm7xx.h   |    2 +-
 drivers/staging/sm7xxfb/sm7xxfb.c |  118 +++++++++++++++----------------------
 2 files changed, 49 insertions(+), 71 deletions(-)

-- 
1.7.10.4

