Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0EaPEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:04:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35487 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0EaPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=L2fQAJ1eQB0BrfO+f0EtzhJBKDU4GovLvBXqSlpH1b+VYs7h/2kP9RzB+FKwujiSA+
         w8FNxcjQNzy9wuswQxKO1dryRq1/BW58e8Iff6iM7iOEj09wDDf39HZwR+nI+I0CnMnT
         Ll7nxl43ZkVUmGiO+yff+n0b37f1qaOxgBXr4=
Message-ID: <4C03CFED.2030101@gmail.com>
Date: Mon, 31 May 2010 18:04:13 +0300
From: Spyros Papageorgiou <spyros.papageorgiou@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: gregkh@suse.de
CC: ossama.othman@intel.com, devel@driverdev.osuosl.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] Drivers: Stagins: memrar: cleanup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Spyros Papageorgiou <spyros.papageorgiou@gmai.com>

Removed an unneeded struct specifier in function call.

Signed-off-by: Spyros Papageorgiou <spyros.papageorgiou@gmai.com>
---
 drivers/staging/memrar/memrar_allocator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/memrar/memrar_allocator.c b/drivers/staging/memrar/memrar_allocator.c
index a4f8c58..db37c6a 100644
--- a/drivers/staging/memrar/memrar_allocator.c
+++ b/drivers/staging/memrar/memrar_allocator.c
@@ -276,7 +276,7 @@ long memrar_allocator_free(struct memrar_allocator *allocator,
 
 		struct memrar_address_range * const chunk =
 			&list_entry(pos,
-				    struct memrar_address_ranges,
+				    memrar_address_ranges,
 				    list)->range;
 
 		/* Extend size of existing free adjacent chunk. */
@@ -300,7 +300,7 @@ long memrar_allocator_free(struct memrar_allocator *allocator,
 
 			struct memrar_address_ranges const * const next =
 				list_entry(pos->next,
-					   struct memrar_address_ranges,
+					   memrar_address_ranges,
 					   list);
 
 			chunk->end = handle->end;
@@ -352,7 +352,7 @@ long memrar_allocator_free(struct memrar_allocator *allocator,
 
 			struct memrar_address_ranges const * const prev =
 				list_entry(pos->prev,
-					   struct memrar_address_ranges,
+					   memrar_address_ranges,
 					   list);
 
 			chunk->begin = handle->begin;
-- 
1.7.0.4
