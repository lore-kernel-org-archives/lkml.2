Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2IJIyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:54:04 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:27136 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab2IJIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcCAHGoTVBbdWObgWdsb2JhbABFhUBHtUoiAQEWJieCIQEFIw8BRhAlAiYCAlcGE4gUqBWSO4EhiXuFG4ESA5VdiTOJUoFY
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262497"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 07/20] Staging: ipack/bridges/tpci200: remove struct list_head
Date: Mon, 10 Sep 2012 10:51:45 +0200
Message-Id: <1347267118-9580-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the linked list was removed before, delete the useless struct list_head

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index af48295..0fc1900 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -161,7 +161,6 @@ struct tpci200_infos {
 	struct ipack_bus_device		*ipack_bus;
 };
 struct tpci200_board {
-	struct list_head	list;
 	unsigned int		number;
 	struct mutex		mutex;
 	struct tpci200_slot	*slots;
-- 
1.7.10.4

