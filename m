Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1KRUCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 15:02:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41553 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1KRUCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 15:02:10 -0500
Date: Fri, 18 Nov 2011 15:01:57 -0500 (EST)
Message-Id: <20111118.150157.1046683437153798989.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: eric.dumazet@gmail.com, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: [0/6] Replace LL_ALLOCATED_SPACE to allow needed_headroom
 adjustment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111118121832.GA2868@gondor.apana.org.au>
References: <20111025115425.GA1530@gondor.apana.org.au>
	<20111025.231204.257472162924919077.davem@davemloft.net>
	<20111118121832.GA2868@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 18 Nov 2011 12:02:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Fri, 18 Nov 2011 20:18:32 +0800

> On Tue, Oct 25, 2011 at 11:12:04PM -0400, David Miller wrote:
>> From: Herbert Xu <herbert@gondor.hengli.com.au>
>> Date: Tue, 25 Oct 2011 13:54:25 +0200
>> 
>> > So I'm going to get rid of LL_ALLOCATED_SPACE completely and
>> > replace it with explicit references to the tailroom as it doesn't
>> > need the alignment anyway (The headroom needs alignment since
>> > we use it to ensure the head is aligned).
>> 
>> Ok.
> 
> Here are the patches that do this.  I also picked up one spot
> that should have used LL_ALLOCATED_SPACE but did not (see 2nd
> last patch).

This all looks good to me, applied to net-next, thanks!
