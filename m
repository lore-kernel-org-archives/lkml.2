Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1LQWwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:52:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22974 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1LQWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:52:29 -0500
Date: Sat, 17 Dec 2011 23:52:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Christoph Mair <christoph.mair@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH][Trivial] BMP085: Remove redundant semi-colon from return
 statement
Message-ID: <alpine.LNX.2.00.1112172343360.21784@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a single ";" will do nicely.

Signed-off-by: Jesper Juhl <jj@codesealer.com>
---
 drivers/misc/bmp085.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 5f898cb..b29a2be 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -216,7 +216,7 @@ static s32 bmp085_get_temperature(struct bmp085_data *data, int *temperature)
 		*temperature = (x1+x2+8) >> 4;
 
 exit:
-	return status;;
+	return status;
 }
 
 /*
-- 
1.7.8


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

