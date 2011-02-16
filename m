Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1BPRyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:54:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37402 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1BPRxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:53:15 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291611600"; 
   d="scan'208";a="136190311"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 2/7] xen: do not use xen_info on HVM, set pv_info name to "Xen HVM"
Date: Wed, 16 Feb 2011 17:53:02 +0000
Message-Id: <1297878787-378-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop>
X-OriginalArrivalTime: 16 Feb 2011 17:53:14.0026 (UTC) FILETIME=[6209D8A0:01CBCE02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/xen/enlighten.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 50542ef..2f67e2e 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1284,8 +1284,7 @@ static int init_hvm_pv_info(int *major, int *minor)
 
 	xen_setup_features();
 
-	pv_info = xen_info;
-	pv_info.kernel_rpl = 0;
+	pv_info.name = "Xen HVM";
 
 	xen_domain_type = XEN_HVM_DOMAIN;
 
-- 
1.5.6.5

