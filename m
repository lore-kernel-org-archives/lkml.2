Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab1CXTbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:31:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60296 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933877Ab1CXT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xzbA7Qptd2lX+i4T4cax+tBnRPiae/RnDXs78YA/RUbeTmnbadQPs4wgJZuqaWyVDa
         I5kiVVHDBRIiRnDWIqPwpwP5wLmhvlGY6QZnw41VinGdL5ETj7UW7Hrj3SH56lab4kjo
         eQs5Jg4M9hAuC3dmUHYYS28/YRWmaYi9zpjSk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 02/21]arch:ia64 Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:40 -0700
Message-Id: <1300994819-30930-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/include/asm/asmmacro.h |    4 ++--
 arch/ia64/include/asm/mca_asm.h  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/asmmacro.h b/arch/ia64/include/asm/asmmacro.h
index 3ab6d75..3c3904b 100644
--- a/arch/ia64/include/asm/asmmacro.h
+++ b/arch/ia64/include/asm/asmmacro.h
@@ -92,12 +92,12 @@ name:
 1:{ .mib;						\
 	nop.m 0;					\
 	mov r16=ar.pfs;					\
-	br.call.sptk.many b7=2f;;			\
+	br.call.sptk.many b7=2f;			\
   };							\
 2:{ .mib;						\
 	nop.m 0;					\
 	mov ar.pfs=r16;					\
-	br.ret.sptk.many b6;;				\
+	br.ret.sptk.many b6;				\
   }
 #else
 # define FSYS_RETURN	br.ret.sptk.many b6
diff --git a/arch/ia64/include/asm/mca_asm.h b/arch/ia64/include/asm/mca_asm.h
index dd2a5b1..d57d3c0 100644
--- a/arch/ia64/include/asm/mca_asm.h
+++ b/arch/ia64/include/asm/mca_asm.h
@@ -46,11 +46,11 @@
  *	1. Put 0x7 in bits 61 thru 63.
  */
 #define DATA_PA_TO_VA(addr,temp)							\
-	mov	temp	= 0x7	;;							\
+	mov	temp	= 0x7;							\
 	dep	addr	= temp, addr, 61, 3
 
 #define GET_THIS_PADDR(reg, var)		\
-	mov	reg = IA64_KR(PER_CPU_DATA);;	\
+	mov	reg = IA64_KR(PER_CPU_DATA);	\
         addl	reg = THIS_CPU(var), reg
 
 /*
@@ -82,7 +82,7 @@
 	;;										\
 	dep	old_psr = 0, old_psr, 32, 32;						\
 											\
-	mov	ar.rsc = 0 ;								\
+	mov	ar.rsc = 0;								\
 	;;										\
 	srlz.d;										\
 	mov	temp2 = ar.bspstore;							\
-- 
1.7.4.1

