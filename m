Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab2C2RTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:19:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:35242 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab2C2RT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:19:29 -0400
X-IronPort-AV: E=Sophos;i="4.75,338,1330923600"; 
   d="scan'208";a="23660759"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: konrad.wilk@oracle.com
CC: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 1/2] xen: EXPORT_SYMBOL set_phys_to_machine
Date: Thu, 29 Mar 2012 18:20:39 +0100
Message-ID: <1333041640-12419-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/p2m.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 1b267e7..7ece122 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -654,6 +654,7 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(set_phys_to_machine);
 
 #define M2P_OVERRIDE_HASH_SHIFT	10
 #define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
-- 
1.7.2.5

