Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab1FAPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 11:25:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34703 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FAPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 11:25:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qMn/Y57ExLvo9/BnZMaZnfAv0Vna9DSyRCfyMidUuh6DHtWrwL7HSvYdIueDP2FJaa
         vyxmOvC+yQScgR/lB+QxzixxqDgrcWkhxnCUdg7ccKz7TjWMBO51ZA6M2vCJRrDptkyZ
         cInt93b839O0pwY3tHpcrnueOogV6RPs+m/zM=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] avr32:fix build error in at32ap700x.c
Date: Wed,  1 Jun 2011 23:25:13 +0800
Message-Id: <1306941914-6262-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The portnr is undeclared. This build error is introduced by commit
2b348e2f82f532e3aff8e0ce9293033b3294c1e0

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index aa677e2..1b7ad97 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1044,7 +1044,7 @@ void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
 	}
 
 	pdata = pdev->dev.platform_data;
-	pdata->num = portnr;
+	pdata->num = line;
 	at32_usarts[line] = pdev;
 }
 
-- 
1.7.4.1

