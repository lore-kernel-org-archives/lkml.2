Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2IPRdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 13:33:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59704 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2IPRdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 13:33:31 -0400
Date: Mon, 17 Sep 2012 01:33:24 +0800
From: Tekkaman Ninja <tekkamanninja@gmail.com>
To: Harry Wei <harryxiyou@gmail.com>
Cc: Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel@vger.linux-kernel.cn
Subject: [PATCH]Documentation:Remove 3 byte redundant code at the head of the
 Documentation/zh_CN/arm/booting
Message-ID: <20120916173324.GD7285@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 3 byte redundant code at the head of
the Documentation/zh_CN/arm/booting

When I see the file Documentation/zh_CN/arm/booting using
Bless(binary Viewer),I find 3 byte redundant in it. So I 
make a patch to correcting that error made by me.

Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

---
 Documentation/zh_CN/arm/Booting |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/zh_CN/arm/Booting b/Documentation/zh_CN/arm/Booting
index 3014ea8..6158a64 100644
--- a/Documentation/zh_CN/arm/Booting
+++ b/Documentation/zh_CN/arm/Booting
@@ -1,4 +1,4 @@
-﻿Chinese translated version of Documentation/arm/Booting
+Chinese translated version of Documentation/arm/Booting
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
-- 
1.7.9.5

