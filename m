Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab0IXUH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:07:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:56532 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab0IXUH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:07:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        "Juergen E. Fischer" <fischer@norbit.de>
Subject: [PATCH] SCSI: enable PCMCIA AHA152X on 64bit
Date: Fri, 24 Sep 2010 22:07:51 +0200
Message-Id: <1285358871-31221-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was disabled when x86_64 was introduced, but it is reported to be
working on 64bit by two different people, so let's enable it back
again.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "Juergen E. Fischer" <fischer@norbit.de>
---
 drivers/scsi/pcmcia/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index 53857c6..ecc855c 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -11,7 +11,6 @@ if SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCIA && m
 
 config PCMCIA_AHA152X
 	tristate "Adaptec AHA152X PCMCIA support"
-	depends on !64BIT
 	select SCSI_SPI_ATTRS
 	help
 	  Say Y here if you intend to attach this type of PCMCIA SCSI host
-- 
1.7.2.2

