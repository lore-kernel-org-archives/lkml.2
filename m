Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1LQWxz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:53:55 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23013 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1LQWxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:53:54 -0500
Date: Sat, 17 Dec 2011 23:53:52 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        trivial@kernel.org
Subject: [PATCH][Trivial] isl29020: Remove a redundant semi-colon from return
 statement
Message-ID: <alpine.LNX.2.00.1112172352330.21784@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] isl29020: Remove a redundant semi-colon from return statement

One is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/misc/isl29020.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 307aada..3d6cce6 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -158,7 +158,7 @@ static int als_set_default_config(struct i2c_client *client)
 		dev_err(&client->dev, "default write failed.");
 		return retval;
 	}
-	return 0;;
+	return 0;
 }
 
 static int  isl29020_probe(struct i2c_client *client,
-- 
1.7.8


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

