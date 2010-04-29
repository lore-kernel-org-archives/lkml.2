Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab0D3SMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:12:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:29065 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab0D3SI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=G8U559ChF1vo273Z816EgQZtvpsLDjDYzYYk8TYe1kZB8YL8fGGhzCgHt6/BDWtG/j
         QeBrV/uVrL3gbp5EqKSbac8AksOVLTffpyYrUVbjmivNLP66QBS34z3ELNC8G3Szbl/H
         FDwnx/mXsHNQSi37zRgP7ncnebphwyWYvC/Xc=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: gregkh@suse.de
Cc: jic23@cam.ac.uk, roel.vannyen@gmail.com, akpm@linux-foundation.org,
       sonic.adi@gmail.com, lindner_marek@yahoo.de, sdietrich@novell.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: iio: Fix remaining code style issues
Date: Thu, 29 Apr 2010 19:27:31 +0200
Message-Id: <1272562051-2098-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix code style issues

Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/iio/industrialio-core.c |    2 +-
 drivers/staging/iio/ring_sw.c           |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 1d77082..dce8dcc 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -810,7 +810,7 @@ int iio_device_register(struct iio_dev *dev_info)
 	ret = iio_device_register_eventset(dev_info);
 	if (ret) {
 		dev_err(dev_info->dev.parent,
-			"Failed to register event set \n");
+			"Failed to register event set\n");
 		goto error_free_sysfs;
 	}
 	if (dev_info->modes & INDIO_RING_TRIGGERED)
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index e95b6a4..4981803 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -126,8 +126,7 @@ int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
 		spin_lock(&ring->buf.shared_ev_pointer.lock);
 
 		ret = iio_push_or_escallate_ring_event(&ring->buf,
-						       IIO_EVENT_CODE_RING_100_FULL,
-						       timestamp);
+			       IIO_EVENT_CODE_RING_100_FUL, timestamp);
 		spin_unlock(&ring->buf.shared_ev_pointer.lock);
 		if (ret)
 			goto error_ret;
-- 
1.6.3.3

