Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1DKIQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:16:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57582 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab1DKIQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=Vrqf4UI6MHkwiL2ognrHvmE14Go/TL6j77cyEqa7VpcmHEWy3/gh9IhVqiBAoIiJqM
         tIgmKv0X7EM8mySGz0tVAXXMxirKg9rhqc8zFnxkYw2sOf6DED6Y6pxrhED3j3O0lxB/
         2z45NVxCfGTUVnC6qvGxGEBs+cq6ngLDmkmIE=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>
Subject: [PATCH 1/2] bonding:delete unused alb_timer
Date: Mon, 11 Apr 2011 16:17:24 +0800
Message-Id: <7e091c9bb158d01e48302254db8feaf54c731ebf.1302509480.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1302509480.git.panweiping3@gmail.com>
References: <cover.1302509480.git.panweiping3@gmail.com>
In-Reply-To: <cover.1302509480.git.panweiping3@gmail.com>
References: <cover.1302509480.git.panweiping3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now bonding-alb uses delayed_work instead of timer_list.

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.h b/drivers/net/bonding/bond_alb.h
index 86861f0..f2a1d0a 100644
--- a/drivers/net/bonding/bond_alb.h
+++ b/drivers/net/bonding/bond_alb.h
@@ -122,7 +122,6 @@ struct tlb_slave_info {
 };
 
 struct alb_bond_info {
-	struct timer_list	alb_timer;
 	struct tlb_client_info	*tx_hashtbl; /* Dynamically allocated */
 	spinlock_t		tx_hashtbl_lock;
 	u32			unbalanced_load;
-- 
1.7.4

