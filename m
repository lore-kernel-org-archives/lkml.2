Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3AFTji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 14:39:38 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56193 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3AFTjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 14:39:36 -0500
Subject: Re: Major network performance regression in 3.7
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130106193410.GL16031@1wt.eu>
References: <1357484342.6919.61.camel@edumazet-glaptop>
	 <20130106155123.GB16031@1wt.eu>
	 <1357490393.6919.267.camel@edumazet-glaptop>
	 <20130106164416.GF16031@1wt.eu>
	 <1357492255.6919.336.camel@edumazet-glaptop>
	 <20130106173543.GB22432@1wt.eu>
	 <1357497541.6919.519.camel@edumazet-glaptop>
	 <1357497809.6919.529.camel@edumazet-glaptop>
	 <1357498276.6919.547.camel@edumazet-glaptop>
	 <1357498815.6919.570.camel@edumazet-glaptop>
	 <20130106193410.GL16031@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jan 2013 11:39:31 -0800
Message-ID: <1357501171.6919.650.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-06 at 20:34 +0100, Willy Tarreau wrote:

> OK it works like a charm here now ! I can't break it anymore, so it
> looks like you finally got it !
> 
> I noticed that the data rate was higher when the loopback's MTU
> is exactly a multiple of 4096 (making the 64k choice optimal)
> while I would have assumed that in order to efficiently splice
> TCP segments, we'd need to have some space for IP/TCP headers
> and n*4k for the payload.
> 
> I also got the transfer freezes again a few times when starting
> tcpdump on the server, but this is not 100% reproducible I'm afraid.
> So I'll bring this back when I manage to get some analysable pattern.
> 
> The spliced transfer through all the chain haproxy works fine again
> at 10gig with your fix. The issue is closed for me. Feel free to add
> my Tested-By if you want.
> 

Good to know !

What is the max speed you get now ?


