Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab0LBKMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:12:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59502 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751434Ab0LBKMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:12:16 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1/3OMBDdZP39C0J/wQXGl7J2VOnrvv8kOTqjzyooY
	Y+ky76XbVQIeh5
Date: Thu, 2 Dec 2010 11:10:06 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 6/6] fanotify: remove obsolete flag FAN_MARK_ONDIR
Message-ID: <20101202101006.GG5196@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The FAN_MARK_ONDIR flag is not longer needed, so we can remove it.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 include/linux/fanotify.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index d6ec57a..8533799 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -52,10 +52,6 @@
 #define FAN_MARK_IGNORED_MASK	0x00000020
 #define FAN_MARK_IGNORED_SURV_MODIFY	0x00000040
 #define FAN_MARK_FLUSH		0x00000080
-#ifdef __KERNEL__
-/* not valid from userspace, only kernel internal */
-#define FAN_MARK_ONDIR		0x00000100
-#endif
 
 #define FAN_ALL_MARK_FLAGS	(FAN_MARK_ADD |\
 				 FAN_MARK_REMOVE |\
-- 
1.5.6.5

