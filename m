Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab1ESRLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:11:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46236 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESRLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RQPrRK044uPgdKgC4wqhOAggCzm2PAGFLFh2XryWLj0gk8BjKxza3XP2dALuoLWdmC
         60sW31bgVsV5E5PmBKeRh+BLhl0jIUEdIx9ol1l+RA6H3x7JvLj4q76vmSZCJHbtxXyU
         NTuBjl3XZnXWXgQK19PnGQQyzR+qH2+SGRDTQ=
Subject: Re: kernel BUG at net/ipv4/tcp_output.c:1006!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: TB <lkml@techboom.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4DD54E89.7050707@techboom.com>
References: <1305307633.3866.61.camel@edumazet-laptop>
	 <4DCD86C0.9030904@techboom.com>	<1305316058.3120.6.camel@edumazet-laptop>
	 <20110513.160138.1477780250019480052.davem@davemloft.net>
	 <4DD54E89.7050707@techboom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 19:11:26 +0200
Message-ID: <1305825086.3028.84.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 19 mai 2011 à 13:08 -0400, TB a écrit :
> On 11-05-13 04:01 PM, David Miller wrote:
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Fri, 13 May 2011 21:47:38 +0200
> > 
> >> I suspect we should push commit 2fceec13375e5d98 (tcp: len check is
> >> unnecessarily devastating, change to WARN_ON) to stable if not already
> >> done...
> >>
> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2fceec13375e5d98
> >>
> >> David, is this commit in your stable queue ?
> > 
> > No, but now it is.
> 
> We've put this commit with the previous tcp_cubic patch on 60 of our
> servers and we're waiting to see how it goes.

Dont expect too much. It only permits to survive after logging messages,
instead of halting machine ;)



