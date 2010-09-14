Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0INEYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:24:51 -0400
Received: from mail.perches.com ([173.55.12.10]:1984 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0INEYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:13 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH next 04/16] arch/x86: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:50 -0700
Message-Id: <435f275c3a189b65b992ec838aa9f2c790bfe768.1284435709.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/smpboot.c |    2 +-
 arch/x86/kvm/mmu.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 63a1a55..b745b30 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -498,7 +498,7 @@ static void impress_friends(void)
 void __inquire_remote_apic(int apicid)
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
-	char *names[] = { "ID", "VERSION", "SPIV" };
+	const char * const names[] = { "ID", "VERSION", "SPIV" };
 	int timeout;
 	u32 status;
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d2dad65..2a7d567 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -56,7 +56,7 @@ enum {
 	AUDIT_POST_PTE_WRITE
 };
 
-char *audit_point_name[] = {
+const char * const audit_point_name[] = {
 	"pre page fault",
 	"post page fault",
 	"pre pte write",
-- 
1.7.3.rc1

