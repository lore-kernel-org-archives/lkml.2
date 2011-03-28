Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1C1QbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:31:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab1C1Qay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HV5Kevte3sa1ZEqaPqHdBboRPDhqE2tmcMNQrkoO0wMzquwyq0ICsndcwe5YdRvm7k
         8VsanwAyYSYxprSvHJPv8qWfidxJdrDwVjHYbLtvyJONtixgh3gaTQxHJWeb6WRUetHu
         bHhltk0hkTZ6OPtt9JxGE6xKv4ewvzSmhZnoQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 25/25]sound Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:48 -0700
Message-Id: <1301329788-3423-26-git-send-email-justinmattock@gmail.com>
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
 sound/i2c/other/tea575x-tuner.c |    1 -
 sound/pci/asihpi/asihpi.c       |    1 -
 sound/soc/codecs/wm8991.c       |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index ee538f1..1e93dda 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -25,7 +25,6 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <sound/core.h>
 #include <sound/tea575x-tuner.h>
 
diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index 0ac1f98..fe601e7 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -42,7 +42,6 @@
 #include "hpioctl.h"
 
 #include <linux/pci.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 28fdfd6..b629361 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-- 
1.7.4.1

