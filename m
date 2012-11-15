Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768710Ab2KOSmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:42:07 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14573
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768466Ab2KOSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:42:04 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
X-WSS-ID: 0MDJL9Z-01-3W5-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
CC: <boris.ostrovsky@amd.com>, <herrmann.der.user@googlemail.com>,
        <bp@alien8.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, microcode, AMD: Add support for family 16h processors
Date: Thu, 15 Nov 2012 13:41:50 -0500
Message-ID: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add valid patch size for family 16h processors

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7720ff5..58790e8 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -190,6 +190,7 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
 #define F15H_MPB_MAX_SIZE 4096
+#define F16H_MPB_MAX_SIZE 3458
 
 	switch (c->x86) {
 	case 0x14:
@@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
 	case 0x15:
 		max_size = F15H_MPB_MAX_SIZE;
 		break;
+	case 0x16:
+		max_size = F16H_MPB_MAX_SIZE;
+		break;
 	default:
 		max_size = F1XH_MPB_MAX_SIZE;
 		break;
-- 
1.7.10.4


