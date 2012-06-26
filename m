Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2FZANe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:13:34 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:33829 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab2FZANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:13:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1340669612!7802472!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/33] staging: comedi: cb_das16_cs: cleanup the boardinfo
Date: Mon, 25 Jun 2012 17:13:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251713.24096.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, reorder the boardinfo to match the
MODULE_DEVICE_TABLE. Also reorder the data to match the
struct definition and add some whitespace to improve
readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 2690228..f90c12b 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -65,22 +65,21 @@ struct das16cs_board {
 	int device_id;
 	int n_ao_chans;
 };
+
 static const struct das16cs_board das16cs_boards[] = {
 	{
-	 .device_id = 0x0000,	/* unknown */
-	 .name = "PC-CARD DAS16/16",
-	 .n_ao_chans = 0,
-	 },
-	{
-	 .device_id = 0x0039,
-	 .name = "PC-CARD DAS16/16-AO",
-	 .n_ao_chans = 2,
-	 },
-	{
-	 .device_id = 0x4009,
-	 .name = "PCM-DAS16s/16",
-	 .n_ao_chans = 0,
-	 },
+		.name		= "PC-CARD DAS16/16-AO",
+		.device_id	= 0x0039,
+		.n_ao_chans	= 2,
+	}, {
+		.name		= "PCM-DAS16s/16",
+		.device_id	= 0x4009,
+		.n_ao_chans	= 0,
+	}, {
+		.name		= "PC-CARD DAS16/16",
+		.device_id	= 0x0000,	/* unknown */
+		.n_ao_chans	= 0,
+	},
 };
 
 struct das16cs_private {
-- 
1.7.11

