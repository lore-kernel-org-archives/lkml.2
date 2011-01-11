Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab1ALADC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:03:02 -0500
Received: from mail127.messagelabs.com ([216.82.250.115]:52927 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab1ALADA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:03:00 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1294790576!6579489!3
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Tue, 11 Jan 2011 17:59:38 -0600
Subject: [PATCH] timekeeping: local symbols should be static
Thread-Topic: [PATCH] timekeeping: local symbols should be static
Thread-Index: Acux65s4TMfZotP6QtWT84sUkXqwog==
Message-ID: <0D753D10438DA54287A00B027084269764CE0E54B7@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0C03Enr022789

Local symbols should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

---

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5bb86da..eef7452 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -49,7 +49,7 @@ struct timekeeper {
 	u32	mult;
 };
 
-struct timekeeper timekeeper;
+static struct timekeeper timekeeper;
 
 /**
  * timekeeper_setup_internals - Set up internals to use clocksource clock.
@@ -164,7 +164,7 @@ static struct timespec total_sleep_time;
 /*
  * The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock.
  */
-struct timespec raw_time;
+static struct timespec raw_time;
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
