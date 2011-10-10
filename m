Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961Ab1JJPqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:46:20 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:59560 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702Ab1JJPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:46:18 -0400
From: Eric B Munson <emunson@mgebm.net>
To: avi@redhat.com
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH] Fix include dependency for mmu_notifier
Date: Mon, 10 Oct 2011 11:46:15 -0400
Message-Id: <1318261575-24256-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kvm_host struct can include an mmu_notifier struct but mmu_notifier.h is
not included directly.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 include/linux/kvm_host.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eabb21a..d2c79a9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -14,6 +14,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/mmu_notifier.h>
 #include <linux/preempt.h>
 #include <linux/msi.h>
 #include <linux/slab.h>
-- 
1.7.4.1

