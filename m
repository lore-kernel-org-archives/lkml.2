Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab2HaGFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 02:05:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:23513 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2HaGFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 02:05:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,345,1344236400"; 
   d="scan'208";a="193934032"
From: gang.wei@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        joseph.cihula@intel.com, hpa@zytor.com,
        richard.l.maliszewski@intel.com, shane.wang@intel.com,
        tboot-devel@lists.sourceforge.net, mingo@redhat.com,
        tglx@linutronix.de, joe@perches.com, Gang Wei <gang.wei@intel.com>
Subject: [PATCH V2] MAINTAINERS: fix TXT maintainer list and source repo path
Date: Fri, 31 Aug 2012 14:05:59 +0800
Message-Id: <1346393159-29731-1-git-send-email-gang.wei@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gang Wei <gang.wei@intel.com>

Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 MAINTAINERS |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fdc0119..987ad0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3666,11 +3666,12 @@ F:	Documentation/networking/README.ipw2200
 F:	drivers/net/wireless/ipw2x00/
 
 INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
-M:	Joseph Cihula <joseph.cihula@intel.com>
+M:	Richard L Maliszewski <richard.l.maliszewski@intel.com>
+M:	Gang Wei <gang.wei@intel.com>
 M:	Shane Wang <shane.wang@intel.com>
 L:	tboot-devel@lists.sourceforge.net
 W:	http://tboot.sourceforge.net
-T:	Mercurial http://www.bughost.org/repos.hg/tboot.hg
+T:	hg http://tboot.hg.sourceforge.net:8000/hgroot/tboot/tboot
 S:	Supported
 F:	Documentation/intel_txt.txt
 F:	include/linux/tboot.h
-- 
1.7.7.6

