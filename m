Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab0IIWgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:36:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47134 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab0IIWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:36:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DWmobtjh8KAXRZVXe2527T1YOEfPH0UZRMhFfVLijqTBCbHa3tZYKgGe946QKAdV8L
         Nq/NLkS92vOqU89IpUhm/84tt87nxHyX26iCgAVsvM7M0r30QKkfbDdHYT87J/bXK5Fz
         KucrxqDBPdR0aJflH3xnZq/IPBbQ9msVo864o=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 114/223]drivers/net/hamradio/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:36:43 -0700
Message-Id: <1284071809-8149-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
References: <1284071809-8149-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/hamradio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 62d5d5c..1faa85b 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -73,7 +73,7 @@ config DMASCC
 	  certain parameters, such as channel access timing, clock mode, and
 	  DMA channel. This is accomplished with a small utility program,
 	  dmascc_cfg, available at
-	  <http://cacofonix.nt.tuwien.ac.at/~oe1kib/Linux/>. Please be sure to
+	  <http://www.linux-ax25.org/wiki/LinuxAX25>. Please be sure to
 	  get at least version 1.27 of dmascc_cfg, as older versions will not
 	  work with the current driver.
 
-- 
1.7.2.1

