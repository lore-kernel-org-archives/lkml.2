Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1CKU7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:59:41 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:15320 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab1CKU7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:59:09 -0500
Subject: [PATCH 4/7] cciss: remove unnecessary casts
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Fri, 11 Mar 2011 14:55:51 -0600
Message-ID: <20110311205551.2211.89636.stgit@beardog.cce.hp.com>
In-Reply-To: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
References: <20110311205306.2211.53569.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 92bf364..619b7c0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1490,8 +1490,7 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	ioc = (BIG_IOCTL_Command_struct *)
-	    kmalloc(sizeof(*ioc), GFP_KERNEL);
+	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
 	if (!ioc) {
 		status = -ENOMEM;
 		goto cleanup1;

