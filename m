Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab2GENL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:11:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756Ab2GENL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:11:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 2/2] xen, fix x86_hyper_xen_hvm symbol export
Date: Thu,  5 Jul 2012 09:11:17 -0400
Message-Id: <1341493877-16622-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1341493877-16622-1-git-send-email-prarit@redhat.com>
References: <1341493877-16622-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be EXPORT_SYMBOL_GPL.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index ff962d4..f381f59 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1566,5 +1566,5 @@ const struct hypervisor_x86 x86_hyper_xen_hvm __refconst = {
 	.detect			= xen_hvm_platform,
 	.init_platform		= xen_hvm_guest_init,
 };
-EXPORT_SYMBOL(x86_hyper_xen_hvm);
+EXPORT_SYMBOL_GPL(x86_hyper_xen_hvm);
 #endif
-- 
1.7.9.3

