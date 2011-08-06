Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab1HFS1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 14:27:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43068 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1HFS1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 14:27:14 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, gregkh@suse.de, jic23@cam.ac.uk,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] staging: IIO: DAC: Delete useless label error_ret in ade7854.c
Date: Sun,  7 Aug 2011 02:24:24 +0800
Message-Id: <1312655064-28311-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/staging/iio/meter/ade7854.c: In function 'ade7854_probe':
  drivers/staging/iio/meter/ade7854.c:585: warning: label 'error_ret' defined but not used

The label error_ret is defined, but never used, so delete it to avoid annoying warning.

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/staging/iio/meter/ade7854.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/meter/ade7854.c b/drivers/staging/iio/meter/ade7854.c
index b82659f..ac3f9d5 100644
--- a/drivers/staging/iio/meter/ade7854.c
+++ b/drivers/staging/iio/meter/ade7854.c
@@ -582,7 +582,6 @@ error_unreg_dev:
 	iio_device_unregister(indio_dev);
 error_free_dev:
 	iio_free_device(indio_dev);
-error_ret:
 	return ret;
 }
 EXPORT_SYMBOL(ade7854_probe);
-- 
1.7.0.4

