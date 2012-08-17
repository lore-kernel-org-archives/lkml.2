Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2HQFEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:04:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2HQFEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:04:36 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH 1/5] staging/vme: fix checkpatch error
Date: Fri, 17 Aug 2012 14:04:27 +0900
Message-Id: <1345179867-8266-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342875651-16961-1-git-send-email-yamanetoshi@gmail.com>
References: <1342875651-16961-1-git-send-email-yamanetoshi@gmail.com>
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

