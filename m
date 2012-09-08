Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2IHTmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 15:42:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38719 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2IHTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 15:42:38 -0400
From: anish kumar <anish198519851985@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] iio: Documentation change for inkern interface.
Date: Sun,  9 Sep 2012 01:12:17 +0530
Message-Id: <1347133337-7795-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

This commit- 314be14bb renamed the _st_ functions to loose the bit
that was meant for staging version but forgot to change
the documentation which still have _st_ sprinkled in some of the
places.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/staging/iio/Documentation/inkernel.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/Documentation/inkernel.txt b/drivers/staging/iio/Documentation/inkernel.txt
index a05823e..ab52840 100644
--- a/drivers/staging/iio/Documentation/inkernel.txt
+++ b/drivers/staging/iio/Documentation/inkernel.txt
@@ -48,11 +48,11 @@ There are then a number of functions that can be used to get information
 about this channel such as it's current reading.
 
 e.g.
-iio_st_read_channel_raw() - get a reading
-iio_st_read_channel_type() - get the type of channel
+iio_read_channel_raw() - get a reading
+iio_get_channel_type() - get the type of channel
 
 There is also provision for retrieving all of the channels associated
 with a given consumer.  This is useful for generic drivers such as
 iio_hwmon where the number and naming of channels is not known by the
-consumer driver.  To do this, use iio_st_channel_get_all.
+consumer driver.  To do this, use iio_channel_get_all.
 
-- 
1.7.1

