Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2BQVAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:00:23 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54678 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab2BQVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:00:22 -0500
Date: Fri, 17 Feb 2012 16:00:06 -0500 (EST)
Message-Id: <20120217.160006.1000847808550095794.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, blogic@openwrt.org, ralf@linux-mips.org,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] lantiq_etop: set addr_assign_type if
 random_ether_addr() used
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-3-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 13:00:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:23 +0100

> Set addr_assign_type correctly to NET_ADDR_RANDOM in case
> a random MAC address was generated and assigned to the netdevice.
> 
> v2: added comment, renamed bool variable to random_mac
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

More bad comment formatting.

> +	/*set addr_assign_type here, ltq_etop_set_mac_address would reset it*/

Again, I fixed it up but I will not next time.
