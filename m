Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab0G2KsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:48:01 -0400
Received: from sh.osrg.net ([192.16.179.4]:60129 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898Ab0G2Kr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:47:58 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/2] PCI: add PCI DMA unamp state API to feature-removal-schedule.txt
Date: Thu, 29 Jul 2010 19:45:08 +0900
Message-Id: <1280400308-16114-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1280400308-16114-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1280400308-16114-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 29 Jul 2010 19:47:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was replaced with the DMA unamp state API (which can be used for
any bus).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 887c668..23a8f8d 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -532,3 +532,12 @@ Why:	superseded by acpi_sleep=nonvs
 Who:	Rafael J. Wysocki <rjw@sisk.pl>
 
 ----------------------------
+
+What: 	PCI DMA unmap state API
+When:	August 2012
+Why:	PCI DMA unmap state API (include/linux/pci-dma.h) was replaced
+	with DMA unmap state API (DMA unmap state API can be used for
+	any bus).
+Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
+
+----------------------------
-- 
1.6.5

