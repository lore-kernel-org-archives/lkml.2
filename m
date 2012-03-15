Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965420Ab2COWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:16:57 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:49602 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965031Ab2COWQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:16:55 -0400
From: Eric B Munson <emunson@mgebm.net>
To: mtosatti@redhat.com
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, jan.kiszka@siemens.com,
        avi@redhat.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unneeded EXPORT macro
Date: Thu, 15 Mar 2012 18:16:49 -0400
Message-Id: <1331849809-17034-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_and_clear_guest_paused does not need to be exported as it isn't used
by any modules, remove the export.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: jan.kiszka@siemens.com
Cc: avi@redhat.com
Cc: kvm@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/kvmclock.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 4ba090c..086eb58 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -133,7 +133,6 @@ bool kvm_check_and_clear_guest_paused(void)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_check_and_clear_guest_paused);
 
 static struct clocksource kvm_clock = {
 	.name = "kvm-clock",
-- 
1.7.5.4

