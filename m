Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab1DBGlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 02:41:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48018 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1DBGlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 02:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FbjHAmd+eafQ8urDBUsPXJi/rA4sE2V9Kq6R8apg/Q0qXhOHLjmib82AUFDHRHxFLp
         1w1As0wAo1z5KGV+53iYovn+ySx4rZfN8SnNVFq2anCVC13g/GJQa0fVSQ+NqnlSdDCP
         Mo6dvDWDEc/A85WqHOXyboB/pbYM2B4deORu8=
From: Liu Yuan <namei.unix@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drivers, mfd: Remove unused variable 'val'
Date: Sat,  2 Apr 2011 14:41:39 +0800
Message-Id: <1301726499-6010-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>


Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
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
1.7.1

