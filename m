Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2F0A50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:57:26 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:52876 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab2F0A5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:57:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1340758643!7915069!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/36] staging: comedi: cb_pcidas: cleanup the boardinfo 1
Date: Tue, 26 Jun 2012 17:57:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261757.20541.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, add whitespace to the boardinfo to
improve readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 235 ++++++++++++++---------------
 1 file changed, 114 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 0c14582..a5b3659 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -255,127 +255,120 @@ struct cb_pcidas_board {
 
 static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	{
-	 .name = "pci-das1602/16",
-	 .device_id = 0x1,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 16,
-	 .ai_speed = 5000,
-	 .ao_nchan = 2,
-	 .has_ao_fifo = 1,
-	 .ao_scan_speed = 10000,
-	 .fifo_size = 512,
-	 .ranges = &cb_pcidas_ranges,
-	 .trimpot = AD8402,
-	 .has_dac08 = 1,
-	 .is_1602 = 1,
-	 },
-	{
-	 .name = "pci-das1200",
-	 .device_id = 0xF,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 12,
-	 .ai_speed = 3200,
-	 .ao_nchan = 2,
-	 .has_ao_fifo = 0,
-	 .fifo_size = 1024,
-	 .ranges = &cb_pcidas_ranges,
-	 .trimpot = AD7376,
-	 .has_dac08 = 0,
-	 .is_1602 = 0,
-	 },
-	{
-	 .name = "pci-das1602/12",
-	 .device_id = 0x10,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 12,
-	 .ai_speed = 3200,
-	 .ao_nchan = 2,
-	 .has_ao_fifo = 1,
-	 .ao_scan_speed = 4000,
-	 .fifo_size = 1024,
-	 .ranges = &cb_pcidas_ranges,
-	 .trimpot = AD7376,
-	 .has_dac08 = 0,
-	 .is_1602 = 1,
-	 },
-	{
-	 .name = "pci-das1200/jr",
-	 .device_id = 0x19,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 12,
-	 .ai_speed = 3200,
-	 .ao_nchan = 0,
-	 .has_ao_fifo = 0,
-	 .fifo_size = 1024,
-	 .ranges = &cb_pcidas_ranges,
-	 .trimpot = AD7376,
-	 .has_dac08 = 0,
-	 .is_1602 = 0,
-	 },
-	{
-	 .name = "pci-das1602/16/jr",
-	 .device_id = 0x1C,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 16,
-	 .ai_speed = 5000,
-	 .ao_nchan = 0,
-	 .has_ao_fifo = 0,
-	 .fifo_size = 512,
-	 .ranges = &cb_pcidas_ranges,
-	 .trimpot = AD8402,
-	 .has_dac08 = 1,
-	 .is_1602 = 1,
-	 },
-	{
-	 .name = "pci-das1000",
-	 .device_id = 0x4C,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 12,
-	 .ai_speed = 4000,
-	 .ao_nchan = 0,
-	 .has_ao_fifo = 0,
-	 .fifo_size = 1024,
-	 .ranges = &cb_pcidas_ranges,
-	 .trimpot = AD7376,
-	 .has_dac08 = 0,
-	 .is_1602 = 0,
-	 },
-	{
-	 .name = "pci-das1001",
-	 .device_id = 0x1a,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 12,
-	 .ai_speed = 6800,
-	 .ao_nchan = 2,
-	 .has_ao_fifo = 0,
-	 .fifo_size = 1024,
-	 .ranges = &cb_pcidas_alt_ranges,
-	 .trimpot = AD7376,
-	 .has_dac08 = 0,
-	 .is_1602 = 0,
-	 },
-	{
-	 .name = "pci-das1002",
-	 .device_id = 0x1b,
-	 .ai_se_chans = 16,
-	 .ai_diff_chans = 8,
-	 .ai_bits = 12,
-	 .ai_speed = 6800,
-	 .ao_nchan = 2,
-	 .has_ao_fifo = 0,
-	 .fifo_size = 1024,
-	 .ranges = &cb_pcidas_ranges,
-	 .trimpot = AD7376,
-	 .has_dac08 = 0,
-	 .is_1602 = 0,
-	 },
+		.name		= "pci-das1602/16",
+		.device_id	= 0x1,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 16,
+		.ai_speed	= 5000,
+		.ao_nchan	= 2,
+		.has_ao_fifo	= 1,
+		.ao_scan_speed	= 10000,
+		.fifo_size	= 512,
+		.ranges		= &cb_pcidas_ranges,
+		.trimpot	= AD8402,
+		.has_dac08	= 1,
+		.is_1602	= 1,
+	}, {
+		.name		= "pci-das1200",
+		.device_id	= 0xF,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 12,
+		.ai_speed	= 3200,
+		.ao_nchan	= 2,
+		.has_ao_fifo	= 0,
+		.fifo_size	= 1024,
+		.ranges		= &cb_pcidas_ranges,
+		.trimpot	= AD7376,
+		.has_dac08	= 0,
+		.is_1602	= 0,
+	}, {
+		.name		= "pci-das1602/12",
+		.device_id	= 0x10,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 12,
+		.ai_speed	= 3200,
+		.ao_nchan	= 2,
+		.has_ao_fifo	= 1,
+		.ao_scan_speed	= 4000,
+		.fifo_size	= 1024,
+		.ranges		= &cb_pcidas_ranges,
+		.trimpot	= AD7376,
+		.has_dac08	= 0,
+		.is_1602	= 1,
+	}, {
+		.name		= "pci-das1200/jr",
+		.device_id	= 0x19,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 12,
+		.ai_speed	= 3200,
+		.ao_nchan	= 0,
+		.has_ao_fifo	= 0,
+		.fifo_size	= 1024,
+		.ranges		= &cb_pcidas_ranges,
+		.trimpot	= AD7376,
+		.has_dac08	= 0,
+		.is_1602	= 0,
+	}, {
+		.name		= "pci-das1602/16/jr",
+		.device_id	= 0x1C,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 16,
+		.ai_speed	= 5000,
+		.ao_nchan	= 0,
+		.has_ao_fifo	= 0,
+		.fifo_size	= 512,
+		.ranges		= &cb_pcidas_ranges,
+		.trimpot	= AD8402,
+		.has_dac08	= 1,
+		.is_1602	= 1,
+	}, {
+		.name		= "pci-das1000",
+		.device_id	= 0x4C,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 12,
+		.ai_speed	= 4000,
+		.ao_nchan	= 0,
+		.has_ao_fifo	= 0,
+		.fifo_size	= 1024,
+		.ranges		= &cb_pcidas_ranges,
+		.trimpot	= AD7376,
+		.has_dac08	= 0,
+		.is_1602	= 0,
+	}, {
+		.name		= "pci-das1001",
+		.device_id	= 0x1a,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 12,
+		.ai_speed	= 6800,
+		.ao_nchan	= 2,
+		.has_ao_fifo	= 0,
+		.fifo_size	= 1024,
+		.ranges		= &cb_pcidas_alt_ranges,
+		.trimpot	= AD7376,
+		.has_dac08	= 0,
+		.is_1602	= 0,
+	}, {
+		.name		= "pci-das1002",
+		.device_id	= 0x1b,
+		.ai_se_chans	= 16,
+		.ai_diff_chans	= 8,
+		.ai_bits	= 12,
+		.ai_speed	= 6800,
+		.ao_nchan	= 2,
+		.has_ao_fifo	= 0,
+		.fifo_size	= 1024,
+		.ranges		= &cb_pcidas_ranges,
+		.trimpot	= AD7376,
+		.has_dac08	= 0,
+		.is_1602	= 0,
+	},
 };
 
 /* this structure is for data unique to this hardware driver.  If
-- 
1.7.11

