Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2KHJLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:11:15 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61397 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab2KHJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:11:09 -0500
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 17:11:09 +0800
Message-ID: <CAPgLHd8oC5zLyeP68GXWXachmO9-+UJ3TMNBpYTCes9WcenaFQ@mail.gmail.com>
Subject: [PATCH -next] staging: comedi: usbduxfast: remove unused variable in usbduxfastsub_ai_Irq()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable 'p' is initialized but never used otherwise, so
remove the unused variable.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index b4e987b..574e4b7 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -312,7 +312,6 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 	struct usbduxfastsub_s *udfs;
 	struct comedi_device *this_comedidev;
 	struct comedi_subdevice *s;
-	uint16_t *p;
 
 	/* sanity checks - is the urb there? */
 	if (!urb) {
@@ -379,7 +378,6 @@ static void usbduxfastsub_ai_Irq(struct urb *urb)
 		return;
 	}
 
-	p = urb->transfer_buffer;
 	if (!udfs->ignore) {
 		if (!udfs->ai_continous) {
 			/* not continuous, fixed number of samples */


