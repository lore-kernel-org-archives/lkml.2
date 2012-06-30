Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2F3AmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:42:09 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:43788 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2F3AmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:42:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1341016855!7263834!12
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] staging: comedi: ni_670x: removve unused 'ao_bits'
Date: Fri, 29 Jun 2012 17:41:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291741.48297.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the NI 670x boards have 16-bit anaolog output DACs. The
'ao_bits' in the boardinfo is not used so remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 86e9e70..9c57618 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -64,7 +64,6 @@ struct ni_670x_board {
 	const char *name;
 	unsigned short dev_id;
 	unsigned short ao_chans;
-	unsigned short ao_bits;
 };
 
 static const struct ni_670x_board ni_670x_boards[] = {
@@ -72,17 +71,14 @@ static const struct ni_670x_board ni_670x_boards[] = {
 		.name		= "PCI-6703",
 		.dev_id		= 0x2c90,
 		.ao_chans	= 16,
-		.ao_bits	= 16,
 	}, {
 		.name		= "PXI-6704",
 		.dev_id		= 0x1920,
 		.ao_chans	= 32,
-		.ao_bits	= 16,
 	}, {
 		.name		= "PCI-6704",
 		.dev_id		= 0x1290,
 		.ao_chans	= 32,
-		.ao_bits	= 16,
 	},
 };
 
-- 
1.7.11

