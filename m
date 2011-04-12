Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab1DLTfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:35:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:40341 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab1DLTfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:35:20 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/5] usb/gadget: rename create_ss_descriptors() to usb_create_ss_descriptors()
Date: Tue, 12 Apr 2011 21:34:54 +0200
Message-Id: <1302636896-12717-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
References: <20110411175917.GE4018@linutronix.de>
 <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so have a namespace.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/gadget/composite.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index d12e75a4..92cc238 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -80,7 +80,7 @@ static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
 };
 
 /**
- * create_ss_descriptors() - Generate SuperSpeed descriptors
+ * usb_create_ss_descriptors() - Generate SuperSpeed descriptors
  * with default values
  * @f: pointer to usb_function to generate the descriptors for
  *
@@ -91,7 +91,7 @@ static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
  * This function copies f->hs_descriptors while updating the
  * endpoint descriptor and adding endpoint companion descriptor.
  */
-static void create_ss_descriptors(struct usb_function *f)
+void usb_create_ss_descriptors(struct usb_function *f)
 {
 	struct usb_ss_ep_comp_descriptor	*ep_comp_desc;
 	struct usb_endpoint_descriptor		*ep_desc;
-- 
1.7.4

