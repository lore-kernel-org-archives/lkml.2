Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0LQPe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:34:58 -0500
Received: from www.tglx.de ([62.245.132.106]:60880 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab0LQPey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:34:54 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org, dirk.brandewie@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 15/15] x86/pci: remove warning
Date: Fri, 17 Dec 2010 16:33:53 +0100
Message-Id: <1292600033-12271-16-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
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

