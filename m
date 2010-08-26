Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0HaCYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:24:44 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56519 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab0HaCYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o75F/8EUM+L1QvYtSL2HB2XdTABGtwqsi6jnvHmSry2dcxhVfwvDwolYqdrGrNQeP5
         Dyzb56YkwEW3BJqWAxVJccvUC0kJsPOE8UvgndsiOspIdm1VZBMA8dTHq5p8sJfQ2TQk
         ptWWMIsTwlwE25n54AWZa0UM8E1Z3aTHTlQ/Q=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH 1/1] ARM: pxa168: fix corrected reset vector
Date: Thu, 26 Aug 2010 05:07:29 -0400
Message-Id: <1282813649-8332-2-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282813649-8332-1-git-send-email-mark.brown314@gmail.com>
References: <1282813649-8332-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/include/mach/system.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mmp/include/mach/system.h b/arch/arm/mach-mmp/include/mach/system.h
index 4f5b0e0..926e9c0 100644
--- a/arch/arm/mach-mmp/include/mach/system.h
+++ b/arch/arm/mach-mmp/include/mach/system.h
@@ -16,6 +16,6 @@ static inline void arch_idle(void)
 
 static inline void arch_reset(char mode, const char *cmd)
 {
-	cpu_reset(0);
+	cpu_reset(0xffff0000);
 }
 #endif /* __ASM_MACH_SYSTEM_H */
-- 
1.7.0.4

