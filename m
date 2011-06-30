Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1F3WE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:04:29 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40075 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752124Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/28] staging: ft1000-pcmcia: delete ft1000.conf
Date: Fri,  1 Jul 2011 00:03:32 +0200
Message-Id: <1309471437-12633-4-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless ft1000.conf file.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)
 delete mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf
deleted file mode 100644
index e2321a4..0000000
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf
+++ /dev/null
@@ -1,14 +0,0 @@
-device "ft1000_cs"
-     class "network" module "ft1000","ft1000_cs"
-
-card "flarion FT1000"
-     manfid 0x02cc, 0x0100
-     bind "ft1000_cs"
-
-card "flarion FT1000"
-     manfid 0x02cc, 0x1000
-     bind "ft1000_cs"
-
-card "flarion FT1000"
-     manfid 0x02cc, 0x1300
-     bind "ft1000_cs"
-- 
Ondrej Zary

