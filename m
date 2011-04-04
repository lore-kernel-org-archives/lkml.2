Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1DDIas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:30:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60135 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab1DDIar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:30:47 -0400
X-IronPort-AV: E=Sophos;i="4.63,296,1299474000"; 
   d="scan'208";a="143381301"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: Re-alphabetize Xen entries.
Date: Mon,  4 Apr 2011 09:30:43 +0100
Message-Id: <1301905843-8003-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
X-OriginalArrivalTime: 04 Apr 2011 08:30:46.0451 (UTC) FILETIME=[9854D030:01CBF2A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 MAINTAINERS |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb702f3..bcd0972 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6916,6 +6916,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+XEN HYPERVISOR INTERFACE
+M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+L:	virtualization@lists.linux-foundation.org
+S:	Supported
+F:	arch/x86/xen/
+F:	drivers/*/xen-*front.c
+F:	drivers/xen/
+F:	arch/x86/include/asm/xen/
+F:	include/xen/
+
 XEN NETWORK BACKEND DRIVER
 M:	Ian Campbell <ian.campbell@citrix.com>
 L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
@@ -6936,18 +6948,6 @@ S:	Supported
 F:	arch/x86/xen/*swiotlb*
 F:	drivers/xen/*swiotlb*
 
-XEN HYPERVISOR INTERFACE
-M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
-M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
-L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
-L:	virtualization@lists.linux-foundation.org
-S:	Supported
-F:	arch/x86/xen/
-F:	drivers/*/xen-*front.c
-F:	drivers/xen/
-F:	arch/x86/include/asm/xen/
-F:	include/xen/
-
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
 M:	Alex Elder <aelder@sgi.com>
-- 
1.7.2.5

