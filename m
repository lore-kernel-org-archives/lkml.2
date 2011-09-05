Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1IETKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:10:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48270 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1IETJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:09:58 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: [PATCH 2/2] Documentation: leds-class: fix a typo
Date: Tue,  6 Sep 2011 03:09:46 +0800
Message-Id: <1315249786-15387-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 Documentation/leds/leds-class.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
index 4996586..79699c2 100644
--- a/Documentation/leds/leds-class.txt
+++ b/Documentation/leds/leds-class.txt
@@ -61,8 +61,8 @@ Hardware accelerated blink of LEDs
 Some LEDs can be programmed to blink without any CPU interaction. To
 support this feature, a LED driver can optionally implement the
 blink_set() function (see <linux/leds.h>). To set an LED to blinking,
-however, it is better to use use the API function led_blink_set(),
-as it will check and implement software fallback if necessary.
+however, it is better to use the API function led_blink_set(), as it
+will check and implement software fallback if necessary.
 
 To turn off blinking again, use the API function led_brightness_set()
 as that will not just set the LED brightness but also stop any software
-- 
1.7.4.1

