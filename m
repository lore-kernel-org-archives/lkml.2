Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0LIPMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:12:17 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36848 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab0LIPLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=RyUjUBGApW48w2/pZnnFUcvqlmgPFrfzHjC3W+IJ7AXvOUeDUI/T/rJnsWAHBiS1h3
         cCFHp5uZOjOad1zKAO9TL5pFE43snnRU6VeZm1P5/vCUO3ggTEK3ybR611HQsFOzJm5c
         V/6Gl23D/4yg6qHN2CavbKN7RvEaK/2QXwIew=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 6/8] staging: ft1000: Fix coding style.
Date: Thu,  9 Dec 2010 16:13:52 +0100
Message-Id: <1291907634-22437-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 773316f..bd28a6b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -14,23 +14,19 @@
 
 #define PUTX_TO_PAGE(len,page,message,size,var) \
 	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for(i = 0; i < (size - 1); i++) \
-	{ \
+	for (i = 0; i < (size - 1); i++) {\
 		len += snprintf(page+len, PAGE_SIZE - len, "%02x:", var[i]); \
 	} \
 	len += snprintf(page+len, PAGE_SIZE - len, "%02x\n", var[i])
 
 #define PUTD_TO_PAGE(len,page,message,size,var) \
 	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for(i = 0; i < (size - 1); i++) \
-	{ \
+	for (i = 0; i < (size - 1); i++) {\
 		len += snprintf(page+len, PAGE_SIZE - len, "%d.", var[i]); \
 	} \
 	len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i])
 
 
-
-
 //#ifdef INIT_NET_NS
 #define FTNET_PROC init_net.proc_net
 //#else
-- 
1.7.1

