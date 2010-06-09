Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0FIMHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:07:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49613 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0FIMG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:06:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=rlPdI3WD/APJihxFtS2Yj+R7cizT4bou9lr0BMcK8cN3MKkr8Ar8jHEYW7a84f1XuV
         VVNgZl2MXK2ODpATpbjAt4d8NVQAV/glshEjbVXHzKq5OtsjiXIVTLDO4lUT+mJcm3f2
         8XaXKHPmjzA+fooazp3rnPO1mV1u2TyZ0bZKI=
MIME-Version: 1.0
Date: Wed, 9 Jun 2010 14:06:57 +0200
Message-ID: <AANLkTinIiOUFoE01S1CdT-dWdIXLQaeoDXFfBFl0TfpV@mail.gmail.com>
Subject: [PATCH 1/1] Add support for PL2501 Host to Host USB 2.0 Device. Fully 
	compatible with existing PL2301/2302 driver.
From: Tanguy PRUVOT <tanguy.pruvot@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for PL2501 Host to Host USB 2.0 Device.
Device is fully compatible with existing PL2301/2302 driver.
Tested on ARM 2.6.24 and x86 2.6.35-rc2.
Signed-off-by: Tanguy Pruvot <tanguy.pruvot@gmail.com>
---
diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index 08555f8..f88392f 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -117,6 +117,9 @@ static const struct usb_device_id   products [] = {
 }, {
        USB_DEVICE(0x067b, 0x0001),     // PL-2302
        .driver_info =  (unsigned long) &prolific_info,
+}, {
+       USB_DEVICE(0x067b, 0x2501),     // PL-2501
+       .driver_info =  (unsigned long) &prolific_info,
 },

        { },            // END
