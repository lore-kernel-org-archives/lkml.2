Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0GLCsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:48:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62832 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0GLCsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=KzoFLzn+driMaujtXvASnt4q7Fo2qTYKh26sAxfXHmHzJZIawgoVgKJ9+axO8p/tk9
         PnVEaV6fxk9sONjSrmTTKeyGCGfZt197cNROgifQ8WpsXA7D1ddd1IOh0P62lB4HDDqU
         oxBvi6X2VIECW34ph9uT00s0txpHjGKpJ/CNU=
Message-ID: <4C3A828D.1070509@gmail.com>
Date: Sun, 11 Jul 2010 21:48:45 -0500
From: Neal B <nealb001@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Artem.Bityutskiy@nokia.com
CC: dwmw2@infradead.org, rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
        mohanlaljangir@gmail.com, maximlevitsky@gmail.com,
        Julia Lawall <julia@diku.dk>, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] Mtd: fixed space after open parenthesis
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From d1caf6c1e0e1c8137a0c23c570df5ce764eb60f6 Mon Sep 17 00:00:00 2001
From: Neal Buckendahl <nealb001@gmail.com>
Date: Sun, 11 Jul 2010 17:06:12 -0500
Subject: [PATCH 2/6] Mtd: fixed space after open parenthesis found by 
the checkpatch.pl tool
  Signed-off-by: Neal Buckendahl <nealb001@gmail.com>

---
  drivers/mtd/ar7part.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ar7part.c b/drivers/mtd/ar7part.c
index 6697a1e..7ccfdca 100644
--- a/drivers/mtd/ar7part.c
+++ b/drivers/mtd/ar7part.c
@@ -148,6 +148,6 @@ static int __init ar7_parser_init(void)
  module_init(ar7_parser_init);

  MODULE_LICENSE("GPL");
-MODULE_AUTHOR(	"Felix Fietkau <nbd@openwrt.org>, "
+MODULE_AUTHOR("Felix Fietkau <nbd@openwrt.org>, "
  		"Eugene Konev <ejka@openwrt.org>");
  MODULE_DESCRIPTION("MTD partitioning for TI AR7");
-- 
1.7.1


