Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664Ab2CVUF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:05:29 -0400
Received: from smtp.nokia.com ([147.243.128.26]:39909 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030392Ab2CVUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:05:28 -0400
Date: Thu, 22 Mar 2012 22:01:44 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Peter Seebach <peter.seebach@windriver.com>
Cc: "ext H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>,
        apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
Message-ID: <20120322200144.GF19970@pcarmody2.research.nokia.com>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <4F6B51C9.6010904@suse.cz>
 <4F6B5902.1080607@zytor.com>
 <20120322174802.GE19970@pcarmody2.research.nokia.com>
 <20120322141005.1abe7b1e@wrlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322141005.1abe7b1e@wrlaptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/12 14:10 -0500, ext Peter Seebach wrote:
> On Thu, 22 Mar 2012 19:48:02 +0200
> Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> 
> > While empty paramter lists in function definitions are not technically
> > wrong, those situations are rare enough that it's worth encouraging
> > people towards a more uniform, always unambiguous, style.
> 
> Typo here ("paramter").
> 
> You don't need to check for (...).  That doesn't actually exist, and
> gcc rejects it (as it should).  The description of () as meaning (...)
> is a (slight) oversimplification.

Thanks, and thanks, yup. I just got carried away by HPA's wonderful tale, 
I took it too literally.

>  As to the () case:
> 
> The rules here are complicated.  Complicated enough that I don't even
> TRY to remember them.  Fundamentally, f() is equivalent to either
> f(void) or f(please do unpleasant things to me with railroad spikes).
> I would definitely endorse a policy discouraging its use.

It appears we have quite broad agreement, it's just the details that
need to be polished.

> I can only think of one exception, and it's inapplicable.  The
> exception:  Imagine that you wish to write a wrapper for a function
> like scandir, which takes a function pointer as an argument, and you
> wish the wrapper to work on two systems where the arguments passed to
> the function pointer are of different types, but you yourself will
> never actually see or care about the arguments; you just want to pass
> the function pointer around.  Then it could make sense to declare the
> argument as int (*compar)().  But that's a once-a-lifetime use case,
> give or take.

Maybe WG14 should introduce (...) for just that case! :-D

Cheers for your input Seebs,
Phil
