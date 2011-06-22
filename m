Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab1FVSlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:41:13 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53652 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758604Ab1FVSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:41:11 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [6/15] staging: ft1000-pcmcia: delete unused TIMEMSG typedefs
Date: Wed, 22 Jun 2011 20:41:02 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222041.04227.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused TIMEMSG typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

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
