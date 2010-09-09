Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0IIWhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:37:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab0IIWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=inyWZee9ojEF1q1/9JQMZEMP6hpLRa6GGqeQ39dDaSg2xwz++TsPy2UXkWYjet1alg
         ctkqQNpvXgmC9O6GGkSZ3qTqKGil2WkK6brRzpMgF2rNIbVbP3BzPQOSmX/FneAv/lSq
         xJpblPE+r3VL1ULLOUyO3F4CR+wFK0te55V2g=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 134/223]drivers/serial/uartlite.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:41 -0700
Message-Id: <1284071862-8194-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/serial/uartlite.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index 9b03d7b..3fa2e16 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -44,7 +44,7 @@ MODULE_DEVICE_TABLE(of, ulite_of_match);
  * Register definitions
  *
  * For register details see datasheet:
- * http://www.xilinx.com/bvdocs/ipcenter/data_sheet/opb_uartlite.pdf
+ * http://www.xilinx.com/support/documentation/ip_documentation/opb_uartlite.pdf 
  */
 
 #define ULITE_RX		0x00
-- 
1.7.2.1

