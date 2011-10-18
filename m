Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1JRMHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:07:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53163 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab1JRMHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:07:05 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, jic23@cam.ac.uk, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv2 6/7] input/cma3000_d0x: Unwind reverse order of init
Date: Tue, 18 Oct 2011 14:06:35 +0200
Message-Id: <1318939596-27330-7-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/cma3000_d0x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index e1d27d0..9836264 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -407,8 +407,8 @@ EXPORT_SYMBOL(cma3000_init);
 
 void cma3000_exit(struct cma3000_accl_data *data)
 {
-	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
+	free_irq(data->irq, data);
 	kfree(data);
 }
 EXPORT_SYMBOL(cma3000_exit);
-- 
1.7.7

