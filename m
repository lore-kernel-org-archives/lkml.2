Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2DTNJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62222 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2DTNI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:08:59 -0400
Subject: [PATCH][Trivial][Resend] drivers/base/core.c: Fix a typo in comment
From: yan <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, message.get@gmail.com
Date: Fri, 20 Apr 2012 21:08:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334927339.2018.4.camel@yan>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: YanHong <clouds.yan@gmail.com>
---
 drivers/base/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e28ce98..0c6a0cd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -65,7 +65,7 @@ static inline int device_is_not_partition(struct device *dev)
  * @dev: struct device to get the name of
  *
  * Will return the device's driver's name if it is bound to a device.  If
- * the device is not bound to a device, it will return the name of the bus
+ * the device is not bound to a driver, it will return the name of the bus
  * it is attached to.  If it is not attached to a bus either, an empty
  * string will be returned.
  */
-- 
1.7.5.1



