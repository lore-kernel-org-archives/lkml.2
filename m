Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2CLMti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:49:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab2CLMsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:48:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] amd64_edac: Fix the rank number of pages count
Date: Mon, 12 Mar 2012 09:48:34 -0300
Message-Id: <1331556515-7902-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
References: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ea7eb9a..d74bcd3 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2227,7 +2227,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		for (j = 0; j < pvt->channel_count; j++) {
 			csrow->channels[j].dimm->mtype = mtype;
 			csrow->channels[j].dimm->edac_mode = edac_mode;
-			csrow->channels[j].dimm->nr_pages = nr_pages / pvt->channel_count;
+			csrow->channels[j].dimm->nr_pages = nr_pages;
 
 		}
 
-- 
1.7.8

