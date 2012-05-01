Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab2EAQnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:43:46 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:17580 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2EAQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:43:38 -0400
Subject: [PATCH 16/17] hpsa: removed unused member maxQsinceinit
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Tue, 01 May 2012 11:43:37 -0500
Message-ID: <20120501164337.11705.93079.stgit@beardog.cce.hp.com>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 79c36aa..fb51ef7 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -85,7 +85,6 @@ struct ctlr_info {
 	struct list_head reqQ;
 	struct list_head cmpQ;
 	unsigned int Qdepth;
-	unsigned int maxQsinceinit;
 	unsigned int maxSG;
 	spinlock_t lock;
 	int maxsgentries;

