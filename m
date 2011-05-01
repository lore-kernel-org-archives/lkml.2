Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1EAMhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 08:37:25 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:42841 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab1EAMhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 08:37:20 -0400
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 May 2011 08:37:19 EDT
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix spelling error in source code comment
Date: Sun, 1 May 2011 14:09:21 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-scst; KDE/4.6.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105011409.21629.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/lib/memcpy_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..2a560bb 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -49,7 +49,7 @@ ENTRY(memcpy)
 	jb .Lhandle_tail
 
 	/*
-	 * We check whether memory false dependece could occur,
+	 * We check whether memory false dependence could occur,
 	 * then jump to corresponding copy mode.
 	 */
 	cmp  %dil, %sil
-- 
1.7.3.4

