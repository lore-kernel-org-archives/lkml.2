Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809Ab2ILRFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:05:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51795 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760776Ab2ILRDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:40 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] drivers/char: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:18 +0200
Message-Id: <1347469402-27557-11-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/char/nwbutton.c |    4 ++--
 drivers/char/rtc.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index 04a480f..cfdfe49 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -93,9 +93,9 @@ int button_del_callback (void (*callback) (void))
 			button_callback_list [lp].count = 0;
 			callback_count--;
 			return 0;
-		};
+		}
 		lp--;
-	};
+	}
 	return -EINVAL;
 }
 
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index af94374..91470fd 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -411,7 +411,7 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 		case RTC_IRQP_READ:
 		case RTC_IRQP_SET:
 			return -EINVAL;
-		};
+		}
 	}
 #endif
 

