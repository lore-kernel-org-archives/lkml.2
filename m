Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1IETc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:32:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58360 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1IETcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:32:51 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: rpurdie@rpsys.net
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] trivial:leds: Fix typo in led triggers.
Date: Mon,  5 Sep 2011 21:32:00 +0200
Message-Id: <1315251120-6897-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/leds/led-triggers.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 4bebae7..834fcb3 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -210,7 +210,7 @@ void led_trigger_unregister(struct led_trigger *trigger)
 }
 EXPORT_SYMBOL_GPL(led_trigger_unregister);
 
-/* Simple LED Tigger Interface */
+/* Simple LED Trigger Interface */
 
 void led_trigger_event(struct led_trigger *trigger,
 			enum led_brightness brightness)
-- 
1.7.4.1

