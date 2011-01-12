Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1ALA0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:26:52 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:60095 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1ALA0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:26:51 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1294792002!9638739!26
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 11 Jan 2011 18:21:59 -0600
Subject: [PATCH] fs/inode.c: include "internal.h" for external definitions
Thread-Topic: [PATCH] fs/inode.c: include "internal.h" for external
 definitions
Thread-Index: Acux7roQHG/SdBBmQLGjPShiprOo5Q==
Message-ID: <0D753D10438DA54287A00B027084269764CE0E54E1@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0C0R2wS022906

The functions get_nr_dirty_inodes, evict_inodes, and invalidate_inodes
are used external from this file but they are not exported.  Include
"internal.h" to pick up their definitions.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---

diff --git a/fs/inode.c b/fs/inode.c
index da85e56..4fee1cf 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -35,6 +35,8 @@
  */
 #include <linux/buffer_head.h>
 
+#include "internal.h"
+
 /*
  * New inode.c implementation.
  *
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
