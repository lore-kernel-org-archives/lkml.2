Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab2EYWvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:51:39 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53645 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab2EYWvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:51:37 -0400
Date: Fri, 25 May 2012 18:51:31 -0400 (EDT)
Message-Id: <20120525.185131.2017517041016424794.davem@davemloft.net>
To: asharma@fb.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: compute a more reasonable default ip6_rt_max_size
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FC0063E.8080209@fb.com>
References: <1337976934-18065-1-git-send-email-asharma@fb.com>
	<1337978820.10135.1.camel@edumazet-glaptop>
	<4FC0063E.8080209@fb.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 25 May 2012 15:51:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Sharma <asharma@fb.com>
Date: Fri, 25 May 2012 15:22:54 -0700

> On 5/25/12 1:47 PM, Eric Dumazet wrote:
>> On Fri, 2012-05-25 at 13:15 -0700, Arun Sharma wrote:
>>> The algorithm is based on ipv4 and alloc_large_system_hash().
>>>
>>
>> Why is it needed at all ?
>>
>> IPv4 has a route cache with potentially millions of entries, not IPv6.
> 
> With the default size of 4096 for the ipv6 routing table, entries can
> get garbage collected and hosts could lose their default route and
> therefore lose connectivity.
> 
> We actually saw it happen.

Under no circumstances should administrator configured ipv6 routes be
garbage collected, that is a bug.
