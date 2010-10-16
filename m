Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0JPN1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:27:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab0JPN1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FHRZZx5+XQmeCQblW8X4ELHU+qzqmWabP4lgdnlpNL9ZeJey/lF0jKY0iLWnnUb+hc
         Lxwwc3JcRpJ1MYaMWK7qWbjV3yzIHlCq23TwrC1/eFNb1v8d53eSNzo8pdEa7UxkfaPn
         yfcfSeY8Npkl4X9S/WwGrRv4pI/aXOzMHrMYU=
From: Tracey Dent <tdent48227@gmail.com>
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Cc: mhw@wittsend.com, minyard@acm.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 01/05] Drivers: char: ip2: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 09:26:49 -0400
Message-Id: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/char/ip2/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ip2/Makefile b/drivers/char/ip2/Makefile
index bc397d9..7b78e0d 100644
--- a/drivers/char/ip2/Makefile
+++ b/drivers/char/ip2/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_COMPUTONE)         += ip2.o
 
-ip2-objs			:= ip2main.o
+ip2-y			:= ip2main.o
 
-- 
1.7.3.1.104.gc752e

