Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1CZBlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:41:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33493 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933155Ab1CZBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:40:20 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19SXkEalPhS7sU3ntkMSn/jD8VKIPLWjVPA8Lfa0a
	P3QE2s/KjIX1X+
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 12/27] staging/lirc: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:21 +0100
Message-Id: <1301103576-16109-12-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
References: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a very common spelling mistakes in
drivers/staging/lirc.

WRONG -> RIGHT
recieve     -> receive

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/lirc/lirc_ene0100.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/lirc/lirc_ene0100.h b/drivers/staging/lirc/lirc_ene0100.h
index 776b693..ed39aa8 100644
--- a/drivers/staging/lirc/lirc_ene0100.h
+++ b/drivers/staging/lirc/lirc_ene0100.h
@@ -81,7 +81,7 @@
 
 /* CIR block settings */
 #define ENE_CIR_CONF1		0xFEC0
-#define ENE_CIR_CONF1_ADC_ON	0x7	 /* reciever on gpio40 enabled */
+#define ENE_CIR_CONF1_ADC_ON	0x7	 /* receiver on gpio40 enabled */
 #define ENE_CIR_CONF1_LEARN1	(1 << 3) /* enabled on learning mode */
 #define ENE_CIR_CONF1_TX_ON	0x30	 /* enabled on transmit */
 #define ENE_CIR_CONF1_TX_CARR	(1 << 7) /* send TX carrier or not */
-- 
1.7.3.4

