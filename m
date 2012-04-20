Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2DTPHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:07:52 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:45504 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab2DTPHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:07:43 -0400
Subject: [PATCH 16/17] hpsa: removed unused member maxQsinceinit
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Fri, 20 Apr 2012 10:07:42 -0500
Message-ID: <20120420150742.10596.53187.stgit@beardog.cce.hp.com>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
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

