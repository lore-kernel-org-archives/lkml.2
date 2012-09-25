Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2IYFKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:10:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63047 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2IYFKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:10:46 -0400
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
In-Reply-To: <20120925123438.bbf3126889513ee5cc195e5c@canb.auug.org.au>
References: <20120925123438.bbf3126889513ee5cc195e5c@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Sep 2012 07:10:42 +0200
Message-ID: <1348549842.26828.1897.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 12:34 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> net/ipv4/raw.c between commit ab43ed8b7490 ("ipv4: raw: fix icmp_filter
> ()") from the net tree and commit 5640f7685831 ("net: use a per task frag
> allocator") from the net-next tree.
> 
> They are basically the same patch (for this file) except the net-next
> version adds two pr_err() calls. I used the net-next version and can carry
> the fix as necessary (no action is required).
> 
> I do wonder if this change belongs in the net-next patch?

Oops, my bad, net/ipv4/raw.c changes in 5640f7685831 ("net: use a per
task frag allocator") should not be there :

I accidentally left a debugging version of the patch I sent to fix the
icmp bug.

Sorry David for this, I am not sure how I can help on this ?



