Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2LQBmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 20:42:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab2LQBmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 20:42:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,297,1355068800"; 
   d="scan'208";a="6411089"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, tangchen@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, mingo@elte.hu,
        penberg@kernel.org
Cc: torvalds@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] memory-hotplug: Disable CONFIG_MOVABLE_NODE option by default.
Date: Mon, 17 Dec 2012 09:41:28 +0800
Message-Id: <1355708488-2913-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1355708488-2913-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1355708488-2913-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/17 09:41:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/17 09:41:39,
	Serialize complete at 2012/12/17 09:41:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set CONFIG_MOVABLE_NODE to "default n" instead of
"depends on BROKEN".

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 4913333..bbd6bfa 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -149,7 +149,7 @@ config MOVABLE_NODE
 	depends on NO_BOOTMEM
 	depends on X86_64
 	depends on NUMA
-	depends on BROKEN
+	default n
 	help
 	  Allow a node to have only movable memory. Pages used by the kernel,
 	  such as direct mapping pages can not be migrated. So the corresponding
-- 
1.7.10.1

