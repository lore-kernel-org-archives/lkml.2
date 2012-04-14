Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2DNJOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:14:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49616 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2DNJN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:13:58 -0400
Date: Sat, 14 Apr 2012 11:13:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20120414091352.GA15373@gmail.com>
References: <20120413.152455.900761231064979707.davem@davemloft.net>
 <CA+55aFwYWRv6+ix+UjT52UAn1rQeDpUKmbWq5SdHjZ0qHR2Cbg@mail.gmail.com>
 <20120413215012.GA31739@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413215012.GA31739@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Fri, Apr 13, 2012 at 12:46:34PM -0700, Linus Torvalds wrote:
> > On Fri, Apr 13, 2012 at 12:24 PM, David Miller <davem@davemloft.net> wrote:
> > >
> > > With special guest sparc64 assembler hacker, Paul E. McKenney.
> > 
> > Oh christ.  You're teaching *more* people about sparc64?
> You do not get it...
> 
> How many people are pondering around tweaking every bit of x86
> specific code? A lot! Let them have fun competing :-)

I wish it was so! In reality there's really just a handful of 
people looking at actual x86 assembly code. I don't know whether 
I've ever seen a conflict between substantial x86 assembly 
patches, in the last 4 years since I co-maintain the x86 
architecture ...

So there's no competition worth speaking of in x86 assembly 
land, let alone any harmful competition due to overcrowding.
You guys are all welcome, and each of you will make a real 
difference.

Imagine what would happen to Linux adoption rate if DaveM 
started hacking on assembly code that had more than a few
dozen active users?? ;-)

> In sparc land things are much more quiet.

I guess when you are close to absolute zero degrees then even 
liquid oxygen indeed looks incredibly hot ;-)

Thanks,

	Ingo
