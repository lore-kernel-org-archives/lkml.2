Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1F3FLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:11:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65284 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1F3FLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:11:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6392"; a="101005845"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: balbi@ti.com
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] usb: gadget: Compilation warning fix
Date: Thu, 30 Jun 2011 08:10:24 +0300
Message-Id: <1309410625-27385-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A compilation warning was added by the patch
"usb: gadget: use config_ep_by_speed() instead of ep_choose()".
This patch fixed it.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/storage_common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 1fa4f70..544e6b3 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -494,7 +494,7 @@ static struct usb_descriptor_header *fsg_hs_function[] = {
 };
 
 /* Maxpacket and other transfer characteristics vary by speed. */
-static struct usb_endpoint_descriptor *
+__maybe_unused static struct usb_endpoint_descriptor *
 fsg_ep_desc(struct usb_gadget *g, struct usb_endpoint_descriptor *fs,
 		struct usb_endpoint_descriptor *hs)
 {
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
