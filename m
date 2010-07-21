Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab0GURXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:23:09 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:34660
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752464Ab0GURWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:22:01 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5X435-01-7F3-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/7] x86, xsave: add __init attribute to setup_xstate_features()
Date: Wed, 21 Jul 2010 19:03:56 +0200
Message-ID: <1279731838-1522-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is called only from initialization code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/xsave.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 3b44a9b..cfc7901 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -370,7 +370,7 @@ static inline void xstate_enable(u64 mask)
  * Record the offsets and sizes of different state managed by the xsave
  * memory layout.
  */
-static void setup_xstate_features(void)
+static void __init setup_xstate_features(void)
 {
 	int eax, ebx, ecx, edx, leaf = 0x2;
 
-- 
1.7.1.1


