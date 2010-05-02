Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0EBRFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 13:05:47 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:46834 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab0EBRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 13:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=kUjnNPnR8r2rO+T45TO3LudDuWC+hZrVfEdMYe9hyOGjZ0WLg5Uw/5j3dVLFhWHZLa
         L0pFKQf2OoCSA2Y2u+YzHJoQuHOAXLwR2NtciI4hHn0m5T1hXt+5v9mv0Tem370zfOLq
         aBt63q9MN74HPZHpBJm+1jwVNqnT/5wG+5/Zc=
Subject: [PATCH] Staging: adis16255: Fix compile error
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Matthias Brugger <mensch0815@gmail.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 May 2010 13:05:33 -0400
Message-ID: <1272819933.16886.19.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves a compilation error in today linux-next tree.

The adis16255 staging driver Makefile seems to be wrong. I think this patch solves the issue.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/adis16255/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/adis16255/Makefile b/drivers/staging/adis16255/Makefile
index 3f8b1f0..dc4debc 100644
--- a/drivers/staging/adis16255/Makefile
+++ b/drivers/staging/adis16255/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_ADIS16255) +�is16255.o
+obj-$(CONFIG_ADIS16255)                += adis1625.o
-- 
1.7.0.4





