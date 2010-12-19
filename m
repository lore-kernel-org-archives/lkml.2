Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0LSK7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 05:59:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53574 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab0LSK7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 05:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CuH9+eJ6Z2TKvohUWSpHQ0aQ4jw1qpQuHjz3gN12CNKID6+1jBsVUoyfTICxQNprHw
         7DI3r1I4dfz4oa+vnH40rJNzcEZvDmGCcfeeSZu3HjxRi9a07l7xwPtrmj4sz6n5kvCQ
         mXma+nUDfcs8o/fMFC8IZQATxRnTLqmcH9n54=
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: davem@davemloft.net
Cc: richard.cochran@omicron.at, shemminger@vyatta.com, tj@kernel.org,
        randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Michel Hautbois <jhautbois@gmail.com>
Subject: [PATCH 4/4] net: phy: EXPORT_SYMBOL not following the function
Date: Sun, 19 Dec 2010 11:58:51 +0100
Message-Id: <1292756331-3735-4-git-send-email-jhautbois@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1292756331-3735-1-git-send-email-jhautbois@gmail.com>
References: <1292756331-3735-1-git-send-email-jhautbois@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol phy_stop was not following the related function.

Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>
---
 drivers/net/phy/phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 87a64c0..ed503cd 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -732,6 +732,7 @@ out_unlock:
 	 * will not reenable interrupts.
 	 */
 }
+EXPORT_SYMBOL(phy_stop);
 
 
 /**
@@ -762,7 +763,6 @@ void phy_start(struct phy_device *phydev)
 	}
 	mutex_unlock(&phydev->lock);
 }
-EXPORT_SYMBOL(phy_stop);
 EXPORT_SYMBOL(phy_start);
 
 /**
-- 
1.7.0.4

