Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2CLMsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab2CLMsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:48:40 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] i5100_edac: Fix a warning on a debug message
Date: Mon, 12 Mar 2012 09:48:35 -0300
Message-Id: <1331556515-7902-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
References: <1331556515-7902-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/edac/i5100_edac.c: In function ‘i5100_init_csrows’:
drivers/edac/i5100_edac.c:864:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘long unsigned int’ [-Wformat]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i5100_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 2eb44d8..254d7e4 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -861,7 +861,7 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 			"DIMM%u",
 			i5100_rank_to_slot(mci, chan, rank));
 
-		debugf2("dimm channel %d, rank %d, size %d\n",
+		debugf2("dimm channel %d, rank %d, size %zd\n",
 			chan, rank, PAGES_TO_MiB(npages));
 	}
 }
-- 
1.7.8

