Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0CZVlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:41:07 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48394 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0CZVlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NT4ip7WQuv8ehW0JuXYFZCFmPdBWSFAhbzmDbg01cjiO7xVm3ak3XTB9tB60H45H8G
         F44ydWfx8YD2v+MY/k//abJC6O4Y+ekc6VoNPlVhzXKxObX0Iw8sXHZNWGuS/RkG4To6
         ekz9KynRNDEjrU3rQAJ6v2om/nI0V+YcDZOjs=
Date: Fri, 26 Mar 2010 22:41:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [BUG] perf: hard lockup when using perf-sched
Message-ID: <20100326214101.GE7166@nowhere>
References: <4BA9A885.9050105@cn.fujitsu.com> <1269415964.6530.25.camel@marge.simson.net> <1269418671.6465.6.camel@marge.simson.net> <4BAB1924.4060304@cn.fujitsu.com> <1269509241.8438.30.camel@marge.simson.net> <1269598293.6174.8.camel@marge.simson.net> <20100326172350.GC5188@nowhere> <1269630640.6331.18.camel@marge.simson.net> <20100326192712.GA7166@nowhere> <1269634924.6488.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269634924.6488.6.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 09:22:04PM +0100, Mike Galbraith wrote:
> Hm.  Last trace I took is below.
> 
> ./forkbomb&


Hmm, Yeah that's indeed what the traces show.
And your patch really fix this on your box?

