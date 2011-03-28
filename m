Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab1C1Qa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44058 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1C1Qa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=j21pLF7dHQI7H+Nh7xb3JFQTuIBa8rFXvDeajyPG7tkC9R87q2XeAtp63i5y+OHPMa
         AANNW4JZnRUVBjIFj6yEpAULJaMlPd4bi7N6or6dwWo6CqpyKy+Sn0IJZYZ4SnkZk5XS
         t9PvS94GqJLYuaxSPvYrrQls/JGellS4NlHB0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 03/25]arch:mips Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:26 -0700
Message-Id: <1301329788-3423-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/mips/include/asm/mach-powertv/dma-coherence.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/mach-powertv/dma-coherence.h b/arch/mips/include/asm/mach-powertv/dma-coherence.h
index f76029c..89435e8 100644
--- a/arch/mips/include/asm/mach-powertv/dma-coherence.h
+++ b/arch/mips/include/asm/mach-powertv/dma-coherence.h
@@ -13,7 +13,6 @@
 #define __ASM_MACH_POWERTV_DMA_COHERENCE_H
 
 #include <linux/sched.h>
-#include <linux/version.h>
 #include <linux/device.h>
 #include <asm/mach-powertv/asic.h>
 
-- 
1.7.4.1

