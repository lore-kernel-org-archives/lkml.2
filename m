Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1B0SOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 13:14:08 -0500
Received: from www.tglx.de ([62.245.132.106]:43513 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab1B0SOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 13:14:04 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] x86: dt: remove the statement where we ignore lapic
Date: Sun, 27 Feb 2011 19:13:39 +0100
Message-Id: <1298830419-22681-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <tip-a906fdaacca49917d83e5032dfc31f694249ad10@git.kernel.org>
References: <tip-a906fdaacca49917d83e5032dfc31f694249ad10@git.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until "x86: dt: Cleanup local apic setup" we read the lapic's address
from the MSR and ignored the entry in DT. Reflect this change the
documentation.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 .../devicetree/bindings/x86/interrupt.txt          |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/x86/interrupt.txt b/Documentation/devicetree/bindings/x86/interrupt.txt
index 8b0efb0..7d19f49 100644
--- a/Documentation/devicetree/bindings/x86/interrupt.txt
+++ b/Documentation/devicetree/bindings/x86/interrupt.txt
@@ -24,6 +24,3 @@ Interrupt chips
   Required property:
 
      compatible = "intel,ce4100-lapic";
-
-  This node is currently unused by Linux as the address of the local APIC
-  read from a MSR.
-- 
1.7.4

