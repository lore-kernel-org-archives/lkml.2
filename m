Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab2HGUFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:05:15 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:15136 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab2HGUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:05:12 -0400
Date: Tue, 7 Aug 2012 22:05:11 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: trivial@kernel.org
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: [PATCH][Trivial] drivers/acpi/osl.c: delete trailing whitespace
Message-ID: <alpine.LNX.2.00.1208072203500.3227@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/acpi/osl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9eaf708..b9eb753 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1061,7 +1061,7 @@ acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 units, u16 timeout)
 		jiffies = MAX_SCHEDULE_TIMEOUT;
 	else
 		jiffies = msecs_to_jiffies(timeout);
-	
+
 	ret = down_timeout(sem, jiffies);
 	if (ret)
 		status = AE_TIME;
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

