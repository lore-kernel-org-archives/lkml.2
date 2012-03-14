Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668Ab2CNBF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:05:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760617Ab2CNBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:05:23 -0400
Date: Wed, 14 Mar 2012 05:05:20 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        karl.komierowski@stericsson.com, johan.palsson@stericsson.com,
        linus.walleij@linaro.org
Subject: [PATCH 5/6] ab8500_fg: Fix copy-paste error
Message-ID: <20120314010520.GE10798@oksana.dev.rtsoft.ru>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ab8500_fg_discharge_state_to() function should accept
'enum ab8500_fg_discharge_state' argument, not
'enum ab8500_fg_charge_state'.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/power/ab8500_fg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index b7e12c8..0441f9d 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -1255,7 +1255,7 @@ static void ab8500_fg_charge_state_to(struct ab8500_fg *di,
 }
 
 static void ab8500_fg_discharge_state_to(struct ab8500_fg *di,
-	enum ab8500_fg_charge_state new_state)
+	enum ab8500_fg_discharge_state new_state)
 {
 	dev_dbg(di->dev, "Disharge state from %d [%s] to %d [%s]\n",
 		di->discharge_state,
-- 
1.7.9

