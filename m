Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1JJOfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:35:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:27633 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab1JJOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:35:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,517,1312182000"; 
   d="scan'208";a="76576167"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCHv2 5/5] wireless: at76c50x: follow rename pack_hex_byte to hex_byte_pack
Date: Mon, 10 Oct 2011 17:33:39 +0300
Message-Id: <e8194a9826fe1220c9d908ea0525ac21cc6b4aa9.1318257114.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
References: <CAKiorj5MJ8_ZH-J-7GjNQLoPNTshFdrrHfjptgpgi_4mchHJYw@mail.gmail.com>
 <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
References: <bc1318a3244d9df71f44041d8a57d8f075f2cb5b.1318257114.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
---
 drivers/net/wireless/at76c50x-usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 39322d4..4045e5a 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -517,7 +517,7 @@ static char *hex2str(void *buf, size_t len)
 		goto exit;
 
 	while (len--) {
-		obuf = pack_hex_byte(obuf, *ibuf++);
+		obuf = hex_byte_pack(obuf, *ibuf++);
 		*obuf++ = '-';
 	}
 	obuf--;
-- 
1.7.6.3

