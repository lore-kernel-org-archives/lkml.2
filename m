Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab1D2Fl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 01:41:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59821 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1D2FlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 01:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=sjhbMWabJffO1ufsRN0Lqy4lxgsDVz/ygQIugSsvE+JzXVyQSgZ37yKYa4+ivzCW60
         XnHTGW64AOMASNTBIx1eY+WIsddvBPoQNlztv41zhf+Vl/nBr5b/7q4PqoajWKqUATl7
         U/1uOYS9aECB+Nl2L7mNYEk92m5R7zMSuTlKY=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/6] staging: ft1000: Remove unused declaration in ft1000_usb.h.
Date: Fri, 29 Apr 2011 07:41:05 +0200
Message-Id: <1304055670-3573-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index f2ecb3e..bade59d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -586,8 +586,6 @@ extern void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist);
 void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
 
-char *getfw (char *fn, size_t *pimgsz);
-
 int dsp_reload(struct ft1000_device *ft1000dev);
 int init_ft1000_netdev(struct ft1000_device *ft1000dev);
 struct usb_interface;
-- 
1.7.1

