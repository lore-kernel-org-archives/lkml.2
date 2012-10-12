Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985Ab2JLRMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:12:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1945928Ab2JLRMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:12:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,578,1344182400"; 
   d="scan'208";a="5990991"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/4] srcu: add my name
Date: Sat, 13 Oct 2012 01:14:14 +0800
Message-Id: <1350062057-2439-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
References: <1350062057-2439-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/13 01:12:06,
	Serialize complete at 2012/10/13 01:12:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed a lot for srcu, add my name here, thus any one can blame/contact
to me when needed.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/srcu.h |    2 ++
 kernel/srcu.c        |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 55a5c52..a55ddb1 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -16,8 +16,10 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
+ * Copyright (C) Fujitsu, 2012
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
+ *	   Lai Jiangshan <laijs@cn.fujitsu.com>
  *
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU/ *.txt
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 2095be3..610486d 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -16,8 +16,10 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2006
+ * Copyright (C) Fujitsu, 2012
  *
  * Author: Paul McKenney <paulmck@us.ibm.com>
+ *	   Lai Jiangshan <laijs@cn.fujitsu.com>
  *
  * For detailed explanation of Read-Copy Update mechanism see -
  * 		Documentation/RCU/ *.txt
-- 
1.7.7.6

