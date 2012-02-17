Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2BQU7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:59:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54662 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2BQU7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:59:41 -0500
Date: Fri, 17 Feb 2012 15:59:30 -0500 (EST)
Message-Id: <20120217.155930.1401463574783963868.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, jeffrey.t.kirsher@intel.com, jpirko@redhat.com,
        mcuos.com@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] au1000_eth: use eth_hw_addr_random() instead
 of random_ether_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329493411-25750-2-git-send-email-danny.kukawka@bisect.de>
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de>
	<1329493411-25750-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 17 Feb 2012 12:59:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Fri, 17 Feb 2012 16:43:22 +0100

> Use eth_hw_addr_random() instead of calling random_ether_addr()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> v2: adapt to eth_hw_addr_random()
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Please don't shit up the comments:

> -	/* set a random MAC now in case platform_data doesn't provide one */
 ...
> +			/*set a random MAC since no valid provided by platform_data*/

You had to work to make that comment look worse than it originally
did in the code, spaces around the sentence and if you can be so
bothered capitalize sentences and put proper punctionation at the
end.

I took care of this, but I will not next time.
