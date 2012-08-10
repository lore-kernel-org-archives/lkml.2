Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab2HJOxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:53:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33577 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2HJOxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:53:32 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] Pinctrl header: trivial: declare struct device
Date: Fri, 10 Aug 2012 16:52:58 +0200
Message-Id: <1344610378-12117-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As struct device is used as a function argument, it should at least be
declared (device.h is not included).

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 include/linux/pinctrl/consumer.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 6dd96fb..e9b7f43 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -20,6 +20,7 @@
 /* This struct is private to the core and should be regarded as a cookie */
 struct pinctrl;
 struct pinctrl_state;
+struct device;
 
 #ifdef CONFIG_PINCTRL
 
-- 
1.7.2.5

