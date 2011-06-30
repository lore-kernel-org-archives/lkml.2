Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1F3WEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:04:21 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:37152 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/28] staging: ft1000-pcmcia: delete unused TIMEMSG typedefs
Date: Fri,  1 Jul 2011 00:03:37 +0200
Message-Id: <1309471437-12633-9-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused TIMEMSG typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index e4537e0..95ba8c7 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -304,13 +304,6 @@ struct media_msg {
 	u32 dns_2;
 } __attribute__ ((packed));
 
-typedef struct _TIMEMSG {
-	struct pseudo_hdr pseudo;
-	u16 type;
-	u16 length;
-	u8  timeval[8];
-} __attribute__ ((packed)) TIMEMSG, *PTIMEMSG;
-
 typedef struct _DSPINITMSG {
     struct pseudo_hdr pseudo;
     u16 type;
-- 
Ondrej Zary

