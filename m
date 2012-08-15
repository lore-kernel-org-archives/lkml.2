Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2HOBYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:24:52 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:8130 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2HOBYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:24:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1344993890!7536807!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] staging: comedi: dnya_pci10xx: remove unused fields in the boardinfo
Date: Tue, 14 Aug 2012 18:24:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141824.48083.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_bits information in the boardinfo is not used by the driver.
Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index abfbb12..80bfae5 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -58,13 +58,9 @@ struct boardtype {
 	const char *name;
 	int device_id;
 	int ai_chans;
-	int ai_bits;
 	int ao_chans;
-	int ao_bits;
 	int di_chans;
-	int di_bits;
 	int do_chans;
-	int do_bits;
 	const struct comedi_lrange *range_ai;
 	const char *range_codes_ai;
 };
@@ -74,13 +70,9 @@ static const struct boardtype boardtypes[] = {
 	.name = "dyna_pci1050",
 	.device_id = 0x1050,
 	.ai_chans = 16,
-	.ai_bits = 12,
 	.ao_chans = 16,
-	.ao_bits = 12,
 	.di_chans = 16,
-	.di_bits = 16,
 	.do_chans = 16,
-	.do_bits = 16,
 	.range_ai = &range_pci1050_ai,
 	.range_codes_ai = range_codes_pci1050_ai,
 	},
-- 
1.7.11

