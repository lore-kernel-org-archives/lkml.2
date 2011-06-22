Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab1FVSle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:41:34 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34787 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758604Ab1FVSlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:41:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [8/15] staging: ft1000-pcmcia: delete unused DSPHIBERNATE typedefs
Date: Wed, 22 Jun 2011 20:41:23 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222041.25339.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused DSPHIBERNATE typedefs.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -317,14 +317,6 @@ struct dsp_init_msg {
     u8 RfCalDate[CALDATESZ];    // Rf Calibration date
 } __attribute__ ((packed));
 
-typedef struct _DSPHIBERNATE {
-	struct pseudo_hdr pseudo;
-	u16 type;
-	u16 length;
-	u32 timeout;
-    u16 sess_info[0];
-} DSPHIBERNATE, *PDSPHIBERNATE;
-
 typedef struct _APP_INFO_BLOCK
 {
     u32 fileobject;                // Application's file object

-- 
Ondrej Zary
