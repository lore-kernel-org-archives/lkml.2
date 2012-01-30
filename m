Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab2A3DAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:00:09 -0500
Received: from cronus.persephoneslair.org ([216.254.15.24]:40132 "EHLO
	cronus.persephoneslair.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096Ab2A3DAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:00:07 -0500
Date: Sun, 29 Jan 2012 18:59:35 -0800
From: Andrea Shepard <andrea@persephoneslair.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: khc@pm.waw.pl, davem@davemloft.net, mmarek@suse.cz, jkosina@suse.cz,
        joe@perches.com, justinmattock@gmail.com, gregkh@suse.de,
        alan@linux.intel.com, jdmason@kudzu.us
Subject: [20/22] Cyclades PC300 driver: add version history for this patch series
Message-ID: <20120130025935.GU10262@cronus.persephoneslair.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comment describing this patch series to the history in pc300_drv.c.

Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index 5e50907..bcdf53a 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -17,6 +17,9 @@ static const char rcsid[] =
  *	
  *	Using tabstop = 4.
  *
+ * Cyclades version 4.1.0 merged in, with new portability fixes,
+ * and ported to recent kernels by Andrea Shepard <andrea@persephoneslair.org>
+ *
  * Due to changes in certain ioctls necessary for portability, this
  * version requires a new version of pc300utils, which may be found
  * at: http://charon.persephoneslair.org/~andrea/software/pc300utils/
