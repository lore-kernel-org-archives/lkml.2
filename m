Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1B0Ehv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:37:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54065 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1B0Eef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UbYk37YxlEjU/2JsTVhjCUWf6mZfL2u98P06rGpwvKxqQZ4gQUjoXRcXcAFgO0iB4n
         H/T9wmrMN3lYzgwWMXuYIoMuiayNTXD9mgmyP6oRN/FLTq49mMQEiOGst4KeSI/+RMCa
         po1TIgBH1y82/pej8u+W8CWtBcaH5PSaXrX6w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: [PATCH 03/17]drivers:usb:core:hub.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:33:56 -0800
Message-Id: <1298781250-2718-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org
---
 drivers/usb/core/hub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d041c68..bb9a25d 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -616,7 +616,7 @@ static int hub_port_disable(struct usb_hub *hub, int port1, int set_state)
 }
 
 /*
- * Disable a port and mark a logical connnect-change event, so that some
+ * Disable a port and mark a logical connect-change event, so that some
  * time later khubd will disconnect() any existing usb_device on the port
  * and will re-enumerate if there actually is a device attached.
  */
-- 
1.7.4.1

