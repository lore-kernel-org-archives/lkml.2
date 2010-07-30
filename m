Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0G3Hfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:35:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:44612 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0G3Hfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:35:53 -0400
Date: Fri, 30 Jul 2010 16:35:46 +0900
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] add DMA_xxBIT_MASK to feature-removal-schedule.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100730163339C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 30 Jul 2010 16:35:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_xxBIT_MASK macros were marked as deprecated in June 2009. One more
year is long enough, I think.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 23a8f8d..a94c2ad 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -541,3 +541,11 @@ Why:	PCI DMA unmap state API (include/linux/pci-dma.h) was replaced
 Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 
 ----------------------------
+
+What: 	DMA_xxBIT_MASK macros
+When:	Jun 2011
+Why:	DMA_xxBIT_MASK macros were replaced with DMA_BIT_MASK() macros.
+Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
+
+----------------------------
+
-- 
1.6.5

