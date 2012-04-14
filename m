Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2DNKu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:50:57 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43892 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2DNKuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:50:55 -0400
Date: Sat, 14 Apr 2012 12:50:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20120414105049.GA13137@gmail.com>
References: <20120413.152455.900761231064979707.davem@davemloft.net>
 <CA+55aFwYWRv6+ix+UjT52UAn1rQeDpUKmbWq5SdHjZ0qHR2Cbg@mail.gmail.com>
 <20120413215012.GA31739@merkur.ravnborg.org>
 <20120414091352.GA15373@gmail.com>
 <20120414102300.GA32120@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120414102300.GA32120@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, Apr 14, 2012 at 11:13:52AM +0200, Ingo Molnar wrote:
> > 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > On Fri, Apr 13, 2012 at 12:46:34PM -0700, Linus Torvalds wrote:
> > > > On Fri, Apr 13, 2012 at 12:24 PM, David Miller <davem@davemloft.net> wrote:
> > > > >
> > > > > With special guest sparc64 assembler hacker, Paul E. McKenney.
> > > > 
> > > > Oh christ.  You're teaching *more* people about sparc64?
> > > You do not get it...
> > > 
> > > How many people are pondering around tweaking every bit of x86
> > > specific code? A lot! Let them have fun competing :-)
> > 
> > I wish it was so! In reality there's really just a handful of 
> > people looking at actual x86 assembly code. I don't know whether 
> > I've ever seen a conflict between substantial x86 assembly 
> > patches, in the last 4 years since I co-maintain the x86 
> > architecture ...
> 
> Hmm...
> 
>       lines of c files  lines of S files
> x86   183609            27130
> sparc 66823             25852

Yes.

( I have no idea what the 'Hmm...' means - do those numbers 
  somehow contradict what I said? )

> There is more than just assembly when dealign with an architecture.

Definitely.

Thanks,

	Ingo
