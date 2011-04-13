Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1DMNcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:32:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50112 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752581Ab1DMNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:32:40 -0400
Date: Wed, 13 Apr 2011 15:30:35 +0200
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
Message-ID: <20110413133034.GB1874@ucw.cz>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <alpine.LFD.2.02.1103241929450.16085@x980>
 <20110325113048.GC29521@elte.hu>
 <201103252333.23880.rjw@sisk.pl>
 <20110408062506.GB1596@ucw.cz>
 <4D9F7630.1090503@zytor.com>
 <20110411130505.GA3301@ucw.cz>
 <4DA34619.6010708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA34619.6010708@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-04-11 11:19:05, H. Peter Anvin wrote:
> On 04/11/2011 06:05 AM, Pavel Machek wrote:
> > Hi!
...
> >> What aspects of it did you test, and on what platform?
> > 
> > thinkpad 560X.
> > 
> > I tested basic boot, IIRC it did turn backlight off properly in
> > screensaver and even suspend worked.
> 
> OK, but I presume runtime power management wasn't on the list at least
> on what matters.

No, I was not measuring with the multimeter. (This machine still
has 2nd, good battery, I could...). I'd notice if it broke horribly.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
