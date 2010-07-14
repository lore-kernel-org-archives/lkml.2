Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0GNAvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:51:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52859 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0GNAvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:51:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xqiO62L9JlTsQ3FLFubjMl87t6nJM9c5cKuniC9p2+KKU0ljvUxSnRoHyD4hcsB9EK
         /6Dzy+q5EZW/BX14Rk7CHyv70jj+7Ya0G1zIG0LwEY09RinDSjUAOcKiBmCpPnEqAKVM
         /Abqq1Tp0RUX82HAMDf396CkMPiOq4KcIi63U=
Message-ID: <4C3D0A00.4000900@gmail.com>
Date: Wed, 14 Jul 2010 08:51:12 +0800
From: shenghui <crosslonelyover@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: kernel-janitors@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, error27@gmail.com
Subject: [PATCH]trivial: clear the comment on parameters for ext2_xattr_set
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. I changed to another mail client.
Please recheck the patch.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 fs/ext2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..194269e 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -355,7 +355,7 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 /*
  * ext2_xattr_set()
  *
- * Create, replace or remove an extended attribute for this inode. Buffer
+ * Create, replace or remove an extended attribute for this inode. Value
  * is NULL to remove an existing extended attribute, and non-NULL to
  * either replace an existing extended attribute, or create a new extended
  * attribute. The flags XATTR_REPLACE and XATTR_CREATE
-- 
1.6.3.3

