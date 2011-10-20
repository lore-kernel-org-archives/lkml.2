Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1JTUVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 16:21:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43290 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1JTUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 16:21:13 -0400
Date: Thu, 20 Oct 2011 16:21:00 -0400 (EDT)
Message-Id: <20111020.162100.936624966779816387.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: eric.dumazet@gmail.com, evonlanthen@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        timo.teras@iki.fi
Subject: Re: PROBLEM: System call 'sendmsg' of process ospfd (quagga)
 causes kernel oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111020093541.GA3024@gondor.apana.org.au>
References: <20111019080807.GA25099@gondor.apana.org.au>
	<20111020.053050.383972361986316046.davem@davemloft.net>
	<20111020093541.GA3024@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 13:21:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.hengli.com.au>
Date: Thu, 20 Oct 2011 11:35:41 +0200

> On Thu, Oct 20, 2011 at 05:30:50AM -0400, David Miller wrote:
>>
>> So I'm a little confused what your suggestion for rc10 really
>> is :-)
> 
> I meant his first initial patch :)
> 
> While it is suboptimal in the sense that should the value of
> needed_headroom increase we'll end up constantly reallocating
> skbs, I believe that it is at least semantically correct.

Ok, I applied Eric's patch which removes the dynamic changing of the
needed_headroom in IP_GRE.

Thanks everyone!
