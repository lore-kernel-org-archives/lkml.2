Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab0KGMj4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:39:56 -0500
Received: from 1wt.eu ([62.212.114.60]:47158 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab0KGMjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:39:55 -0500
Date: Sun, 7 Nov 2010 13:39:01 +0100
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
Message-ID: <20101107123901.GZ4627@1wt.eu>
References: <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu> <20101107094932.GT4627@1wt.eu> <20101107112709.GA2634@elte.hu> <20101107114156.GV4627@1wt.eu> <20101107114756.GB3759@elte.hu> <20101107115626.GX4627@1wt.eu> <20101107121235.GA6221@elte.hu> <20101107122227.GY4627@1wt.eu> <20101107122533.GA6512@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107122533.GA6512@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 01:25:33PM +0100, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > > Why are you putting words in my mouth?
> > 
> > I'm not putting anything in your mouth Ingo :-)
> 
> To quote you:
> 
>   " you're making a special case of the security bug that you want to hide bugs from
>     user-space by cheating on version. "
> 
> No, i did not say that i want to hide bugs from user-space by cheating on the 
> version. Why are you claiming that i said that? Why are you putting words in my 
> mouth?

I'm not claiming that "you said that", it's my interpretation of what
you're trying to achieve with what you're defending. I'm free to interprete
as I want. Probably it's a very synthetical analysis, but it's my analysis.

Willy

