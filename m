Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab0IYXLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 19:11:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43204 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab0IYXLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 19:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i0PIRxuEj+5iXvhqih0AmYNXdR8idmYtKK5c95CBD5VW3zzHNJA4ixSceH8TaA8EDA
         5rYLkj+EAKI85/HbYTty3o8w4TlzVrVJcNti1tDLyf6gt5sl+aJ7Fvt84fTrZcZ/fiAj
         jjY8avD7yWqnUsfeBcomh7xU2RJt3FT9ET6BI=
From: Phillip Kurtenbach <pkurtenbach@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Phillip Kurtenbach <pkurtenbach@gmail.com>
Subject: [PATCH] staging: iio: whitespace cleanup
Date: Sun, 26 Sep 2010 01:11:09 +0200
Message-Id: <1285456269-27582-1-git-send-email-pkurtenbach@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed whitespace coding style issues.

Signed-off-by: Phillip Kurtenbach <pkurtenbach@gmail.com>
---
 drivers/staging/iio/industrialio-core.c |    2 +-
 drivers/staging/iio/industrialio-ring.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index dd4d87a..c03e1ae 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -59,7 +59,7 @@ EXPORT_SYMBOL(__iio_change_event);
  * are queued. Hence a client MUST open the chrdev before the ring buffer is
  * switched on.
  */
- int __iio_push_event(struct iio_event_interface *ev_int,
+int __iio_push_event(struct iio_event_interface *ev_int,
 		     int ev_code,
 		     s64 timestamp,
 		     struct iio_shared_ev_pointer *
diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index 6ab578e..972a41a 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -312,7 +312,7 @@ ssize_t iio_read_ring_length(struct device *dev,
 }
 EXPORT_SYMBOL(iio_read_ring_length);
 
- ssize_t iio_write_ring_length(struct device *dev,
+ssize_t iio_write_ring_length(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf,
 			       size_t len)
-- 
1.7.2.3

