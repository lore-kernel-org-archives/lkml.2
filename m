Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1FHJo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:44:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:53043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1FHJo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,337,1304319600"; 
   d="scan'208";a="13429060"
From: Heikki Krogerus <krohei@gmail.com>
To: Greg KH <gregkh@suse.de>, Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] usb: otg: add events for suspend/resume states
Date: Wed,  8 Jun 2011 12:44:39 +0300
Message-Id: <1307526281-12125-2-git-send-email-krohei@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307526281-12125-1-git-send-email-krohei@gmail.com>
References: <1307526281-12125-1-git-send-email-krohei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those will be used by the charger driver to cut current
drawing when suspended and restart it when resumed.

Signed-off-by: Heikki Krogerus <krohei@gmail.com>
---
 include/linux/usb/otg.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index d87f44f..5f14caf 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -41,6 +41,8 @@ enum usb_xceiv_events {
 	USB_EVENT_ID,           /* id was grounded */
 	USB_EVENT_CHARGER,      /* usb dedicated charger */
 	USB_EVENT_ENUMERATED,   /* gadget driver enumerated */
+	USB_EVENT_SUSPENDED,	/* gadget driver suspended */
+	USB_EVENT_RESUMED,	/* gadget driver resumed */
 };
 
 struct otg_transceiver;
-- 
1.7.4.1

