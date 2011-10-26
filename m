Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1JZDNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 23:13:05 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60921 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1JZDND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 23:13:03 -0400
Date: Tue, 25 Oct 2011 23:12:04 -0400 (EDT)
Message-Id: <20111025.231204.257472162924919077.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: eric.dumazet@gmail.com, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
 causes kernel oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111025115425.GA1530@gondor.apana.org.au>
References: <20111020.053050.383972361986316046.davem@davemloft.net>
	<20111020093541.GA3024@gondor.apana.org.au>
	<20111025115425.GA1530@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 25 Oct 2011 20:12:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Tue, 25 Oct 2011 13:54:25 +0200

> So I'm going to get rid of LL_ALLOCATED_SPACE completely and
> replace it with explicit references to the tailroom as it doesn't
> need the alignment anyway (The headroom needs alignment since
> we use it to ensure the head is aligned).

Ok.
