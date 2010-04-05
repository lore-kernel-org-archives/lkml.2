Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab0DEG5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 02:57:16 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35937 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0DEG5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 02:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MnnRckGo+tX0NJ6xUx3tjXMobMpGJZRyL3iklRZPhkv2vv1fuxqF1ya6w4aPJJ6gt4
         uTC5XOf6MfBi5abKp48c7BtIGhKWIfFTWUimILbddGMPRw7mHJS7X1E2GuiXpY9en+4q
         zPbOVAQ+2TNGvgQgZ68xntriZqhBgCmtYRVyc=
Date: Mon, 5 Apr 2010 08:57:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
	events on sparc 64
Message-ID: <20100405065701.GC5127@nowhere>
References: <20100404121851.GC5177@nowhere> <20100404122113.GD5177@nowhere> <20100404.180057.109331958.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404.180057.109331958.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 06:00:57PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Sun, 4 Apr 2010 14:21:19 +0200
> 
> > Forgot the config, it's in attachment.
> 
> I get them too when even trying to use the function tracer in some
> simple way.  They occur in random places and eventually the entire
> machine wedges and is unusuable.


Yeah. But it's not totally random. I often see the same scheduler
crash.

It seems to happen after an unaligned access fixup.


> 
> I suspect there is some bug that ends up corrupting memory, so I
> started trying to debug this last night when I first saw it.


Ok. I indeed have the same problem with the function tracer when
it is running.

 
> I'll let you know if I make any progress.


Thanks!

