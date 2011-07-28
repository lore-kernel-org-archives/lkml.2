Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1G1FSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:18:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:51306 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1G1FQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 03/11] net: inet_timewait_sock doesnt need <linux/module.h>
Date: Thu, 28 Jul 2011 01:16:10 -0400
Message-Id: <1311830178-30314-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing module specific in this header, and removing
it doesn't seem to uncover any implicit dependencies either.
Must be simply a vestige of an ancient legacy.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/inet_timewait_sock.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index f1a7709..e3dfd97 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -18,7 +18,6 @@
 
 #include <linux/kmemcheck.h>
 #include <linux/list.h>
-#include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
-- 
1.7.6

