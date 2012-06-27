Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2F0BJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:09:48 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:61775 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2F0BJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:09:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-132.messagelabs.com!1340759385!9744056!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 32/36] staging: comedi: cb_pcidas: fix remaining checkpatch.pl issues
Date: Tue, 26 Jun 2012 18:09:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261809.40917.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the remaining three "WARNING: line over 80 characters" issues
reported by checkpatch.pl.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index c0d9340..2a282d3 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -28,7 +28,8 @@
 */
 /*
 Driver: cb_pcidas
-Description: MeasurementComputing PCI-DAS series with the AMCC S5933 PCI controller
+Description: MeasurementComputing PCI-DAS series
+  with the AMCC S5933 PCI controller
 Author: Ivan Martinez <imr@oersted.dtu.dk>,
   Frank Mori Hess <fmhess@users.sourceforge.net>
 Updated: 2003-3-11
@@ -243,7 +244,7 @@ struct cb_pcidas_board {
 	int ai_speed;		/*  fastest conversion period in ns */
 	int ao_nchan;		/*  number of analog out channels */
 	int has_ao_fifo;	/*  analog output has fifo */
-	int ao_scan_speed;	/*  analog output speed for 1602 series (for a scan, not conversion) */
+	int ao_scan_speed;	/*  analog output scan speed for 1602 series */
 	int fifo_size;		/*  number of samples fifo can hold */
 	const struct comedi_lrange *ranges;
 	enum trimpot_model trimpot;
@@ -525,8 +526,6 @@ static int cb_pcidas_ao_fifo_winsn(struct comedi_device *dev,
 	return 1;
 }
 
-/* analog output readback insn */
-/* XXX loses track of analog output value back after an analog ouput command is executed */
 static int cb_pcidas_ao_readback_insn(struct comedi_device *dev,
 				      struct comedi_subdevice *s,
 				      struct comedi_insn *insn,
-- 
1.7.11

