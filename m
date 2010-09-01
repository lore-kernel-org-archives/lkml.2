Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab0IANtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:49:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34110 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab0IANsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:48:55 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] trivial: fix typos concerning "offset"
Date: Wed,  1 Sep 2010 15:48:34 +0200
Message-Id: <1283348918-7204-11-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283348918-7204-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1283348918-7204-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 include/linux/firewire-cdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index 68c642d..59ea406 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -273,7 +273,7 @@ struct fw_cdev_event_iso_interrupt {
  * @closure:	See &fw_cdev_event_common;
  *		set by %FW_CDEV_CREATE_ISO_CONTEXT ioctl
  * @type:	%FW_CDEV_EVENT_ISO_INTERRUPT_MULTICHANNEL
- * @completed:	Offset into the receive buffer; data before this offest is valid
+ * @completed:	Offset into the receive buffer; data before this offset is valid
  *
  * This event is sent in multichannel contexts (context type
  * %FW_CDEV_ISO_CONTEXT_RECEIVE_MULTICHANNEL) for &fw_cdev_iso_packet buffer
-- 
1.7.1

