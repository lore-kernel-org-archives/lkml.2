Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab1BYRLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:11:33 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28475 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab1BYRLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:11:31 -0500
X-IronPort-AV: E=Sophos;i="4.62,226,1297054800"; 
   d="scan'208";a="137550348"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 2/6] xen: do not use xen_info on HVM, set pv_info name to "Xen HVM"
Date: Fri, 25 Feb 2011 17:11:56 +0000
Message-Id: <1298653920-20299-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
References: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
X-OriginalArrivalTime: 25 Feb 2011 17:11:28.0923 (UTC) FILETIME=[0A9936B0:01CBD50F]
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

