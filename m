Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1AFVYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:24:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1AFVY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:24:29 -0500
MIME-Version: 1.0
In-Reply-To: <20110106211645.GA26184@gondor.apana.org.au>
References: <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au>
 <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au>
 <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
 <20110106211645.GA26184@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 13:23:19 -0800
Message-ID: <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
Subject: Re: Crypto Update for 2.6.38
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 1:16 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> On Thu, Jan 06, 2011 at 10:05:46AM -0800, Linus Torvalds wrote:
>>
>> Is there really any point to this? And can we get more explanation of
>> what the interface is, and who would use it?
>
> I think you've answered it yourself in the third paragraph :)

No I didn't.

What part of "can we get more explanation of what the interface is" is unclear?

Explanations of interface. Code. Who uses it? What are the actual
performance benefits on real code?

Quite frankly, asynchronous external devices using DMA or similar are
seldom real performance improvements. The bus and cache traffic tends
to overwhelm any other advantage, and commonly the result is (a) lower
performance with (b) better-looking profiles.

But "better-looking profiles" isn't actually a real advantage.

And I really do want to hear about new kernel interfaces. What _are_
the interfaces, and what are the advantages to them.

                     Linus
