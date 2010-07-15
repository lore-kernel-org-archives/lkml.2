Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0GOGnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:43:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58726 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0GOGnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CWuh53eqv9/ev7HbJtECUPrOeXse/kOdyCj91A4Ubjyh/lUfqE633CTda8XSUEnA3N
         csCgqQlYRpQNLHLMeaWmx/ytX/YMT3J71E6nOO3zvC3bKvvY2Jjf6Y6psDjBbdkBmX0Z
         JKj8g7o3nA29dnp8ivtP7SSlI7TE75vD1ggy4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>, Jiri Kosina <jkosina@suse.cz>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] staging: comedi: formatting of pointers in printk()
Date: Thu, 15 Jul 2010 10:42:51 +0400
Message-Id: <1279176172-5609-1-git-send-email-segooon@gmail.com>
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

