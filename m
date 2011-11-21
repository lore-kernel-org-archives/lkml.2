Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1KUQni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:43:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43620 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1KUQng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:43:36 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/3]arch:powerpc:sysdev:mpic.c Remove extra semicolon.
Date: Mon, 21 Nov 2011 08:43:26 -0800
Message-Id: <1321893808-3721-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below removes an extra semicolon.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: linuxppc-dev@lists.ozlabs.org
CC: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/sysdev/mpic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 8c7e852..b3fa3d7 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -901,7 +901,7 @@ int mpic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 	if (vold != vnew)
 		mpic_irq_write(src, MPIC_INFO(IRQ_VECTOR_PRI), vnew);
 
-	return IRQ_SET_MASK_OK_NOCOPY;;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 void mpic_set_vector(unsigned int virq, unsigned int vector)
-- 
1.7.5.4

