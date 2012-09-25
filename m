Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab2IYFNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:13:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57723 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IYFNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:13:47 -0400
Date: Tue, 25 Sep 2012 01:13:43 -0400 (EDT)
Message-Id: <20120925.011343.1495275645575636949.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348549842.26828.1897.camel@edumazet-glaptop>
References: <20120925123438.bbf3126889513ee5cc195e5c@canb.auug.org.au>
	<1348549842.26828.1897.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 25 Sep 2012 07:10:42 +0200

> Oops, my bad, net/ipv4/raw.c changes in 5640f7685831 ("net: use a per
> task frag allocator") should not be there :
> 
> I accidentally left a debugging version of the patch I sent to fix the
> icmp bug.
> 
> Sorry David for this, I am not sure how I can help on this ?

The thing to do is send me a patch to revert the raw.c change from
net-next, right?
