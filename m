Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0IFMqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:46:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:50748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0IFMqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:46:37 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] backing-dev: kill unused bdi_writeback->nr
Date: Mon,  6 Sep 2010 14:46:19 +0200
Message-Id: <1283777182-11426-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283777182-11426-1-git-send-email-tj@kernel.org>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 12:46:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdi_writeback->nr is no longer used.  Kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/backing-dev.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 35b0074..97842ab 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -47,7 +47,6 @@ enum bdi_stat_item {
 
 struct bdi_writeback {
 	struct backing_dev_info *bdi;	/* our parent bdi */
-	unsigned int nr;
 
 	unsigned long last_old_flush;	/* last old data flush */
 	unsigned long last_active;	/* last time bdi thread was active */
-- 
1.7.1

