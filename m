Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab1GGF3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 01:29:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35448 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1GGF3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 01:29:04 -0400
Date: Thu, 7 Jul 2011 15:28:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the staging tree with the net tree
Message-Id: <20110707152857.83d48e1d1c175f811b255952@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c between commit
219eb47e6f35 ("net/staging: add needed interrupt.h and hardirq.h
includes") from the net tree and commit 41134db17a7d ("Remove unneeded
version.h includes from drivers/staging/rtl*/") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 00ee02f,52a7386..0000000
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@@ -19,8 -19,6 +19,7 @@@
  #include <linux/random.h>
  #include <linux/delay.h>
  #include <linux/slab.h>
- #include <linux/version.h>
 +#include <linux/interrupt.h>
  #include <asm/uaccess.h>
  
  #include "dot11d.h"
