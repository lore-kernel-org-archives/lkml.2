Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab2BHQUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:20:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40617 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2BHQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:20:52 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: grant.likely@secretlab.ca, trivial@kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, giancarlo.asnaghi@st.com,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH] trivial: spi-pl022.c: fix a wrong kerneldoc comment
Date: Wed,  8 Feb 2012 17:23:33 +0100
Message-Id: <1328718213-17375-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/spi/spi-pl022.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 2f9cb43..286572d 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1495,7 +1495,7 @@ out:
 
 /**
  * pump_messages - Workqueue function which processes spi message queue
- * @data: pointer to private data of SSP driver
+ * @work: pointer to the pump_messages work structure within pl022 structure
  *
  * This function checks if there is any spi message in the queue that
  * needs processing and delegate control to appropriate function
-- 
1.7.7.6

