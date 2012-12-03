Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2LCNLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:11:18 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36644 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2LCNLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:11:17 -0500
MIME-Version: 1.0
Date: Mon, 3 Dec 2012 08:11:17 -0500
Message-ID: <CAPgLHd87JfwfhHVyBSSsqCCay8=U5Szv1My-Dvtf93M+AtKAkQ@mail.gmail.com>
Subject: [PATCH -next] firewire: net: remove unused variable in fwnet_receive_broadcast()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: stefanr@s5r6.in-berlin.de
Cc: yongjun_wei@trendmicro.com.cn, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable card is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/firewire/net.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 638e1f7..e7a711f5 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -828,7 +828,6 @@ static void fwnet_receive_broadcast(struct fw_iso_context *context,
 {
 	struct fwnet_device *dev;
 	struct fw_iso_packet packet;
-	struct fw_card *card;
 	__be16 *hdr_ptr;
 	__be32 *buf_ptr;
 	int retval;
@@ -840,7 +839,6 @@ static void fwnet_receive_broadcast(struct fw_iso_context *context,
 	unsigned long flags;
 
 	dev = data;
-	card = dev->card;
 	hdr_ptr = header;
 	length = be16_to_cpup(hdr_ptr);
 

