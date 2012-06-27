Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2F0A6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:58:34 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:48482 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2F0A6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:58:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1340758713!6924646!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/36] staging: comedi: cb_pcidas: cleanup the boardinfo 2
Date: Tue, 26 Jun 2012 17:58:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261758.27849.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the boardinfo values that are = 0. They will
default to that value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index a5b3659..f7090de 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -277,12 +277,9 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
 		.ao_nchan	= 2,
-		.has_ao_fifo	= 0,
 		.fifo_size	= 1024,
 		.ranges		= &cb_pcidas_ranges,
 		.trimpot	= AD7376,
-		.has_dac08	= 0,
-		.is_1602	= 0,
 	}, {
 		.name		= "pci-das1602/12",
 		.device_id	= 0x10,
@@ -296,7 +293,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.fifo_size	= 1024,
 		.ranges		= &cb_pcidas_ranges,
 		.trimpot	= AD7376,
-		.has_dac08	= 0,
 		.is_1602	= 1,
 	}, {
 		.name		= "pci-das1200/jr",
@@ -305,13 +301,9 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 3200,
-		.ao_nchan	= 0,
-		.has_ao_fifo	= 0,
 		.fifo_size	= 1024,
 		.ranges		= &cb_pcidas_ranges,
 		.trimpot	= AD7376,
-		.has_dac08	= 0,
-		.is_1602	= 0,
 	}, {
 		.name		= "pci-das1602/16/jr",
 		.device_id	= 0x1C,
@@ -319,8 +311,6 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.ai_diff_chans	= 8,
 		.ai_bits	= 16,
 		.ai_speed	= 5000,
-		.ao_nchan	= 0,
-		.has_ao_fifo	= 0,
 		.fifo_size	= 512,
 		.ranges		= &cb_pcidas_ranges,
 		.trimpot	= AD8402,
@@ -333,13 +323,9 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.ai_diff_chans	= 8,
 		.ai_bits	= 12,
 		.ai_speed	= 4000,
-		.ao_nchan	= 0,
-		.has_ao_fifo	= 0,
 		.fifo_size	= 1024,
 		.ranges		= &cb_pcidas_ranges,
 		.trimpot	= AD7376,
-		.has_dac08	= 0,
-		.is_1602	= 0,
 	}, {
 		.name		= "pci-das1001",
 		.device_id	= 0x1a,
@@ -348,12 +334,9 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.ai_bits	= 12,
 		.ai_speed	= 6800,
 		.ao_nchan	= 2,
-		.has_ao_fifo	= 0,
 		.fifo_size	= 1024,
 		.ranges		= &cb_pcidas_alt_ranges,
 		.trimpot	= AD7376,
-		.has_dac08	= 0,
-		.is_1602	= 0,
 	}, {
 		.name		= "pci-das1002",
 		.device_id	= 0x1b,
@@ -362,12 +345,9 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 		.ai_bits	= 12,
 		.ai_speed	= 6800,
 		.ao_nchan	= 2,
-		.has_ao_fifo	= 0,
 		.fifo_size	= 1024,
 		.ranges		= &cb_pcidas_ranges,
 		.trimpot	= AD7376,
-		.has_dac08	= 0,
-		.is_1602	= 0,
 	},
 };
 
-- 
1.7.11

