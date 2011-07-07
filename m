Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1GGTCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:02:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15448 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab1GGTCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:02:15 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, gregkh@suse.de, rklein@nvidia.com,
        linux-iio@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v2 2/4] staging:iio: Add an iio channel type string to support proximity sensors.
Date: Thu,  7 Jul 2011 12:01:55 -0700
Message-Id: <1310065317-3872-3-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310065317-3872-1-git-send-email-bfreed@chromium.org>
References: <1310065317-3872-1-git-send-email-bfreed@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "proximity" to the iio_chan_type_name_spec_shared string list to
support proximity sensors.
Now this list fully matches the declared iio_chan_type enums.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/industrialio-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 52a02af..19819e7 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -54,6 +54,7 @@ static const char * const iio_chan_type_name_spec_shared[] = {
 	[IIO_MAGN] = "magn",
 	[IIO_LIGHT] = "illuminance",
 	[IIO_INTENSITY] = "intensity",
+	[IIO_PROXIMITY] = "proximity",
 	[IIO_TEMP] = "temp",
 	[IIO_INCLI] = "incli",
 	[IIO_ROT] = "rot",
-- 
1.7.3.1

