Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab1KWAul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:50:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257Ab1KWAlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:41:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:07 2011
Message-Id: <20111123002407.046795234@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Pratyush Anand <pratyush.anand@st.com>
Subject: [26/53] pcie-gadget-spear: Add "platform:" prefix for platform modalias
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 161f14191dc166c4e3f37f68af1bc199c6868b7d upstream.

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/spear13xx_pcie_gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -903,6 +903,6 @@ static void __exit spear_pcie_gadget_exi
 }
 module_exit(spear_pcie_gadget_exit);
 
-MODULE_ALIAS("pcie-gadget-spear");
+MODULE_ALIAS("platform:pcie-gadget-spear");
 MODULE_AUTHOR("Pratyush Anand");
 MODULE_LICENSE("GPL");


