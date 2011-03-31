Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1CaOyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:54:55 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57425 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065Ab1CaOwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 13/21] arm: irq: export set flags
Date: Thu, 31 Mar 2011 15:54:07 +0100
Message-Id: <1301583255-28468-14-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 arch/arm/kernel/irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 3535d37..e4fd9e4 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -163,6 +163,7 @@ void set_irq_flags(unsigned int irq, unsigned int iflags)
 		desc->status &= ~IRQ_NOAUTOEN;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
+EXPORT_SYMBOL(set_irq_flags);
 
 void __init init_IRQ(void)
 {
-- 
1.7.3.4

