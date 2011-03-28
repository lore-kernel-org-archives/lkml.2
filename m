Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1C1QdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:33:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1C1Qaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h5yurMujmKgK35S/3exiACGupWTkbhXU9QsiO8wPWAE/m9WqnwisqzaHgVso6N8CbB
         LpC/TgQsGa62lEQ7nlfm4uHSthA/A3ix7EmYsLb4EDhRoum5NYeElEfiEZG6EmEF6a4T
         uj69CBsrWK+C4bdbXnqroeXZeJY/nY8KZlXr8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 15/25]drivers:block Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:38 -0700
Message-Id: <1301329788-3423-16-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/block/drbd/drbd_int.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b0bd27d..7c2c9b1 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -28,7 +28,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/bitops.h>
-- 
1.7.4.1

