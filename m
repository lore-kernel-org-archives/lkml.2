Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2EVKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:30:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44523 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab2EVKaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:30:14 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] staging:iio: remove num_interrupt_lines from documentation
Date: Tue, 22 May 2012 12:30:02 +0200
Message-Id: <1337682602-15105-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5aa9618896e0ba49 ("staging:iio: remove broken support for
multiple event interfaces.") removed the num_interrupt_lines field from
struct iio_info but the documentation was never updated.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/staging/iio/Documentation/device.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/Documentation/device.txt b/drivers/staging/iio/Documentation/device.txt
index 0338c7c..f03fbd3 100644
--- a/drivers/staging/iio/Documentation/device.txt
+++ b/drivers/staging/iio/Documentation/device.txt
@@ -29,8 +29,6 @@ Then fill in the following:
 	* info->driver_module:
 		Set to THIS_MODULE. Used to ensure correct ownership
 		of various resources allocate by the core.
-	* info->num_interrupt_lines:
-		Number of event triggering hardware lines the device has.
 	* info->event_attrs:
 		Attributes used to enable / disable hardware events.
 	* info->attrs:
-- 
1.7.8.5

