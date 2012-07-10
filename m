Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2GJCV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:21:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63157 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2GJCVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:21:49 -0400
Date: Mon, 9 Jul 2012 19:21:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to -mm tree
In-Reply-To: <1341885802.6118.101.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.00.1207091904480.25143@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com> <1341873376.6118.56.camel@joe2Laptop> <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com> <1341876067.6118.67.camel@joe2Laptop>
 <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com> <1341881721.6118.92.camel@joe2Laptop> <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com> <1341885802.6118.101.camel@joe2Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Joe Perches wrote:

> I don't really care what style a large block of code
> uses.  I care that it mostly has the same form.
> 

Same form??  The sizeof operator has two forms depending on whether it's a 
unary expression or a type as specified by the standard.

The issue here is that you're mandating they all use the same form because 
you're quoting an email from Linus four years ago that you dug up but 
isn't required in the coding style and is already used in over 1000 places 
in the kernel.

If you want the output of checkpatch.pl to be useful, I would think you 
would want to eliminate this kind of garbage.

> > I guarantee you that those who learned from K&R don't 
> > think sizeof(unsigned long) "looks like a function".
> 
> Tell that to Linus. He wrote the email I referenced
> which you so apparently blithely elided.
> 
> Repeating it:
> 
> "Another example of this is "sizeof". The kernel universally (I hope) has 
> parenthesis around the sizeof argument, even though it's clearly not 
> required by the C language."
> 

He's obviously addressing a single form of the sizeof operator, i.e. those 
on unary expressions; sizeof used on a type CLEARLY DOES require the 
parenthesis.

Anyway, since this is my last email on the matter since I've already 
showed how your patch is completely busted, you're talking purely about 
style preferences here.  Don't convolute that by talking about the C 
standard or Linus' email where he says "it's a coding standard."  It's 
not.  I've layed out the two forms of the sizeof operator in every email 
I've written in this thread.  If you want to enforce a _style_ preference 
because you saw an email four years ago that Linus wrote, then add it to 
CodingStyle first and get him to mandate it.  That's how you effect a 
kernel-wide change; the _only_ person I know that uses checkpatch is 
Andrew and you'll notice the mm directory is the one where "sizeof ..." 
isn't used so just changing checkpatch here won't do much good.

Thanks and have a nice day.
