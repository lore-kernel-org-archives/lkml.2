Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2F2SCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:02:13 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:44516 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2F2SCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:02:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-209.messagelabs.com!1340992918!7316566!16
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] staging: comedi: das_08: remove the unneeded 8254 variables and defines
Date: Fri, 29 Jun 2012 11:02:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291102.02483.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the driver is using the 8253 helper functions, remove the
unused variables in the i8254_struct as well as the unused defines
for the 8254 register offsets.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.h b/drivers/staging/comedi/drivers/das08.h
index 0b92f24..ee3cf4b 100644
--- a/drivers/staging/comedi/drivers/das08.h
+++ b/drivers/staging/comedi/drivers/das08.h
@@ -50,17 +50,9 @@ struct das08_board_struct {
 };
 
 struct i8254_struct {
-	int channels;		/*  available channels. Some could be used internally. */
-	int logic2phys[3];	/*  to know which physical channel is. */
-	int mode[3];		/*  the index is the real counter. */
 	unsigned int iobase;
 };
 
-#define I8254_CNT0 0
-#define I8254_CNT1 1
-#define I8254_CNT2 2
-#define I8254_CTRL 3
-
 struct das08_private_struct {
 	unsigned int do_mux_bits;	/*  bits for do/mux register on boards without separate do register */
 	unsigned int do_bits;	/*  bits for do register on boards with register dedicated to digital out only */
-- 
1.7.11

