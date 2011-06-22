Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab1FVSkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:40:12 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:43537 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758022Ab1FVSkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:40:11 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [1/15] staging: ft1000-pcmcia: delete ft1000.conf
Date: Wed, 22 Jun 2011 20:39:53 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222039.56645.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless ft1000.conf file.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

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
