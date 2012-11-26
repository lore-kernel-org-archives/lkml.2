Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2KZXUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:20:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:30688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab2KZXUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:20:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="224670567"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3 2/3] x86/nmi: export local_touch_nmi() symbol for modules
Date: Mon, 26 Nov 2012 07:19:51 -0800
Message-Id: <1353943192-20298-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353943192-20298-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1353943192-20298-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/nmi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index f84f5c5..6030805 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -509,3 +509,4 @@ void local_touch_nmi(void)
 {
 	__this_cpu_write(last_nmi_rip, 0);
 }
+EXPORT_SYMBOL_GPL(local_touch_nmi);
-- 
1.7.9.5

