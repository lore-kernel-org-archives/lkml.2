Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0ISTgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 15:36:12 -0400
Received: from mailhub.stratus.com ([134.111.1.18]:50678 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0ISTgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 15:36:10 -0400
Date: Sun, 19 Sep 2010 15:36:01 -0400
From: Bandan Das <bandan.das@stratus.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, bandan.das@stratus.com, bunk@kernel.org,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
Message-ID: <20100919193601.GG31036@stratus.com>
References: <20100903044941.GA28300@gondor.apana.org.au>
 <20100915173209.GB9086@stratus.com>
 <20100917065117.GA9577@gondor.apana.org.au>
 <20100917.164356.22528384.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917.164356.22528384.davem@davemloft.net>
Company: Stratus Technologies
X-Disclaimer: This email will auto delete in 5 days, nah.. I am kidding!
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 19 Sep 2010 19:36:02.0114 (UTC) FILETIME=[E48AE220:01CB5831]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  0, David Miller <davem@davemloft.net> wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Fri, 17 Sep 2010 14:51:17 +0800
> 
> > On Wed, Sep 15, 2010 at 01:32:09PM -0400, Bandan Das wrote:
> >>
> >> Sorry for the late response. Here's a patch that I put up based on Herbert's
> >> suggestions. I ofcourse don't see the problem anymore after 
> >> commit 87f94b4e91dc042620c527f3c30c37e5127ef757 but a generic helper such as this 
> >> can be used anytime the bridge code is sending a packet over to the IP layer. 
> >> Compile tested only but based on responses, will test it before submitting a 
> >> final change. Also added it at two places where I know we do send a packet over to
> >> the IP layer. I will add it at other places later as I come across them.
> > 
> > Looks fine to me.
> 
> Bandan, please submit this formally with proper commit message,
> signoff, also the new function you added needs a minor coding
> style fix, there needs to be a space after "if" and the openning
> left parenthesis.
> 
> Thanks.

Submitted. And also incorporated the coding style fixes you mentioned.

Thanks
Bandan
