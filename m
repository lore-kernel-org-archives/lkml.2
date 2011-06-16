Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab1FPUMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:12:03 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:32887
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758706Ab1FPUCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 41/77] Staging: hv: vmbus: Cleanup unnecessary comments in hv.c
Date: Thu, 16 Jun 2011 13:17:14 -0700
Message-Id: <1308255470-3826-41-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup unnecessary comments in hv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
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

