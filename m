Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2HTTxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:53:51 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:42536 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab2HTTxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:53:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1345492417!14742896!25
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] staging: comedi: comedi_bond: remove the STR macro
Date: Mon, 20 Aug 2012 12:53:36 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201253.37129.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is not used in the file. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 1ca939c..e6ac27d 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -60,10 +60,6 @@ Configuration Options:
 #define MAX_CHANS 256
 
 #define MODULE_NAME "comedi_bond"
-#ifndef STR
-#  define STR1(x) #x
-#  define STR(x) STR1(x)
-#endif
 
 struct BondedDevice {
 	struct comedi_device *dev;
-- 
1.7.11

