Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1B0Ehe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:37:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab1B0Eeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kjQghTyCw0EsavzXKegmIDQ9agPGn/erZTnscmDzKrKrfuqppLA8Cj9gCgb4qVvSvm
         BBlxnTXBzPVWsNsJymxHCRH14eXj2CANkG6aYGYyFGFQCIwFSeS71KxOGLgXzPmfhjwX
         SKVtcXVmfRQLT3A4EsalMuWa1OYX2t8gg6r3o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [PATCH 04/17]drivers:usb:host:uhci-hcd.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:33:57 -0800
Message-Id: <1298781250-2718-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org
---
 drivers/usb/host/uhci-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index cee8678..4f65b14 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -471,7 +471,7 @@ static irqreturn_t uhci_irq(struct usb_hcd *hcd)
 
 /*
  * Store the current frame number in uhci->frame_number if the controller
- * is runnning.  Expand from 11 bits (of which we use only 10) to a
+ * is running.  Expand from 11 bits (of which we use only 10) to a
  * full-sized integer.
  *
  * Like many other parts of the driver, this code relies on being polled
-- 
1.7.4.1

