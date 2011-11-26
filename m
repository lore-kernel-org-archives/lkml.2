Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1KZUuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 15:50:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39695 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab1KZUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 15:50:37 -0500
Date: Sat, 26 Nov 2011 15:50:28 -0500 (EST)
Message-Id: <20111126.155028.1986754382924402334.davem@davemloft.net>
To: swhiteho@redhat.com
Cc: eric.dumazet@gmail.com, levinsasha928@gmail.com, mpm@selenic.com,
        cl@linux-foundation.org, penberg@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ccaulfie@redhat.com
Subject: Re: [BUG] 3.2-rc2: BUG kmalloc-8: Redzone overwritten
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321873110.2710.13.camel@menhir>
References: <1321870529.2552.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1321870915.2552.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1321873110.2710.13.camel@menhir>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 Nov 2011 12:50:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 21 Nov 2011 10:58:30 +0000

> I have to say that I've been wondering lately whether it has got to the
> point where it is no longer useful. Has anybody actually tested it
> lately against "real" DEC implementations?

I doubt it :-)

If we can't think of any real reason to keep it around, let's try
to reach a quirk consensus and I'll toss it from the net-next tree.

Thanks.
