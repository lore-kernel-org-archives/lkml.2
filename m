Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab0JHACs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab0JHACo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wnN1UmK+Dk9ipd81oDDKJa8TxmeuB7p2htOP3KWAzdBqhvuu7G/Jj0WDQrFcqmjudz
         FrtZEO91L2vcMkHuWUjVg7qPTURPSKfQhduEZKUKUOb4puNFo3MF6UpMSXfgTm0DBdNT
         eQ8O8V+LgLJepYtZOks9/EUtJo1IaIHJS3+QU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 31/33] Staging: wlan-ng: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:51 -0400
Message-Id: <1286496113-11897-31-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/wlan-ng/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/Makefile b/drivers/staging/wlan-ng/Makefile
index db5d597..32b69f2 100644
--- a/drivers/staging/wlan-ng/Makefile
+++ b/drivers/staging/wlan-ng/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_PRISM2_USB) += prism2_usb.o
 
-prism2_usb-objs := prism2usb.o \
+prism2_usb-y := prism2usb.o \
 		p80211conv.o \
 		p80211req.o \
 		p80211wep.o \
-- 
1.7.3.1.50.g1e633

