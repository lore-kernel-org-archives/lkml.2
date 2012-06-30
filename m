Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2F3Akd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:40:33 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:50561 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2F3Akb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:40:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1341016826!23719556!4
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/10] staging: comedi: ni_670x: cleanup the boardinfo
Date: Fri, 29 Jun 2012 17:40:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291740.24270.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, reorder the boardinfo struct so that the
'name' pointer is first. Also, add some whitespace to the boardinfo
to improve readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 34 +++++++++++++++-----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 46f373a..1d3590e 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -61,31 +61,29 @@ Commands are not supported.
 /* Board description*/
 
 struct ni_670x_board {
-	unsigned short dev_id;
 	const char *name;
+	unsigned short dev_id;
 	unsigned short ao_chans;
 	unsigned short ao_bits;
 };
 
 static const struct ni_670x_board ni_670x_boards[] = {
 	{
-	 .dev_id = 0x2c90,
-	 .name = "PCI-6703",
-	 .ao_chans = 16,
-	 .ao_bits = 16,
-	 },
-	{
-	 .dev_id = 0x1920,
-	 .name = "PXI-6704",
-	 .ao_chans = 32,
-	 .ao_bits = 16,
-	 },
-	{
-	 .dev_id = 0x1290,
-	 .name = "PCI-6704",
-	 .ao_chans = 32,
-	 .ao_bits = 16,
-	 },
+		.name		= "PCI-6703",
+		.dev_id		= 0x2c90,
+		.ao_chans	= 16,
+		.ao_bits	= 16,
+	}, {
+		.name		= "PXI-6704",
+		.dev_id		= 0x1920,
+		.ao_chans	= 32,
+		.ao_bits	= 16,
+	}, {
+		.name		= "PCI-6704",
+		.dev_id		= 0x1290,
+		.ao_chans	= 32,
+		.ao_bits	= 16,
+	},
 };
 
 struct ni_670x_private {
-- 
1.7.11

