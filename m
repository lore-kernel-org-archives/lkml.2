Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0IDBSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:18:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59457 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab0IDBSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qHXNGRBm/bfZD1HzHKcaDnn4hu+Yt2aVhMo6T0RCq8LwoWQgIAv11oRu1+RvI91Nxm
         4gRD4Uk9cVdMYz1x4j3piBwKoyJ9fohefMBttX0wIbvlI1GvTdsM9sKqnVI5qT+L+vNH
         pZP3acELwtmFhZ4Ad2ydhcbK7OLn+3QuMhP6g=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: [PATCH 10/12] x86: Remove PSHUFB_XMM5_* macros
Date: Fri,  3 Sep 2010 21:17:17 -0400
Message-Id: <1283563039-3466-11-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PSHUFB_XMM5_* macros are no longer used.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 42b507e..907967e 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -465,7 +465,4 @@ extern void fpu_finit(struct fpu *fpu);
 
 #endif /* __ASSEMBLY__ */
 
-#define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
-#define PSHUFB_XMM5_XMM6 .byte 0x66, 0x0f, 0x38, 0x00, 0xf5
-
 #endif /* _ASM_X86_I387_H */
-- 
1.7.2.2

