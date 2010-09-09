Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab0IIWgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab0IIWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QDBL4O85q7AbryRVcqj7KbvHyYzrVTILyW1jiexZ40zYqSy4e0mf/F8F+uiL5KZAss
         tAdI8aEACNwZR0BggHGIJUzaK4V5zbODH8/FNLHArOxVn42vtWr5lKScHU4hzMxkAS8m
         wMpsuVhUzPzlHp89+xrPJsjTJX6l3vyfCwYkQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 110/223]drivers/net/wan/farsync.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:39 -0700
Message-Id: <1284071809-8149-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wan/farsync.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index e050bd6..5ee8372 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -125,9 +125,7 @@ module_param_array(fst_excluded_list, int, NULL, 0);
 
 /*      The Am186CH/CC processors support a SmartDMA mode using circular pools
  *      of buffer descriptors. The structure is almost identical to that used
- *      in the LANCE Ethernet controllers. Details available as PDF from the
- *      AMD web site: http://www.amd.com/products/epd/processors/\
- *                    2.16bitcont/3.am186cxfa/a21914/21914.pdf
+ *      in the LANCE Ethernet controllers. 
  */
 struct txdesc {			/* Transmit descriptor */
 	volatile u16 ladr;	/* Low order address of packet. This is a
-- 
1.7.2.1

