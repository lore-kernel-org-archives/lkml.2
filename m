Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2BQVC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:02:28 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54736 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab2BQVC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:02:27 -0500
Date: Fri, 17 Feb 2012 16:01:16 -0500 (EST)
Message-Id: <20120217.160116.2085001213275947134.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: lindner_marek@yahoo.de, dkukawka@suse.de, siwu@hrz.tu-chemnitz.de,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] batman-adv: use eth_hw_addr_random() instead
 of random_ether_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-7-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-7-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:01:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:27 +0100

> Use eth_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Remove dev_addr in interface_setup(), it's not needed anymore.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v2: use bitops, adapt to eth_hw_addr_random()
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
