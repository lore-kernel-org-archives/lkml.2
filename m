Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0IHV1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:27:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46622 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab0IHV13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:27:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ssYnhUrVdVlGhITg8+PBcjN4BvhYfcVR6nF8YRHBGYs0ynfz7k7Kd8Nb+bOy65U27w
         KMROWMj/T3Azs9Jvy+XYKo8rkVWB9JYLOGTDdP8gsMlmQo+qua7fst8iy1/h4vhJaMNH
         Qpby70hXnlNEVO2yRGOMpJIHq0fdkBLhzdwTM=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: gregkh@suse.de, more.andres@gmail.com, lieb@canonical.com,
        forest@alittletooquiet.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 7/8] drivers/staging/vt6656: use ARRAY_SIZE macro in channel.c
Date: Wed,  8 Sep 2010 22:27:55 +0100
Message-Id: <1283981275-5098-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace (sizeof(ChannelRuleTab) / sizeof(ChannelRuleTab[0])) with
ARRAY_SIZE(ChannelRuleTab) in drivers/staging/vt6656/channel.c

Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
---
 drivers/staging/vt6656/channel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 6ad03e4..a2460ae 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -34,6 +34,7 @@
  *
  */
 
+#include <linux/kernel.h>
 #include "country.h"
 #include "channel.h"
 #include "rf.h"
@@ -367,7 +368,7 @@ static  struct
 /*                                           1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54  55  56  */
 };
 
-#define NUM_RULES	(sizeof(ChannelRuleTab) / sizeof(ChannelRuleTab[0]))
+#define NUM_RULES	ARRAY_SIZE(ChannelRuleTab)
 
 /*---------------------  Export function  -------------------------*/
 /************************************************************************
-- 
1.7.2.3

