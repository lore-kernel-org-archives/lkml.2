Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab1IIAXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:23:31 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57887 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756714Ab1IIAX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:23:28 -0400
Message-ID: <4E68F87F.7030509@xenotime.net>
Date: Thu, 08 Sep 2011 10:16:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: fix kernel-doc warning in consumer.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warning about internal/private data by marking it
as "private:" so that kernel-doc will ignore it.

Warning(include/linux/regulator/consumer.h:128): No description found for parameter 'ret'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/consumer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-31-rc5.orig/include/linux/regulator/consumer.h
+++ lnx-31-rc5/include/linux/regulator/consumer.h
@@ -123,7 +123,7 @@ struct regulator_bulk_data {
 	const char *supply;
 	struct regulator *consumer;
 
-	/* Internal use */
+	/* private: Internal use */
 	int ret;
 };
 
