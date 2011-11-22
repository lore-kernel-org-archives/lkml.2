Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1KVBLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:11:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1KVBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:11:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Axel Lin <axel.lin@gmail.com>, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/7] pcie-gadget-spear: Add "platform:" prefix for platform modalias
Date: Mon, 21 Nov 2011 17:10:29 -0800
Message-Id: <1321924234-26258-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321924234-26258-1-git-send-email-gregkh@suse.de>
References: <20111122005836.GA25420@kroah.com>
 <1321924234-26258-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Pratyush Anand <pratyush.anand@st.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.7.3

