Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0LIKZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:25:05 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57067 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0LIKYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=TVFo5PPppE4i3gzsGrxGHxih5YZIWlizw+IrMK4BsC1S8b/BG4JX7ef7jOrHqbmBAu
         Np4evGjqhvWVObP1sFGcEl//jyzf1IHSnaqIEeOvFubqwosEtHJl9DXs5oWNjzs5VEPE
         QPTt3nqlKXKs2ummWZ+MfjQJRlRdLu0/ANpBg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 7/8] staging: ft1000: Remove unused headers.
Date: Thu,  9 Dec 2010 11:26:52 +0100
Message-Id: <1291890413-15255-8-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 58aee36..d249c8a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -27,16 +27,12 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/poll.h>
 #include <linux/netdevice.h>
 #include <linux/delay.h>
 
-#include <linux/fs.h>
-#include <linux/kmod.h>
 #include <linux/ioctl.h>
-#include <linux/unistd.h>
 #include <linux/debugfs.h>
 #include "ft1000_usb.h"
 
-- 
1.7.1

