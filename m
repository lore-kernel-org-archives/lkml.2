Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1GGFoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:44:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48098 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1GGFoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:44:21 -0400
Date: Thu, 7 Jul 2011 15:44:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>
Subject: linux-next: manual merge of the staging tree with the net tree
Message-Id: <20110707154418.2ef06852c79eb96adcbe8c4e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/rtl8192e/r8192E.h between commit 219eb47e6f35
("net/staging: add needed interrupt.h and hardirq.h includes") from the
net tree and commit 41134db17a7d ("Remove unneeded version.h includes
from drivers/staging/rtl*/") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/rtl8192e/r8192E.h
index 89fe8fc,0faa637..0000000
--- a/drivers/staging/rtl8192e/r8192E.h
+++ b/drivers/staging/rtl8192e/r8192E.h
@@@ -35,8 -35,6 +35,7 @@@
  #include <linux/proc_fs.h>	// Necessary because we use the proc fs
  #include <linux/if_arp.h>
  #include <linux/random.h>
- #include <linux/version.h>
 +#include <linux/interrupt.h>
  #include <asm/io.h>
  #include "ieee80211/rtl819x_HT.h"
  #include "ieee80211/ieee80211.h"
