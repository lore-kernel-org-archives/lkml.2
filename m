Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab2IKLiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:38:14 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:26724 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab2IKLem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4CAIAhT1BbdWObgWdsb2JhbABFhUBHtUkiAQEWJieCIQEFIw8BRhAlAiYCAlcGE4gUqGiTN4EhiXiFC4ESA5VdiTOJUoFY
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505339"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 07/20] Staging: ipack/bridges/tpci200: remove struct list_head
Date: Tue, 11 Sep 2012 13:35:00 +0200
Message-Id: <1347363313-17094-8-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
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
index 867d696..fc90a94 100644
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

