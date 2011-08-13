Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HMA0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:26:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56742 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1HMA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:26:38 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/4]arch:mips:kernel Fix typo "shud"
Date: Fri, 12 Aug 2011 17:26:11 -0700
Message-Id: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes a typo.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/kernel/cevt-bcm1480.c |    2 +-
 arch/mips/kernel/cevt-sb1250.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/cevt-bcm1480.c b/arch/mips/kernel/cevt-bcm1480.c
index 36c3898..c8d0577 100644
--- a/arch/mips/kernel/cevt-bcm1480.c
+++ b/arch/mips/kernel/cevt-bcm1480.c
@@ -63,7 +63,7 @@ static void sibyte_set_mode(enum clock_event_mode mode,
 		__raw_writeq(0, cfg);
 		break;
 
-	case CLOCK_EVT_MODE_UNUSED:	/* shuddup gcc */
+	case CLOCK_EVT_MODE_UNUSED:	/* quiet gcc */
 	case CLOCK_EVT_MODE_RESUME:
 		;
 	}
diff --git a/arch/mips/kernel/cevt-sb1250.c b/arch/mips/kernel/cevt-sb1250.c
index 590c54f..c189741 100644
--- a/arch/mips/kernel/cevt-sb1250.c
+++ b/arch/mips/kernel/cevt-sb1250.c
@@ -61,7 +61,7 @@ static void sibyte_set_mode(enum clock_event_mode mode,
 		__raw_writeq(0, cfg);
 		break;
 
-	case CLOCK_EVT_MODE_UNUSED:	/* shuddup gcc */
+	case CLOCK_EVT_MODE_UNUSED:	/* quiet gcc */
 	case CLOCK_EVT_MODE_RESUME:
 		;
 	}
-- 
1.7.6

