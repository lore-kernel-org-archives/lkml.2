Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2EIHWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:22:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2EIHWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:22:42 -0400
Date: Wed, 9 May 2012 09:22:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: (cosmetic) fix two entries in DocBook comments
Message-ID: <Pine.LNX.4.64.1205090921540.8599@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:j/xFUK5ELuQBdvlc3AiXkcuRpyCTpR/zR9dGJHeFhNt
 UArA6386vfzEY+xEIK30v5tPDxHdLpFsLEcAu6nrXpf6ZpN6f6
 tu3BgGh7Pv12lbzf1EnRoQOfLhrY9xK2cPUZnrOjkMrpLzFYB5
 YzP3cv7hdteklD2hMS6HcOi4shlaLKlhxv3Nxe9u/2WtPH1vkI
 /WRMcZysZtKVl4wHwH8PCwxf//xg2L+or8dIki+DfAFJZ5orQC
 HNme5g0nBeMSlfQzbC6HJG/6VtliWuDfQ0pIAIQyNwP5dLpaMV
 pIrNdIt+5dOzpEtTD/Y5YzFimBAeAkrxiGKKU2Tyhb/hqLtBya
 lNnMb9AyD2ok7iwYV4EKIMc7P5WhjdfztYgfznAP+u4vB6PTCn
 E/HibuEL9agMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes a repeated word and a repeated and incomplete line from two
pinctrl headers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/pinctrl/pinconf.h |    1 -
 include/linux/pinctrl/pinmux.h  |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index ec431f0..b6d2011 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -25,7 +25,6 @@ struct seq_file;
  * @pin_config_get: get the config of a certain pin, if the requested config
  *	is not available on this controller this should return -ENOTSUPP
  *	and if it is available but disabled it should return -EINVAL
- * @pin_config_get: get the config of a certain pin
  * @pin_config_set: configure an individual pin
  * @pin_config_group_get: get configurations for an entire pin group
  * @pin_config_group_set: configure all pins in a group
diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
index 47e9237..a192f57 100644
--- a/include/linux/pinctrl/pinmux.h
+++ b/include/linux/pinctrl/pinmux.h
@@ -23,7 +23,7 @@ struct pinctrl_dev;
 /**
  * struct pinmux_ops - pinmux operations, to be implemented by pin controller
  * drivers that support pinmuxing
- * @request: called by the core to see if a certain pin can be made available
+ * @request: called by the core to see if a certain pin can be made
  *	available for muxing. This is called by the core to acquire the pins
  *	before selecting any actual mux setting across a function. The driver
  *	is allowed to answer "no" by returning a negative error code
-- 
1.7.2.5

