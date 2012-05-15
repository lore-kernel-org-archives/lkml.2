Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966163Ab2EOSPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:15:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40817 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964860Ab2EOSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:15:38 -0400
Date: Tue, 15 May 2012 14:14:23 -0400 (EDT)
Message-Id: <20120515.141423.885518974251878746.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-wireless@vger.kernel.org,
        dev@openvswitch.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] net: Use net_<level>_ratelimit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337104765.7050.24.camel@joe2Laptop>
References: <cover.1336981915.git.joe@perches.com>
	<20120515.134531.530903973750646107.davem@davemloft.net>
	<1337104765.7050.24.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 11:14:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 15 May 2012 10:59:25 -0700

> I could produce a net_printk_ratelimited that would keep
> the original behavior if necessary.
> 
> 	net_printk_ratelimited(KERN_DEBUG etc...)

I don't think it's worth the hassle, we'd rather get people
into the habit of using dynamic_debug.
