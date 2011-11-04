Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1KDSXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:23:45 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:59210 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933135Ab1KDSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:23:15 -0400
Message-ID: <4EB42D65.1080807@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rchard.purdie@linuxfoundation.org>
Subject: [PATCH 7/8] Documentation: fix leds-class.txt duplicated word
References: <4EB423D8.9030102@xenotime.net>
In-Reply-To: <4EB423D8.9030102@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan Wu <bryan.wu@canonical.com>

Fix a typo (duplicated word) in Documentation/leds/leds-class.txt

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/leds/leds-class.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx1104.orig/Documentation/leds/leds-class.txt
+++ lnx1104/Documentation/leds/leds-class.txt
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
