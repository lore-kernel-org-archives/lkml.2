Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2IYH4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:56:55 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:41231 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753536Ab2IYH4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:56:44 -0400
From: Roland Stigge <stigge@antcom.de>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        aletes.xgr@gmail.com, kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/2] gpio: Document device_node's det_debounce
Date: Tue, 25 Sep 2012 09:56:14 +0200
Message-Id: <1348559774-15484-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348559774-15484-1-git-send-email-stigge@antcom.de>
References: <1348559774-15484-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for set_debounce in struct device_node.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 include/asm-generic/gpio.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/include/asm-generic/gpio.h
+++ linux-2.6/include/asm-generic/gpio.h
@@ -60,6 +60,8 @@ struct device_node;
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
+ * @set_debounce: optional hook for setting debounce time for specified gpio in
+ *      interrupt triggered gpio chips
  * @set: assigns output value for signal "offset"
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
