Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1DJOMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:12:13 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:49406 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1DJOMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qxsFlTi2k3ygqJEGQtpTe0aodKLZ6RNL80VYOirK9wlcoeZCZ4CEzhOF3imHJY7NdR
         MqApuTBx0pY5gASV5F90awLsxFlDZBJYH87wvrvdqGTbHB5Zq1vJwDYGtwCin+r6XRm0
         gLB7hiD3tZ4+AdQ1gxd8AjGpeWUE/rAn8cowo=
From: wanlong.gao@gmail.com
To: broonie@opensource.wolfsonmicro.com, geert@linux-m68k.org,
        starvik@axis.com, jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 2/5] mfd:removed the unused variable
Date: Sun, 10 Apr 2011 22:10:26 +0800
Message-Id: <1302444629-17043-2-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
References: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

removed the unused variable "u16 val" of wl1273-core.c.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/mfd/wl1273-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index 04914f2..37af778 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -153,7 +153,6 @@ out:
  */
 static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
 {
-	u16 val;
 	int r;
 
 	if (volume > WL1273_MAX_VOLUME)
-- 
1.7.3

