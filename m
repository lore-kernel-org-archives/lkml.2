Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0INC22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:28:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33217 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab0INC20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:28:26 -0400
Date: Tue, 14 Sep 2010 12:28:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        Mihai =?UTF-8?B?RG9u?= =?UTF-8?B?yJt1?= <mihai.dontu@gmail.com>
Subject: linux-next: manual merge of the usb tree with the trivial tree
Message-Id: <20100914122824.9a6f9d8c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/gadget/rndis.c between commit
7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
unnecessary return's from void functions") from the trivial tree and
commit c8feb3bad134f927a624cc19da13f57627b905e2 ("USB: gadget: rndis: fix
up coding style issues in the file") from the usb tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/rndis.c
index 33a9475,6a7dd91..0000000
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@@ -914,12 -912,14 +912,12 @@@ int rndis_register(void (*resp_avail)(v
  	return -ENODEV;
  }
  
- void rndis_deregister (int configNr)
+ void rndis_deregister(int configNr)
  {
- 	pr_debug("%s: \n", __func__);
+ 	pr_debug("%s:\n", __func__);
  
  	if (configNr >= RNDIS_MAX_CONFIGS) return;
- 	rndis_per_dev_params [configNr].used = 0;
+ 	rndis_per_dev_params[configNr].used = 0;
 -
 -	return;
  }
  
  int rndis_set_param_dev(u8 configNr, struct net_device *dev, u16 *cdc_filter)
