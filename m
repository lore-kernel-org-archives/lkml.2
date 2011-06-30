Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1F3WIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:08:32 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:56577 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753146Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/28] staging: ft1000-pcmcia: fix compilation with FT_DEBUG enabled
Date: Fri,  1 Jul 2011 00:03:31 +0200
Message-Id: <1309471437-12633-3-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete DEBUG statement that prevents compilation with FT_DEBUG enabled.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index eefaa65..798b92c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -266,8 +266,6 @@ static int ft1000_suspend(struct pcmcia_device *link)
 {
 	struct net_device *dev = ((local_info_t *) link->priv)->dev;
 
-	DEBUG(1, "ft1000_cs: ft1000_event(0x%06x)\n", event);
-
 	if (link->open)
 		netif_device_detach(dev);
 	return 0;
-- 
Ondrej Zary

