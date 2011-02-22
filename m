Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1BVUOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:14:34 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39274 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1BVUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:14:32 -0500
Subject: [PATCH 4/6] cciss: remove unnecessary casts
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 22 Feb 2011 14:14:32 -0600
Message-ID: <20110222201431.21961.62816.stgit@beardog.cce.hp.com>
In-Reply-To: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
References: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
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
index 03cead6..6110918 100644
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

