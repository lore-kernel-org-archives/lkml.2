Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1JaCUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 22:20:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45067 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1JaCUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 22:20:41 -0400
Message-ID: <1320027628.2690.1.camel@phoenix>
Subject: [PATCH] pcie-gadget-spear: Add "platform:" prefix for platform
 modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Date: Mon, 31 Oct 2011 10:20:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/spear13xx_pcie_gadget.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index cfbddbe..43d073b 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -903,6 +903,6 @@ static void __exit spear_pcie_gadget_exit(void)
 }
 module_exit(spear_pcie_gadget_exit);
 
-MODULE_ALIAS("pcie-gadget-spear");
+MODULE_ALIAS("platform:pcie-gadget-spear");
 MODULE_AUTHOR("Pratyush Anand");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4



