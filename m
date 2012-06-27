Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2F0A4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:56:12 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:30556 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2F0A4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:56:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1340758570!12607924!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/36] staging: comedi: cb_pcidas: remove unused io region size defines
Date: Tue, 26 Jun 2012 17:56:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261756.05199.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The defines for the size of the io regions are not used in the
driver. Also, this information can be found using the pci helper
pci_resource_len(). Remove the defines.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index e790ab0..4b653c5 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -89,12 +89,6 @@ analog triggering on 1602 series
 #define NUM_CHANNELS_8402 2
 #define NUM_CHANNELS_DAC08 1
 
-/* sizes of io regions */
-#define CONT_STAT_SIZE 10
-#define ADC_FIFO_SIZE 4
-#define PACER_SIZE 12
-#define AO_SIZE 4
-
 /* Control/Status registers */
 #define INT_ADCFIFO	0	/*  INTERRUPT / ADC FIFO register */
 #define   INT_EOS 0x1		/*  interrupt end of scan */
-- 
1.7.11

