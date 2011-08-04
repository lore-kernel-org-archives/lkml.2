Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1HDBJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:09:06 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34664 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755374Ab1HDBJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:09:04 -0400
Date: Wed, 3 Aug 2011 18:09:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH] regulator: fix regulator/consumer.h kernel-doc warning
Message-Id: <20110803180902.4d31d143.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
---
 include/linux/regulator/consumer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.0-git18.orig/include/linux/regulator/consumer.h
+++ linux-3.0-git18/include/linux/regulator/consumer.h
@@ -123,7 +123,7 @@ struct regulator_bulk_data {
 	const char *supply;
 	struct regulator *consumer;
 
-	/* Internal use */
+	/* private: Internal use */
 	int ret;
 };
 
