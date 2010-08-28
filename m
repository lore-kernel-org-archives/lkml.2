Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0H1QFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:05:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55325 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0H1QFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:05:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Wz0xzN1pE0EeFHzOMZl3myqrPu+ssiXkNfuUOnt1zhxT41o/qV/FZj3wISQQa0k+i6
         KR2eq9emlO7PbRzf7tmr89v/NCiSlIjDVFdmebbt309asUsiqQLyOCvAC2WNhMbgCqyX
         iRbTZkosVrgpqwlmz5zyQPbzpltxYIAP/zZP8=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] x86: Remove PSHUFB_XMM5_* macros
Date: Sat, 28 Aug 2010 12:04:38 -0400
Message-Id: <1283011478-27237-12-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PSHUFB_XMM5_* macros are no longer used.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 3b4675d..eeeca88 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -421,7 +421,4 @@ extern void fpu_finit(struct fpu *fpu);
 
 #endif /* __ASSEMBLY__ */
 
-#define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
-#define PSHUFB_XMM5_XMM6 .byte 0x66, 0x0f, 0x38, 0x00, 0xf5
-
 #endif /* _ASM_X86_I387_H */
-- 
1.7.2.2

