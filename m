Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1DVRJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:09:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33664 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab1DVRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o7ybjy9jh0B+kdzj285AwqtFXvpgky9Q3e/9PLaeTOPnRC2QXW5n89LEVKfSsUHyi+
         pwjH1/V5tAn+vejXnsRvkwctEmZf1irZaqY6O6ANk8dKWchHE1FcsP6Vw61XnhXslZlD
         D3KrsqxB50ojvR+Hr4nzti5AOuSF4QC0hR5Ig=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]arch:x86:kernel:cpu:perf_event_p4.c Typo: change indexig to indexing.
Date: Fri, 22 Apr 2011 10:08:52 -0700
Message-Id: <1303492132-3004-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo in a comment.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c2520e1..276adb9 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1188,7 +1188,7 @@ static __init int p4_pmu_init(void)
 {
 	unsigned int low, high;
 
-	/* If we get stripped -- indexig fails */
+	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > X86_PMC_MAX_GENERIC);
 
 	rdmsr(MSR_IA32_MISC_ENABLE, low, high);
-- 
1.7.4.4

