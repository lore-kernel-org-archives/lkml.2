Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0KWM16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:27:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab0KWM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:27:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jFgQbWW8Gq5Vb3UabkU6M7uCup2okMnTKOkx1kQW4+vR1uQAI2s3fc8XWb/LYzjRZw
         1pfr8nEOOJYcBMqaSCdXFUc4ORHKdfKLbp6UQC9VQVZrUtqeMt3tpVYCfp5G8l40wpY4
         fB6ZWw1zbODIT73oI/9QtgRKST1UcoShFK8d4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/6] staging: ft1000: Remove unused headers.
Date: Tue, 23 Nov 2010 13:29:31 +0100
Message-Id: <1290515373-16145-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 8d2c059..3df4b4c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -24,23 +24,14 @@
 // 6/05/06    Whc                Porting to Linux 2.6.9
 //
 //---------------------------------------------------------------------------
-#include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/signal.h>
-#include <linux/errno.h>
 #include <linux/poll.h>
 #include <linux/netdevice.h>
 #include <linux/delay.h>
 #include <linux/miscdevice.h>
-
-#include <linux/fs.h>
-#include <linux/kmod.h>
 #include <linux/ioctl.h>
-#include <linux/unistd.h>
 
 #include "ft1000_usb.h"
-//#include "ft1000_ioctl.h"
 
 static int ft1000_flarion_cnt = 0;
 
-- 
1.7.1

