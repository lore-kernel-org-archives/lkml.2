Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417Ab0EURDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:03:47 -0400
Received: from kroah.org ([198.145.64.141]:50315 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934090Ab0EUQwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/25] serial: bfin_sport_uart: pull in bfin_sport.h for SPORT defines
Date: Fri, 21 May 2010 09:51:40 -0700
Message-Id: <1274460714-11277-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Now that the SPORT MMR defines have been unified, switch over to it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 0b459cf..66cda22 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -34,6 +34,7 @@
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 
+#include <asm/bfin_sport.h>
 #include <asm/delay.h>
 #include <asm/portmux.h>
 
-- 
1.7.0.3

