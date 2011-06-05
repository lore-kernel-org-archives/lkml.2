Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1FETTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:19:04 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52921 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1FETTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:reply-to:from:to:cc:subject:date:mime-version
         :content-type:content-transfer-encoding:x-priority:x-msmail-priority
         :x-mailer:x-mimeole;
        b=BpGudsefgJZ41XbGDayn8dnedGdIJWNphK6Z0jJMRekCvOT5+Sk/hqkWZRHHbyIUGH
         IwGMusJDkzI+bbFFyTkt7/UuNWklGFFjkGMwQZX31pgrO62d/qJ2n8Tj2Dx3Ro0n9nzb
         B4I2FxZ/NO8dyhWzWhQM+nk5Z/6bGCtSs6Q6k=
Message-ID: <45538E4040B9494CA605BDF7475381AE@your6c359a3bdc>
Reply-To: "anish kumar" <anish198519851985@gmail.com>
From: "anish kumar" <anish198519851985@gmail.com>
To: <jic23@cam.ac.uk>, <manuel.stahl@iis.fraunhofer.de>, <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: IIO corrected the spelling
Date: Mon, 6 Jun 2011 00:48:57 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish <anish198519851985@gmail.com>

Corrected the spelling.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/staging/iio/trigger/iio-trig-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/trigger/iio-trig-gpio.c 
b/drivers/staging/iio/trigger/iio-trig-gpio.c
index 2ce95e9..0799128 100644
--- a/drivers/staging/iio/trigger/iio-trig-gpio.c
+++ b/drivers/staging/iio/trigger/iio-trig-gpio.c
@@ -7,7 +7,7 @@
  * under the terms of the GNU General Public License version 2 as published by
  * the Free Software Foundation.
  *
- * Currently this is more of a functioning proof of concept that a fully
+ * Currently this is more of a functioning proof of concept than a full
  * fledged trigger driver.
  *
  * TODO:
--
1.7.0.4 

