Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0IMGtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:49:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:58258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0IMGs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:48:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,358,1280732400"; 
   d="scan'208";a="323825490"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, alan@linux.intel.com, greg@kroah.com,
        Feng Tang <feng.tang@intel.com>, x86@kernel.org
Subject: [PATCH v3 1/4] x86, mrst: make mrst_identify_cpu() inlne inside mrst.h
Date: Mon, 13 Sep 2010 15:08:53 +0800
Message-Id: <1284361736-23011-2-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise there will be some compilation warning for those .c
files which include mrst.h

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/mrst.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 1635074..33fc296 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -26,7 +26,7 @@ enum mrst_cpu_type {
 };
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
-static enum mrst_cpu_type mrst_identify_cpu(void)
+static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
-- 
1.7.0.4

