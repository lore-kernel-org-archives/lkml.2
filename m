Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0IJIGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:06:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57962 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0IJIGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ktnoMKrUJ1Mcm/ypuTuHe/EdBD2zOEIl8KUSYSmXcl87OMrWrvOeHtbSrcnvnizlJs
         UbAGFOc22znRApZjapIBr2OthZl0z397FneH6998fOerDFYN5Ck0W41dX3x6ymkAnldN
         iRh6/YGa/HmunjODUhmRoBl3VRsVrJIvO7tYI=
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: akpm@linux-foundation.org, mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jlee@novell.com,
        mzxreary@0pointer.de, linux-acpi@vger.kernel.org
Subject: [PATCH] Change MSI LAPTOP driver maintainer to Lee, Chun-Yi
Date: Fri, 10 Sep 2010 16:04:19 +0800
Message-Id: <1284105859-10010-1-git-send-email-jlee@novell.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change MSI LAPTOP driver maintainer from Lennart Poettering to Lee, Chun-Yi.

MSI is a Taiwan OEM company, Lee, Chun-Yi can more easy to contact with MSI
and maintain msi-laptop driver.
Thank's for Lennart Poettering's contribute, Lee, Chun-Yi will base on his
article to continue maintain the msi-laptop driver.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5fa8451..d3996e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3879,10 +3879,8 @@ F:	Documentation/serial/moxa-smartio
 F:	drivers/char/mxser.*
 
 MSI LAPTOP SUPPORT
-M:	Lennart Poettering <mzxreary@0pointer.de>
+M:	Lee, Chun-Yi <jlee@novell.com>
 L:	platform-driver-x86@vger.kernel.org
-W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
-W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 F:	drivers/platform/x86/msi-laptop.c
 
-- 
1.6.0.2

