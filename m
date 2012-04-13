Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2DMUMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:12:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:52378 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab2DMUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:12:15 -0400
Date: Fri, 13 Apr 2012 16:12:10 -0400 (EDT)
Message-Id: <20120413.161210.474133806577823888.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwYWRv6+ix+UjT52UAn1rQeDpUKmbWq5SdHjZ0qHR2Cbg@mail.gmail.com>
References: <20120413.152455.900761231064979707.davem@davemloft.net>
	<CA+55aFwYWRv6+ix+UjT52UAn1rQeDpUKmbWq5SdHjZ0qHR2Cbg@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 13:12:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 12:46:34 -0700

> On Fri, Apr 13, 2012 at 12:24 PM, David Miller <davem@davemloft.net> wrote:
>>
>> With special guest sparc64 assembler hacker, Paul E. McKenney.
> 
> Oh christ.  You're teaching *more* people about sparc64?
> 
> Where will it end?

:-)

> That said, Looking at the patch, it looks a bit dubious. Why does the
> 
>  		cmp			%l1, 0
> 
> instruction remain, even if the conditional branch was deleted? I'm
> not seeing any subsequent uses of %icc, but hey, I'm no sparc expert
> (nor do I want to be).

It's unnecessary but harmless, I'll sweep it up in the sparc-next tree
when I get a chace.
