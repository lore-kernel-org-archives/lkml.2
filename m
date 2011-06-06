Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab1FFTH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:07:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44583 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab1FFTHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FPpDeua4H/+RyYP+p85iAv1/9lnzMeLvvScM2sSy/FTt3+t9A0ffSjgms30ran2eht
         sE92yQGkEmxoks9Y2HoDpYY6Swsm0UzrvOsIff0euMr/p6M4iPyphVHA8mnjnk2TfY40
         7di1f2hwGCf8DPsiG0NSE4u9D10VjhVfV7t64=
Subject: [PATCH 2/2] staging: iio added missing "()" in kmalloc
From: anish <anish198519851985@gmail.com>
To: gregkh@suse.de, jic23@cam.ac.uk, lucas.demarchi@profusion.mobi,
        manuel.stahl@iis.fraunhofer.de, arnd@arndb.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 00:37:45 +0530
Message-ID: <1307387265.4327.13.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

"()" was missing from kmalloc,so added it.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/staging/iio/industrialio-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 3a82414..5251332 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -136,7 +136,7 @@ static irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
 
 static struct iio_interrupt *iio_allocate_interrupt(void)
 {
-	struct iio_interrupt *i = kmalloc(sizeof *i, GFP_KERNEL);
+	struct iio_interrupt *i = kmalloc(sizeof(*i), GFP_KERNEL);
 	if (i) {
 		spin_lock_init(&i->ev_list_lock);
 		INIT_LIST_HEAD(&i->ev_list);
-- 
1.7.0.4





