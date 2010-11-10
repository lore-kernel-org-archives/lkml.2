Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0KJKNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:13:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54412 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0KJKNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qAbRHJOvXWxxddjoo/w9UVVWBvpzMSubJY1lhzUUgxEteIvOdUN9kCO4p1OB2CpSZo
         O+fzrNf1U/zPozYDGhMqxbW+TH1/17ct/rXKwtuMREopPkP2R4tODKqao0qAY+BEL5Zy
         BoGM5MNnN+PaCqRsU33CCw9qAlLR/uOJS0jVA=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/3] staging: ft1000: Fix compilation warning.
Date: Wed, 10 Nov 2010 11:15:26 +0100
Message-Id: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 99e3339..b7c4602 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -64,7 +64,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	int i, ret = 0, size;
 
 	struct ft1000_device *ft1000dev;
-	struct ft1000_info *pft1000info;
+	struct ft1000_info *pft1000info = NULL;
 	const struct firmware *dsp_fw;
 
 	ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
-- 
1.7.1

