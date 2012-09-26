Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab2IZRTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:19:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757618Ab2IZRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922255"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH 10/12] cpu-hotplug.txt: fix comments of work_on_cpu()
Date: Thu, 27 Sep 2012 01:20:41 +0800
Message-Id: <1348680043-5077-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize complete at 2012/09/27 01:18:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a tiny fix of the comments of work_on_cpu() which is changed
back to use workqueue and it can be run at some time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/cpu-hotplug.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index 66ef8f3..d19c5fd 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -317,7 +317,7 @@ Q: I need to ensure that a particular cpu is not removed when there is some
    work specific to this cpu is in progress.
 A: There are two ways.  If your code can be run in interrupt context, use
    smp_call_function_single(), otherwise use work_on_cpu().  Note that
-   work_on_cpu() is slow, and can fail due to out of memory:
+   work_on_cpu() is slow:
 
 	int my_func_on_cpu(int cpu)
 	{
-- 
1.7.7.6

