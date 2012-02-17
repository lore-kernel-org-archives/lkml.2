Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2BQVDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:03:40 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54774 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab2BQVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:03:38 -0500
Date: Fri, 17 Feb 2012 16:00:56 -0500 (EST)
Message-Id: <20120217.160056.468165222350582907.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, sfr@canb.auug.org.au, ricardo.ribalda@gmail.com,
        thomas@m3y3r.de, richard.cochran@omicron.at, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/10] xilinx ll_temac: use eth_hw_addr_random()
 instead of random_ether_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-5-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-5-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:00:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:25 +0100

> Use eth_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v2: reworked to prevent using an extra variable
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, but:

> +	else 

Trailing whitespace.  This isn't something you need to be a rocket
scientist to catch, the tools find it for you, as they did for me.
