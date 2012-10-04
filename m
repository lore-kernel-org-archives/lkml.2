Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422777Ab2JDQBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:01:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34546 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422640Ab2JDQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:01:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH] MAINTAINERS: Add myself as the SWIOTLB maintainer.
Date: Thu,  4 Oct 2012 11:49:33 -0400
Message-Id: <1349365773-12073-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that I've an IA64 box on top of the other boxes
(IBM with Calgary-X, Intel VT-d, AMD Vi, and AMD GART - that
can use SWIOTLB as fallback) I can reliably do regression
testing.

CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
CC: Tony Luck <tony.luck@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a6c4da..7ac4d08 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6731,6 +6731,14 @@ S:	Maintained
 F:	Documentation/svga.txt
 F:	arch/x86/boot/video*
 
+SWIOTLB SUBSYSTEM
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	lib/swiotlb.c
+F:	arch/*/kernel/pci-swiotlb.c
+F:	include/linux/swiotlb.h
+
 SYSV FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 S:	Maintained
-- 
1.7.7.6

