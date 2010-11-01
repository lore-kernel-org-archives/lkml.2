Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0KASmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:42:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab0KASm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rQ2mls/RKcEjqafzUslT5LZpXiYDfcFTjmIsu7hZZ4YroNFMXpK+1+Z0+58yksx+Rc
         fYrvgcbaT8ob87H0lGwOrgNUuVol6FBfWwpbh/Q0VJa242oQng1h+3v4anynrJioBqx/
         eMokT/oMkZRaCMcfThy+TYbx3GGue3oNJpWwQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 29/29] Staging: yaffs2: TODO: Add TODO file
Date: Mon,  1 Nov 2010 14:41:17 -0400
Message-Id: <1288636877-7964-30-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inital TODO file.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/TODO |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/TODO

diff --git a/drivers/staging/yaffs2/TODO b/drivers/staging/yaffs2/TODO
new file mode 100644
index 0000000..be6a836
--- /dev/null
+++ b/drivers/staging/yaffs2/TODO
@@ -0,0 +1,6 @@
+TODO :
+
+	* checkpatch.pl fixes
+	* sparse fixes
+
+Plase send patches to Greg Kroah-Hartman <greg@kroah.com>
-- 
1.7.3.2.146.gca209

