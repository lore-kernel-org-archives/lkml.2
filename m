Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1KSMvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 07:51:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1KSMui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 07:50:38 -0500
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/3] sysctl-include-fix.patch
Date: Sat, 19 Nov 2011 13:50:27 +0100
Message-Id: <1321707028-12487-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
References: <1321707028-12487-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cherry-picked for v3.0-rt and fixed minor merge conflict
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/sysctl.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..92b99dd 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -931,6 +931,7 @@ enum
 #ifdef __KERNEL__
 #include <linux/list.h>
 #include <linux/rcupdate.h>
+#include <linux/atomic.h>
 
 /* For the /proc/sys support */
 struct ctl_table;
-- 
1.7.2.3

