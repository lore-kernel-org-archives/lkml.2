Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0IWPUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:20:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36448 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0IWPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FyKlXWMhRqzhJbzX5SI/Yn0pR2AU3JZJVuaeWUNaigklxq1WmJ8hp10BuI0H5JYVM7
         husaPO5ctqszxFWUxTEzCBl5H+BNHd0YEmajpvq9zUyx0BSk2CStRRbT4jgjhS/bgsQ+
         BK1CHR0GnWbUkxdeMWsJkmVEBErL0wakD1ddQ=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pcmcia@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/5] Makefile.fwinst: include Makefile.lib
Date: Thu, 23 Sep 2010 19:19:53 +0400
Message-Id: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include Makefile.lib into Makefile.fwinst to enable _shipped processing.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 scripts/Makefile.fwinst |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 6bf8e87..fd34b74 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -16,6 +16,7 @@ include scripts/Kbuild.include
 include $(srctree)/$(obj)/Makefile
 
 include scripts/Makefile.host
+include scripts/Makefile.lib
 
 mod-fw := $(fw-shipped-m)
 # If CONFIG_FIRMWARE_IN_KERNEL isn't set, then install the 
-- 
1.5.6.5

