Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2FXX4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 19:56:37 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12146 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab2FXX4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 19:56:36 -0400
Date: Mon, 25 Jun 2012 01:56:35 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] staging: vt6656: iwctl: remove redundant ';'
In-Reply-To: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1206250149240.30361@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206250143440.30361@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

else clauses don't need to be terminated with ';'.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/iwctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 7618fb9..ca4e7f0 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1321,7 +1321,7 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 	}
 	else {
 		wrq->value = 0;
-	};
+	}
 	wrq->disabled = (wrq->value == 0);
 	wrq->fixed = 1;
 	return 0;
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

