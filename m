Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2F0V40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:56:26 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:58208 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2F0V4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:56:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1340834143!12735130!39
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/19] staging: comedi: adl_pci6208: remove the boardinfo 'ao_bits'
Date: Wed, 27 Jun 2012 14:56:03 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271456.03976.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the boards supported by this driver have 16-bit DACs. The
ao_bits variable in the boardinfo is commented out anyway.
Just remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 5f073c5..f949d20 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -58,7 +58,6 @@ struct pci6208_board {
 	const char *name;
 	unsigned short dev_id;	/* `lspci` will show you this */
 	int ao_chans;
-	/* int ao_bits; */
 };
 
 static const struct pci6208_board pci6208_boards[] = {
@@ -66,19 +65,16 @@ static const struct pci6208_board pci6208_boards[] = {
 	   .name = "pci6208v",
 	   .dev_id = 0x6208,      // not sure
 	   .ao_chans = 8
-	   // , .ao_bits = 16
 	   },
 	   {
 	   .name = "pci6216v",
 	   .dev_id = 0x6208,      // not sure
 	   .ao_chans = 16
-	   // , .ao_bits = 16
 	   }, */
 	{
 	 .name = "pci6208a",
 	 .dev_id = 0x6208,
 	 .ao_chans = 8
-	 /* ,    .ao_bits = 16 */
 	 }
 };
 
-- 
1.7.11

