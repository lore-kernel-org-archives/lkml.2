Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1DDI0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 04:26:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42246 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1DDI0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 04:26:12 -0400
X-IronPort-AV: E=Sophos;i="4.63,296,1299474000"; 
   d="scan'208";a="143380938"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, netdev@vger.kernel.org,
        xen-devel@lists.xensource.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: add entry for Xen network backend
Date: Mon,  4 Apr 2011 09:26:07 +0100
Message-Id: <1301905567-7880-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
X-OriginalArrivalTime: 04 Apr 2011 08:26:11.0107 (UTC) FILETIME=[F436A730:01CBF2A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: netdev@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b4b9cd..bb702f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6916,6 +6916,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+XEN NETWORK BACKEND DRIVER
+M:	Ian Campbell <ian.campbell@citrix.com>
+L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
+S:	Supported
+F:	drivers/net/xen-netback/*
+
 XEN PCI SUBSYSTEM
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
 L:	xen-devel@lists.xensource.com (moderated for non-subscribers)
-- 
1.7.2.5

