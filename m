Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab0KOVMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:12:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1389 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758323Ab0KOVMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:12:45 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Petko Manolov <petkan@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] drivers/net/usb: Remove unnecessary casts of netdev_priv
Date: Mon, 15 Nov 2010 13:12:29 -0800
Message-Id: <66a3d7996e4ce8a84610237e86adf4b15a48514a.1289855436.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289855436.git.joe@perches.com>
References: <cover.1289855436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/usb/pegasus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 6710f093..ef36676 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -359,7 +359,7 @@ fail:
 
 static int mdio_read(struct net_device *dev, int phy_id, int loc)
 {
-	pegasus_t *pegasus = (pegasus_t *) netdev_priv(dev);
+	pegasus_t *pegasus = netdev_priv(dev);
 	u16 res;
 
 	read_mii_word(pegasus, phy_id, loc, &res);
@@ -397,7 +397,7 @@ fail:
 
 static void mdio_write(struct net_device *dev, int phy_id, int loc, int val)
 {
-	pegasus_t *pegasus = (pegasus_t *) netdev_priv(dev);
+	pegasus_t *pegasus = netdev_priv(dev);
 
 	write_mii_word(pegasus, phy_id, loc, val);
 }
-- 
1.7.3.1.g432b3.dirty

