Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152Ab2JWXlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:41:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47180 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JWXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:41:07 -0400
Message-ID: <50872B0C.6040001@jp.fujitsu.com>
Date: Tue, 23 Oct 2012 19:41:00 -0400
From: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: muneda.takahiro@jp.fujitsu.com, dave@gnu.org
Subject: [PATCH] Documentation/filesystems/proc.txt alignment
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A word was left behind...

Signed-off-by: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>
Cc: Davidlohr Bueso <dave@gnu.org>
---
 Documentation/filesystems/proc.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt
b/Documentation/filesystems/proc.txt
index a1793d6..df358b1 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -33,8 +33,7 @@ Table of Contents
   2	Modifying System Parameters

   3	Per-Process Parameters
-  3.1	/proc/<pid>/oom_score_adj - Adjust the oom-killer
-								score
+  3.1	/proc/<pid>/oom_score_adj - Adjust the oom-killer score
   3.2	/proc/<pid>/oom_score - Display current oom-killer score
   3.3	/proc/<pid>/io - Display the IO accounting fields
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
-- 
1.7.1

