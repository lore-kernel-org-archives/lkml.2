Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab2EBC2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:28:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46094 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2EBC1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:27:41 -0400
From: Matt Turner <mattst88@gmail.com>
To: linux-alpha@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-kernel@vger.kernel.org, Jim Faulkner <jfaulkne@ccs.neu.edu>,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH 3/4] alpha: include module.h to fix modpost on Tsunami
Date: Tue,  1 May 2012 22:27:23 -0400
Message-Id: <1335925644-5192-3-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1335925644-5192-1-git-send-email-mattst88@gmail.com>
References: <1335925644-5192-1-git-send-email-mattst88@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Faulkner <jfaulkne@ccs.neu.edu>

Signed-off-by: Jim Faulkner <jfaulkne@ccs.neu.edu>
Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/kernel/core_tsunami.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/core_tsunami.c b/arch/alpha/kernel/core_tsunami.c
index 5e7c28f..61893d7 100644
--- a/arch/alpha/kernel/core_tsunami.c
+++ b/arch/alpha/kernel/core_tsunami.c
@@ -11,6 +11,7 @@
 #include <asm/core_tsunami.h>
 #undef __EXTERN_INLINE
 
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
-- 
1.7.3.4

