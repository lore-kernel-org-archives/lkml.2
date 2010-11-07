Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0KGM4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:56:32 -0500
Received: from 1wt.eu ([62.212.114.60]:47180 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0KGM4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:56:30 -0500
Date: Sun, 7 Nov 2010 13:55:31 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101107125531.GB4627@1wt.eu>
References: <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu> <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu> <20101107094932.GT4627@1wt.eu> <20101107114237.GA3759@elte.hu> <20101107115145.GW4627@1wt.eu> <20101107123746.GA5413@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107123746.GA5413@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 01:37:46PM +0100, Ingo Molnar wrote:
> > [...] There's no need for that, what you want is to hide kernel pointers, [...]
> 
> That's a new claim from you - and when put like that it's wrong too:

It's where the discussion started and it's still in the subject of the thread !
You noted that with distro kernels, hiding kallsyms is useless since uname -r
reveals what kernel to download to get them anyway. Which is true !

Reason why it would be more efficient to find how we could randomize those
pointers at runtime.

(...)
> Anyway, i wasnt particularly successful in conveying my past arguments to you so i'd 
> rather leave the discussion at this point. You made your points and i made my points 
> as well.

That's also what I was about to say. Let's agree we disagree and have a
nice sunday afternoon. We can bring the discussion back around a beer if
you happen to pass by Paris :-)

Cheers,
Willy

