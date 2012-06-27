Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2F0BEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:04:39 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:39406 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F0BEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:04:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1340759076!5250913!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/36] staging: comedi: cb_pcidas: fix a space before tab issue
Date: Tue, 26 Jun 2012 18:04:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261804.26801.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by checkpatch.pl, spaces should not be used before
tabs.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index a033071..ff08f9e 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1063,7 +1063,7 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	else if (cmd->start_src == TRIG_EXT) {
 		bits |= EXT_TRIGGER | TGEN | XTRCL;
 		if (thisboard->is_1602) {
-		    	if (cmd->start_arg & CR_INVERT)
+			if (cmd->start_arg & CR_INVERT)
 				bits |= TGPOL;
 			if (cmd->start_arg & CR_EDGE)
 				bits |= TGSEL;
-- 
1.7.11

