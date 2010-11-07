Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0KGMWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:22:49 -0500
Received: from 1wt.eu ([62.212.114.60]:47147 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab0KGMWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:22:48 -0500
Date: Sun, 7 Nov 2010 13:22:27 +0100
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
Message-ID: <20101107122227.GY4627@1wt.eu>
References: <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu> <20101104223526.GC31236@1wt.eu> <20101107085016.GA23843@elte.hu> <20101107094932.GT4627@1wt.eu> <20101107112709.GA2634@elte.hu> <20101107114156.GV4627@1wt.eu> <20101107114756.GB3759@elte.hu> <20101107115626.GX4627@1wt.eu> <20101107121235.GA6221@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107121235.GA6221@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 01:12:35PM +0100, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > [...]
> >
> > It's precisely because you're making a special case of the security bug that you 
> > want to hide bugs from user-space by cheating on version.
> 
> You claimed this for the second time and i'm denying it for the second time.
> 
> The goal of fuzzing the version inforation is _not_ to 'hide bugs from user-space by 
> cheating on version'. The goal is to introduce uncertainty to attackers, so that a 
> honeypot silent alarm can warn the admin.

My interpretation of this mechanism is what I explained above. "Introducing
uncertainty" means hiding a version so that the attacker doesn't precisely
know which one it is and has to send a few probes to guess it. That's not
much different than trying to fire the exploit itself. When you run a
null-deref kernel exploit, better be sure of what you're doing, otherwise
the admin will shortly be aware of it too.

You could as well consider that launching some commands is suspicious
(eg: uname). You'll obviously get a lot of false-positive alarms from
all autoconf scripts run in local, but this gives an idea. Anyway, when
local users have their time (eg: students), it's still easy to guess the
version.

> Why are you putting words in my mouth?

I'm not putting anything in your mouth Ingo :-)

Willy

