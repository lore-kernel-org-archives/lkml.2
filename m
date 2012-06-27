Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2F0BA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:00:28 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:56107 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2F0BA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:00:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1340758825!6930538!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/36] staging: comedi: cb_pcidas: cleanup the boardinfo 4
Date: Tue, 26 Jun 2012 18:00:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261800.20280.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, rename the ai_se_chans variable to
ai_nchan. It's a bit shorter and provides the necessary
information about the variable.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 59b0f91..3cdd026 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -239,7 +239,7 @@ enum trimpot_model {
 struct cb_pcidas_board {
 	const char *name;
 	unsigned short device_id;
-	int ai_se_chans;	/*  Inputs in single-ended mode */
+	int ai_nchan;		/*  Inputs in single-ended mode */
 	int ai_bits;		/*  analog input resolution */
 	int ai_speed;		/*  fastest conversion period in ns */
 	int ao_nchan;		/*  number of analog out channels */
@@ -256,7 +256,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	{
 		.name		= "pci-das1602/16",
 		.device_id	= 0x1,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 16,
 		.ai_speed	= 5000,
 		.ao_nchan	= 2,
@@ -270,7 +270,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	}, {
 		.name		= "pci-das1200",
 		.device_id	= 0xF,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
 		.ao_nchan	= 2,
@@ -280,7 +280,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	}, {
 		.name		= "pci-das1602/12",
 		.device_id	= 0x10,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
 		.ao_nchan	= 2,
@@ -293,7 +293,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	}, {
 		.name		= "pci-das1200/jr",
 		.device_id	= 0x19,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
 		.fifo_size	= 1024,
@@ -302,7 +302,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	}, {
 		.name		= "pci-das1602/16/jr",
 		.device_id	= 0x1C,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 16,
 		.ai_speed	= 5000,
 		.fifo_size	= 512,
@@ -313,7 +313,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	}, {
 		.name		= "pci-das1000",
 		.device_id	= 0x4C,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 12,
 		.ai_speed	= 4000,
 		.fifo_size	= 1024,
@@ -322,7 +322,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	}, {
 		.name		= "pci-das1001",
 		.device_id	= 0x1a,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 12,
 		.ai_speed	= 6800,
 		.ao_nchan	= 2,
@@ -332,7 +332,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	}, {
 		.name		= "pci-das1002",
 		.device_id	= 0x1b,
-		.ai_se_chans	= 16,
+		.ai_nchan	= 16,
 		.ai_bits	= 12,
 		.ai_speed	= 6800,
 		.ao_nchan	= 2,
@@ -1615,8 +1615,8 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 	s->type = COMEDI_SUBD_AI;
 	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF | SDF_CMD_READ;
 	/* WARNING: Number of inputs in differential mode is ignored */
-	s->n_chan = thisboard->ai_se_chans;
-	s->len_chanlist = thisboard->ai_se_chans;
+	s->n_chan = thisboard->ai_nchan;
+	s->len_chanlist = thisboard->ai_nchan;
 	s->maxdata = (1 << thisboard->ai_bits) - 1;
 	s->range_table = thisboard->ranges;
 	s->insn_read = cb_pcidas_ai_rinsn;
-- 
1.7.11

