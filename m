Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab1A1Tsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:48:33 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:42680 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1A1Tsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:48:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Bx4bElGmc2s5v8/gIl2NQGS6l9y7VSBuvl6VmJUyEgMYDDTgQzv66Sgt2RblAt95AM
         +ifudXPtsOOYrBJQriECtfr9wNL+6Jn+WX1kD8csAbr65F3hr5vpDZR5rLi3rm183i/7
         FV/avsW+REyTViCSnV3uoQ7V2vgC7yCyPMGjs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:dma:coh901318.c Change initate to initiate.
Date: Fri, 28 Jan 2011 11:48:18 -0800
Message-Id: <1296244098-3732-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a typo or not. if it is then feel free to take this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/dma/coh901318.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index a665683..00deabd 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -849,7 +849,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 
 				/* Must clear TC interrupt before calling
 				 * dma_tc_handle
-				 * in case tc_handle initate a new dma job
+				 * in case tc_handle initiate a new dma job
 				 */
 				__set_bit(i, virtbase + COH901318_TC_INT_CLEAR1);
 
@@ -894,7 +894,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 				}
 				/* Must clear TC interrupt before calling
 				 * dma_tc_handle
-				 * in case tc_handle initate a new dma job
+				 * in case tc_handle initiate a new dma job
 				 */
 				__set_bit(i, virtbase + COH901318_TC_INT_CLEAR2);
 
-- 
1.6.5.GIT

