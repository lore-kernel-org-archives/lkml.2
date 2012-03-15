Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2COOLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:11:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47870 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab2COOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:11:35 -0400
X-IronPort-AV: E=Sophos;i="4.73,591,1325433600"; 
   d="scan'208";a="4543387"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
        risrajak@linux.vnet.ibm.com, yanegomi@gmail.com,
        shubham@linux.vnet.ibm.com, vapier@gentoo.org,
        subrata@linux.vnet.ibm.com, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Cyril Hrubis <chrubis@suse.cz>, Caspar Zhang <caspar@casparzhang.com>
Subject: [PATCH] MAINTAINERS: update the maintain-ship of LTP
Date: Thu, 15 Mar 2012 22:10:21 +0800
Message-Id: <1331820621-10095-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.rc1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-15 22:09:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-15 22:09:28,
	Serialize complete at 2012-03-15 22:09:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maintain-ship of LTP is out of date, so update it.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
---
 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95e4e43..3e10e6f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4173,12 +4173,14 @@ F:	Documentation/hwmon/ltc4261
 F:	drivers/hwmon/ltc4261.c
 
 LTP (Linux Test Project)
-M:	Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
-M:	Garrett Cooper <yanegomi@gmail.com>
+M:	Shubham Goyal <shubham@linux.vnet.ibm.com>
 M:	Mike Frysinger <vapier@gentoo.org>
-M:	Subrata Modak <subrata@linux.vnet.ibm.com>
+M:	Cyril Hrubis <chrubis@suse.cz>
+M:	Caspar Zhang <caspar@casparzhang.com>
+M:	Wanlong Gao <gaowanlong@cn.fujitsu.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
+T:	git git://github.com/linux-test-project/ltp.git
 T:	git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:	Maintained
 
-- 
1.7.10.rc1

