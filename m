Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab2AITZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:25:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169Ab2AITZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:25:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jesper Juhl <jj@chaosbits.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 8/8] isl29020: Remove a redundant semi-colon from return statement
Date: Mon,  9 Jan 2012 11:25:05 -0800
Message-Id: <1326137105-9960-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326137105-9960-1-git-send-email-gregkh@suse.de>
References: <20120109190736.GA9440@kroah.com>
 <1326137105-9960-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

One is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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

