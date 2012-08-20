Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2HTTyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:54:11 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:21543 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2HTTyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:54:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1345492432!24550728!30
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] staging: comedi: comedi_bond: remove MODULE_NAME macro
Date: Mon, 20 Aug 2012 12:53:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201253.56950.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is only used in the MODULE_DESCRIPTION. Just remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index e6ac27d..6b516ed 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -59,8 +59,6 @@ Configuration Options:
 /* The maxiumum number of channels per subdevice. */
 #define MAX_CHANS 256
 
-#define MODULE_NAME "comedi_bond"
-
 struct BondedDevice {
 	struct comedi_device *dev;
 	unsigned minor;
@@ -374,7 +372,7 @@ static struct comedi_driver bonding_driver = {
 module_comedi_driver(bonding_driver);
 
 MODULE_AUTHOR("Calin A. Culianu");
-MODULE_DESCRIPTION(MODULE_NAME "A driver for COMEDI to bond multiple COMEDI "
+MODULE_DESCRIPTION("comedi_bond: A driver for COMEDI to bond multiple COMEDI "
 		   "devices together as one.  In the words of John Lennon: "
 		   "'And the world will live as one...'");
 MODULE_LICENSE("GPL");
-- 
1.7.11

