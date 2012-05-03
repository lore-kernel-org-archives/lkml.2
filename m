Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab2ECOY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:24:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58812 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756147Ab2ECOYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:24:23 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: [PATCH v2 05/16] block: Documentation: add sysfs ABI for expedite_dmpg and expedite_swapin
Date: Thu, 3 May 2012 19:53:04 +0530
Message-ID: <1336054995-22988-6-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description on the usage of expedite_dmpg and
expedite_swapin.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 Documentation/ABI/testing/sysfs-block |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index c1eb41c..0fb9fef 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -206,3 +206,15 @@ Description:
 		when a discarded area is read the discard_zeroes_data
 		parameter will be set to one. Otherwise it will be 0 and
 		the result of reading a discarded area is undefined.
+
+What:		/sys/block/<disk>/queue/expedite_demandpaging
+What:		/sys/block/<disk>/queue/expedite_swapin
+Date:		April 2012
+Contact:	Venkatraman S <svenkatr@ti.com>
+Description:
+		For latency improvements, some storage devices could
+		provide a mechanism for servicing demand paging and
+		swapin requests in a high priority manner. Setting
+		these flags to 1 would get the requests marked with
+		REQ_RW_DMPG or REQ_RW_SWAPIN to be moved to the front
+		of elevator queue.
-- 
1.7.10.rc2

