Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1JJOe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:34:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:34834 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab1JJOey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:34:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,517,1312182000"; 
   d="scan'208";a="76576106"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCHv2 4/5] fat: follow rename pack_hex_byte to hex_byte_pack
Date: Mon, 10 Oct 2011 17:33:38 +0300
Message-Id: <0fd7e74869d6f19d05376fe944a9113851378d84.1318257114.git.andriy.shevchenko@linux.intel.com>
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
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 5efbd5d..aca191b 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -156,8 +156,8 @@ static int uni16_to_x8(struct super_block *sb, unsigned char *ascii,
 		} else {
 			if (uni_xlate == 1) {
 				*op++ = ':';
-				op = pack_hex_byte(op, ec >> 8);
-				op = pack_hex_byte(op, ec);
+				op = hex_byte_pack(op, ec >> 8);
+				op = hex_byte_pack(op, ec);
 				len -= 5;
 			} else {
 				*op++ = '?';
-- 
1.7.6.3

