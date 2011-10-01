Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1JAIoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 04:44:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43630 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab1JAIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 04:44:19 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 3/3] staging: wlags49_h2: Remove bad debug message
Date: Sat,  1 Oct 2011 09:43:50 +0100
Message-Id: <1317458630-16033-4-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317458630-16033-1-git-send-email-kilroyd@googlemail.com>
References: <1317458630-16033-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message is in the wrong place. We definitely don't want to
return at this point, as we may need to turn off encryption.

Reported-by: Henk de Groot <pe1dnn@amsat.org>
Signed-off-by: David Kiroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 764a320..89563da 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -1214,7 +1214,6 @@ static int wireless_set_encode(struct net_device *dev, struct iw_request_info *i
 				lp->EnableEncryption    = 1;
 			} else {
 				DBG_WARNING( DbgInfo, "Problem setting the current TxKey\n" );
-				DBG_LEAVE( DbgInfo );
 				ret = -EINVAL;
 			}
 		}
-- 
1.7.4.1

