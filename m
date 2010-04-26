Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab0DZEUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 00:20:38 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:22959 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0DZEUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 00:20:36 -0400
X-IronPort-AV: E=Sophos;i="4.52,271,1270440000"; 
   d="scan'208";a="15849351"
From: Barry Song <21cnbao@gmail.com>
To: jic23@cam.ac.uk, gregkh@suse.de
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
       Barry Song <21cnbao@gmail.com>
Subject: [PATCH] iio: fix typo in userspace example codes and document
Date: Mon, 26 Apr 2010 12:19:01 +0800
Message-ID: <1272255541-11835-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Barry Song <21cnbao@gmail.com>
---
 .../iio/Documentation/lis3l02dqbuffersimple.c      |    2 +-
 drivers/staging/iio/Documentation/userspace.txt    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
index 2b5cfc5..811dd14 100644
--- a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
+++ b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
@@ -20,7 +20,7 @@
 
 #include <linux/types.h>
 #include <dirent.h>
-#include "iio_util.h"
+#include "iio_utils.h"
 
 static const char *ring_access = "/dev/iio/lis3l02dq_ring_access";
 static const char *ring_event = "/dev/iio/lis3l02dq_ring_event";
diff --git a/drivers/staging/iio/Documentation/userspace.txt b/drivers/staging/iio/Documentation/userspace.txt
index 661015a..4838818 100644
--- a/drivers/staging/iio/Documentation/userspace.txt
+++ b/drivers/staging/iio/Documentation/userspace.txt
@@ -56,5 +56,5 @@ KERNEL="ring_event_line*", ID="spi1.0", DRIVER="lis3l02dq", NAME="iio/lis3l02dq_
 KERNEL="event_line*", ID="spi1.0", DRIVER="lis3l02dq", NAME="iio/lis3l02dq_event"
 KERNEL="ring_access*", ID="spi1.0", DRIVER="lis3l02dq", NAME="iio/lis3l02dq_ring_access"
 
-The files, lis3l02dqbuffersimple.c and iio_util.h in this directory provide an example
+The files, lis3l02dqbuffersimple.c and iio_utils.h in this directory provide an example
 of how to use the ring buffer and event interfaces.
-- 
1.5.6.3

