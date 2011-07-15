Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1GORtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:49:31 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37214
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754028Ab1GOR37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 039/117] Staging: hv: vmbus: Cleanup unnecessary comments in hv.c
Date: Fri, 15 Jul 2011 10:46:27 -0700
Message-Id: <1310752065-27895-39-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup unnecessary comments in hv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 824f816..2f94880 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -164,11 +164,7 @@ int hv_init(void)
 		goto cleanup;
 
 	max_leaf = query_hypervisor_info();
-	/* HvQueryHypervisorFeatures(maxLeaf); */
 
-	/*
-	 * We only support running on top of Hyper-V
-	 */
 	rdmsrl(HV_X64_MSR_GUEST_OS_ID, hv_context.guestid);
 
 	if (hv_context.guestid != 0)
@@ -181,10 +177,6 @@ int hv_init(void)
 	/* See if the hypercall page is already set */
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
-	/*
-	* Allocate the hypercall page memory
-	* virtaddr = osd_page_alloc(1);
-	*/
 	virtaddr = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
 
 	if (!virtaddr)
-- 
1.7.4.1

