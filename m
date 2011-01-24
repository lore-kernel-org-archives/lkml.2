Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1AXEaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:30:05 -0500
Received: from www.tglx.de ([62.245.132.106]:42966 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1AXEaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:30:02 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH TIP 14/14] x86/pci: remove warning
Date: Mon, 24 Jan 2011 09:59:02 +0530
Message-Id: <1295843342-1122-15-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

|arch/x86/pci/ce4100.c: In function `ce4100_conf_read':
|arch/x86/pci/ce4100.c:257:9: warning: unused variable `retval'

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/pci/ce4100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
index 85b68ef..c63c6d3 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -254,7 +254,7 @@ int bridge_read(unsigned int devfn, int reg, int len, u32 *value)
 static int ce4100_conf_read(unsigned int seg, unsigned int bus,
 			    unsigned int devfn, int reg, int len, u32 *value)
 {
-	int i, retval = 1;
+	int i;
 
 	if (bus == 1) {
 		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
-- 
1.7.3.2

