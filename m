Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2BRGvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 01:51:15 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57466 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2BRGvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 01:51:14 -0500
Date: Sat, 18 Feb 2012 01:50:59 -0500 (EST)
Message-Id: <20120218.015059.195369430178043130.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: benve@cisco.com, dkukawka@suse.de, roprabhu@cisco.com, dwang2@cisco.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] cisco/enic: use eth_hw_addr_random() instead of
 random_ether_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329516810-26175-1-git-send-email-danny.kukawka@bisect.de>
References: <1329516810-26175-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 22:51:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 23:13:30 +0100

> Use dev_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Reset the state to NET_ADDR_PERM as soon as the MAC get
> changed via .ndo_set_mac_address.
> 
> v3: adapt to net-next
> v2: use bitops, adapt to eth_hw_addr_random(), add a comment
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, thanks.
