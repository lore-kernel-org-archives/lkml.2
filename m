Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272Ab2KAMAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:00:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31343 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2KAMAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:00:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6882"; a="3450450"
From: tlinder <tlinder@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, philippedeswert@gmail.com, jengelh@inai.de,
        jh80.chung@samsung.com, tgih.jun@samsung.com, arnd.bergmann@linaro.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v3 2/2] block: compile ROW statically into the kernel
Date: Thu,  1 Nov 2012 14:00:02 +0200
Message-Id: <1351771203-31200-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tatyana Brokhman <tlinder@codeaurora.org>

ROW is a new scheduling algorithm. Similar to the existing scheduling
algorithms it should be compiled to the kernel statically giving the user
the ability to switch to it without kernel recompilation.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 5a747e2..401f42d 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -23,6 +23,7 @@ config IOSCHED_DEADLINE
 
 config IOSCHED_ROW
 	tristate "ROW I/O scheduler"
+	default y
 	---help---
 	  The ROW I/O scheduler gives priority to READ requests over the
 	  WRITE requests when dispatching, without starving WRITE requests.
-- 
1.7.6
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. 
Is a member of Code Aurora Forum, hosted by the Linux Foundation
