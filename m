Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab1ETTNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:13:48 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34437 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935760Ab1ETTNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:41 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
	ARCHITECTURE...),
        Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE...),
        "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...),
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        "Gustavo F. Padovan" <padovan@profusion.mobi> (commit_signer:1/1=100%)
Subject: [PATCH 5/8] x86: Kill set but not used warning in test_NX()
Date: Fri, 20 May 2011 16:13:02 -0300
Message-Id: <1305918786-7239-5-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305918786-7239-4-git-send-email-padovan@profusion.mobi>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-4-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 arch/x86/kernel/test_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
index 787a5e4..3f92ce0 100644
--- a/arch/x86/kernel/test_nx.c
+++ b/arch/x86/kernel/test_nx.c
@@ -161,7 +161,7 @@ static int test_NX(void)
 	}
 
 #endif
-	return 0;
+	return ret;
 }
 
 static void test_exit(void)
-- 
1.7.5.1

