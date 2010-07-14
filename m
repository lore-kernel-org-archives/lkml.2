Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab0GNSF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:05:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34217 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0GNSF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CObSR1dYafZdydI/+s9XWkWrfYwhx36aUgvVM7ip4bGPRyDJOshOpQ+ZbDiHVYYe5I
         r1n/9sWCH7EckRxO93iYAJhy1BJJTs8lBqWXe36PgUryWfJXL3Dd615A1vsVUotoVx3l
         9xWK3OmSpXrY0fXl+FQCHSzUTKYWx8q5m166s=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>, Jiri Kosina <jkosina@suse.cz>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] staging: msm: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:05:17 +0400
Message-Id: <1279130717-15755-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index 8d16380..8b49cb1 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -208,7 +208,7 @@ static void hex_dump(char *str, void *ptr, int len)
 
 	for (i = 0; i < len; i++) {
 		if (i % 16 == 0)
-			printk("\n0x%08x:", (unsigned int)cptr);
+			printk("\n%p:", cptr);
 
 		printk(" %02x", *(cptr++));
 	}
-- 
1.7.0.4

