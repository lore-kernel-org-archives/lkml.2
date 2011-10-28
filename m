Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1J1AjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:39:12 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40114 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab1J1AjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:39:08 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] pch_uart: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Fri, 28 Oct 2011 09:38:50 +0900
Message-Id: <1319762330-7134-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1319762330-7134-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319762330-7134-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/tty/serial/pch_uart.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 6405dd1..a6f9547 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1,5 +1,5 @@
 /*
- *Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
+ *Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
  *
  *This program is free software; you can redistribute it and/or modify
  *it under the terms of the GNU General Public License as published by
@@ -49,8 +49,8 @@ enum {
 
 /* Set the max number of UART port
  * Intel EG20T PCH: 4 port
- * OKI SEMICONDUCTOR ML7213 IOH: 3 port
- * OKI SEMICONDUCTOR ML7223 IOH: 2 port
+ * LAPIS Semiconductor ML7213 IOH: 3 port
+ * LAPIS Semiconductor ML7223 IOH: 2 port
 */
 #define PCH_UART_NR	4
 
-- 
1.7.4.4

