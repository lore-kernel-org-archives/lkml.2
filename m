Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1CMP3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:29:39 -0400
Received: from compulab.co.il ([67.18.134.219]:37850 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab1CMP3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:29:37 -0400
Message-ID: <4D7CE230.1070004@compulab.co.il>
Date: Sun, 13 Mar 2011 17:26:40 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/3] pci_ids: add Intel Tunnel Creek LPC Bridge device ID.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Turischev <denis@compulab.co.il>

---
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3adb06e..43779f9 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2731,6 +2731,7 @@
 #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
 #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
 #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
+#define PCI_DEVICE_ID_INTEL_ITC_LPC	0x8186
 #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4
 #define PCI_DEVICE_ID_INTEL_82450GX	0x84c5
 #define PCI_DEVICE_ID_INTEL_82451NX	0x84ca
-- 
1.7.0.4
