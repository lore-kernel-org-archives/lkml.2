Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2DPN5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 09:57:01 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:45635
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab2DPN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 09:56:59 -0400
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <swarren@wwwdotorg.org>
Subject: [PATCH 2/3] pinctrl: a minor fix of pin config debug information
Date: Mon, 16 Apr 2012 22:07:24 +0800
Message-ID: <1334585244-10249-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334585244-10249-1-git-send-email-b29396@freescale.com>
References: <1334585244-10249-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 drivers/pinctrl/pinconf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 384dcc1..5d231b3 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -455,7 +455,7 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 		return 0;
 
 	seq_puts(s, "Pin config settings per pin\n");
-	seq_puts(s, "Format: pin (name): pinmux setting array\n");
+	seq_puts(s, "Format: pin (name): configs\n");
 
 	mutex_lock(&pinctrl_mutex);
 
@@ -506,7 +506,7 @@ static int pinconf_groups_show(struct seq_file *s, void *what)
 		return 0;
 
 	seq_puts(s, "Pin config settings per pin group\n");
-	seq_puts(s, "Format: group (name): pinmux setting array\n");
+	seq_puts(s, "Format: group (name): configs\n");
 
 	mutex_lock(&pinctrl_mutex);
 
-- 
1.7.0.4


