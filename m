Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1KDCYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:24:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab1KDCYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:24:47 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/2] X86 apic: Make enable_IR static
Date: Fri,  4 Nov 2011 03:24:31 +0100
Message-Id: <1320373471-3942-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1320373471-3942-1-git-send-email-trenn@suse.de>
References: <1320373471-3942-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used anywhere else.


Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a2fd72e..4a5bccb 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1435,7 +1435,7 @@ void enable_x2apic(void)
 }
 #endif /* CONFIG_X86_X2APIC */
 
-int __init enable_IR(void)
+static int __init enable_IR(void)
 {
 #ifdef CONFIG_IRQ_REMAP
 	if (!intr_remapping_supported()) {
-- 
1.7.6.1

