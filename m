Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab2FGXFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:05:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63924 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab2FGXE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:04:28 -0400
From: Sam Hansen <solid.se7en@gmail.com>
To: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Sam Hansen <solid.se7en@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 2/3] staging: zram: conventions, __aligned() attribute
Date: Thu,  7 Jun 2012 16:03:48 -0700
Message-Id: <1339110229-19383-3-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339110229-19383-1-git-send-email-solid.se7en@gmail.com>
References: <1339110229-19383-1-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the __aligned() attribute in favor of __attribute__((aligned(size)))

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/zram/zram_drv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index fbe8ac9..cda89ec 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -85,7 +85,7 @@ struct table {
 	u16 size;	/* object size (excluding header) */
 	u8 count;	/* object ref count (not yet used) */
 	u8 flags;
-} __attribute__((aligned(4)));
+} __aligned(4);
 
 struct zram_stats {
 	u64 compr_size;		/* compressed size of pages stored */
-- 
1.7.5.4

