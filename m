Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1ALRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:25:59 -0500
Received: from mail21.messagelabs.com ([85.158.143.35]:9487 "EHLO
	mail21.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab1ALRZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:25:56 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-21.messagelabs.com!1294853101!24265161!45
X-StarScan-Version: 6.2.9; banners=.,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 Jan 2011 11:25:45 -0600
Subject: [PATCH] kernel/time/jiffies.c: local symbols should be static
Thread-Topic: [PATCH] kernel/time/jiffies.c: local symbols should be static
Thread-Index: Acuyfb8ndROuYGzoTJy/WFMUkgUm9Q==
Message-ID: <0D753D10438DA54287A00B027084269764CE258A50@AUSP01VMBX24.collaborationhost.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0CHQAt0026605

The symbol 'clocksource_jiffies' is not exported and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: John Stultz <johnstul@us.ibm.com>

---

This patch was originally submitted on Dec 28, 2009 and appears to have
been lost.  John Stultz supplied the ack on Jan 4, 2010.

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 5404a84..36d2d83 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -55,7 +55,7 @@ static cycle_t jiffies_read(struct clocksource *cs)
 	return (cycle_t) jiffies;
 }
 
-struct clocksource clocksource_jiffies = {
+static struct clocksource clocksource_jiffies = {
 	.name		= "jiffies",
 	.rating		= 1, /* lowest valid rating*/
 	.read		= jiffies_read,

______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
