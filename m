Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2HULMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:12:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45700 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2HULMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:12:41 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 1/3] Staging: vme: Fix a white space issue
Date: Tue, 21 Aug 2012 20:12:33 +0900
Message-Id: <1345547553-13257-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20120817074644.GL4559@mwanda>
References: <20120817074644.GL4559@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch error was fixed.

-ERROR: trailing whitespace

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e25645e..e39d273 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -396,7 +396,7 @@ static ssize_t vme_user_write(struct file *file, const char __user *buf,
 	default:
 		retval = -EINVAL;
 	}
-	
+
 	mutex_unlock(&image[minor].mutex);
 
 	if (retval > 0)
-- 
1.7.9.5

