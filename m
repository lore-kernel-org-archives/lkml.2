Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1DHGZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:25:22 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57988 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752624Ab1DHGZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:25:21 -0400
Date: Fri, 8 Apr 2011 08:25:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110408062506.GB1596@ucw.cz>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <alpine.LFD.2.02.1103241929450.16085@x980>
 <20110325113048.GC29521@elte.hu>
 <201103252333.23880.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103252333.23880.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So how does your reasoning not apply to those drivers? There's several which 
> > are older than APM support.
> > 
> > We had this really big battle about x86/Voyager two years ago, which x86 
> > subarchitecture literally had just a single user left, and the code was more 
> > intrusive than APM. Even there after much flaming the eventual consensus was 
> > that we'd accept it back if it was done cleanly, as part of the new-style 
> > x86_platform code.
> > 
> > Given that APM fits into the current PM frameworks there's no such problem here 
> > that i can see.
> 
> Well, it kind of does but not really. :-)
> 
> The main problem with APM is that nobody really works on it and I'm not sure
> if there are any active users.  At least no one reports any problems with it,
> which is kind of surprising, given the number of chages we've made in the PM
> core for the last couple of years.  So quite likely it's just become
> non-functional over time anyway, but we have no confirmation.

It was working ok last time I tried -- cca 6/2010.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
