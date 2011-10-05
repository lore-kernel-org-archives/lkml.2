Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1JEGxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 02:53:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1JEGxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 02:53:53 -0400
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: Eric Dumazet <eric.dumazet@gmail.com>
To: starlight@binnacle.cx
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>
In-Reply-To: <6.2.5.6.2.20111003140010.05a70ed0@binnacle.cx>
References: <6.2.5.6.2.20111003140010.05a70ed0@binnacle.cx>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 08:53:47 +0200
Message-ID: <1317797627.3099.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 octobre 2011 à 14:02 -0400, starlight@binnacle.cx a écrit :
> At 06:16 PM 10/3/2011 +0200, Eric Dumazet wrote:
> >
> >It seems you use 4096 2MB hugepages, and your
> >machine has 1GB pages availabe, you could
> >try to use them.
> >
> >(boot cmd : hugepagesz=1GB hugepages=8 )
> 
> Tried it and got errno 12 on the segment
> allocations.  None were allocated, though
> the count is six and the largest is exactly
> 1GB.  Don't have time to dig into it.
> 

Thats pretty normal ;)

With 2MB pages, your segment size must be a 2MB multiple.

With 1GB pages, your segment size must be a .... 1GB multiple.

So only applicable is say you handle one big 8GB segment for example, or
2 4GB segments... Well you see the picture.




