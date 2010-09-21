Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0IUPuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:50:46 -0400
Received: from stinky.trash.net ([213.144.137.162]:39646 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab0IUPuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:50:44 -0400
Message-ID: <4C98D450.3070601@trash.net>
Date: Tue, 21 Sep 2010 17:50:40 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] netfilter: save the hash of the tuple in the original
 direction for latter use
References: <1284995176-2994-1-git-send-email-xiaosuo@gmail.com>
In-Reply-To: <1284995176-2994-1-git-send-email-xiaosuo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.09.2010 17:06, schrieb Changli Gao:
> Since we don't change the tuple in the original direction, we can save it
> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_confirm()
> use.
> 
> __hash_conntrack() is split into two steps: hash_conntrack_raw() is used
> to get the raw hash, and __hash_bucket() is used to get the bucket id.
> 
> In SYN-flood case, early_drop() doesn't need to recompute the hash again.

Applied, thanks Changli.
