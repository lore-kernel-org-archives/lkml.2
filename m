Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0JPN1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:27:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab0JPN1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gpBbrUhg6scZPOpYrraoEWShSJ682ZS29h0/GuK+Z54TDf9J2Xy0U/31uOekEwSCXZ
         hH1jTCKmiWLMVhJbj+kasjZIRzcIFcqUQ7EiTLknDW7j02qh6Seypn2vnOyRd4AH7tRl
         POdUWBiqRja415lqumDTBKt+dn+OjokJmM5BI=
From: Tracey Dent <tdent48227@gmail.com>
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Cc: mhw@wittsend.com, minyard@acm.org,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 02/05] Drivers: char: impi: Makefile: replace the use of <module>-objs with <module>-y
Date: Sat, 16 Oct 2010 09:26:50 -0400
Message-Id: <1287235613-1545-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
In-Reply-To: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
References: <1287235613-1545-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/char/ipmi/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/Makefile b/drivers/char/ipmi/Makefile
index eb8a1a8..16a9364 100644
--- a/drivers/char/ipmi/Makefile
+++ b/drivers/char/ipmi/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the ipmi drivers.
 #
 
-ipmi_si-objs := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
+ipmi_si-y := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
 
 obj-$(CONFIG_IPMI_HANDLER) += ipmi_msghandler.o
 obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += ipmi_devintf.o
-- 
1.7.3.1.104.gc752e

