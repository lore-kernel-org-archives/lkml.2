Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1FCAeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 20:34:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46151 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1FCAeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 20:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qsZicN3PjpkdgnEsC9+i4fKBedrTvz37WA7dIjIaKAeeThceTOnWpC+nqijYNxdkz5
         bKGM+WBF1mE+5z48SUikZE8CiDpnJfMU+nvx8/4QplFNEUlsbLsPoSja85aEEoF+NYBZ
         A1X73EPMVoZtTVBvynVIM9gMZOrVmuN2xfXD4=
From: Curtis McEnroe <programble@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Curtis McEnroe <programble@gmail.com>
Subject: [PATCH 4/5] [media] tm6000: Clean up code style in tm6000-input.c
Date: Thu,  2 Jun 2011 20:33:33 -0400
Message-Id: <1307061214-14837-3-git-send-email-programble@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307061214-14837-1-git-send-email-programble@gmail.com>
References: <1307061214-14837-1-git-send-email-programble@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary braces.

Signed-off-by: Curtis McEnroe <programble@gmail.com>
---
 drivers/staging/tm6000/tm6000-input.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index dae2f1f..70a2c5f 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -449,9 +449,8 @@ int tm6000_ir_fini(struct tm6000_core *dev)
 
 	rc_unregister_device(ir->rc);
 
-	if (ir->int_urb) {
+	if (ir->int_urb)
 		tm6000_ir_int_stop(dev);
-	}
 
 	kfree(ir);
 	dev->ir = NULL;
-- 
1.7.5.2

