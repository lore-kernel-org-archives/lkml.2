Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1DKNG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 09:06:56 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59560 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889Ab1DKNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 09:06:55 -0400
Date: Mon, 11 Apr 2011 15:05:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86 APM: delete Linux kernel APM support
Message-ID: <20110411130505.GA3301@ucw.cz>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <alpine.LFD.2.02.1103241929450.16085@x980>
 <20110325113048.GC29521@elte.hu>
 <201103252333.23880.rjw@sisk.pl>
 <20110408062506.GB1596@ucw.cz>
 <4D9F7630.1090503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9F7630.1090503@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Well, it kind of does but not really. :-)
> >>
> >> The main problem with APM is that nobody really works on it and I'm not sure
> >> if there are any active users.  At least no one reports any problems with it,
> >> which is kind of surprising, given the number of chages we've made in the PM
> >> core for the last couple of years.  So quite likely it's just become
> >> non-functional over time anyway, but we have no confirmation.
> > 
> > It was working ok last time I tried -- cca 6/2010.
> 
> What aspects of it did you test, and on what platform?

thinkpad 560X.

I tested basic boot, IIRC it did turn backlight off properly in
screensaver and even suspend worked.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
