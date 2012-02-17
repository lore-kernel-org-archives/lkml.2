Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2BQVDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:03:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54781 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab2BQVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:03:46 -0500
Date: Fri, 17 Feb 2012 16:00:16 -0500 (EST)
Message-Id: <20120217.160016.2282514497251202216.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, richard.cochran@omicron.at, julia@diku.dk,
        s.hauer@pengutronix.de, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] davinci_emac: use eth_hw_addr_random()
 instead of random_ether_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-4-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-4-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:00:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:24 +0100

> Use eth_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> Remove one memcpy from emac_dev_setmac_addr() since this is a
> duplicate: it's already done some lines above.
> 
> v2: use bitops, adapt to eth_hw_addr_random, remove a memcpy
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
