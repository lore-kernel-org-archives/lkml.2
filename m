Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2B0R1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:27:11 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52699 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753600Ab2B0R1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:27:09 -0500
Message-ID: <1330363627.9942.16.camel@joe2Laptop>
Subject: Re: "whitespace coding style cleanup" broke coding style
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net
Date: Mon, 27 Feb 2012 09:27:07 -0800
In-Reply-To: <4F4BB983.8020608@suse.cz>
References: <4F4B45F6.4090706@suse.cz> <1330361549.9942.7.camel@joe2Laptop>
	 <4F4BB983.8020608@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 18:12 +0100, Jiri Slaby wrote:
> On 02/27/2012 05:52 PM, Joe Perches wrote:
> > Notice that the code improperly uses commas and
> > not semicolons for line terminations like the
> > lines immediately above and below it.
> 
> Oh, and you see that you made it actually _worse_?

Actually, no.  This changes does highlight a
nominal code style defect though.

> The patch should not 
> touch the code at all. It is obviously totally broken. In a separate 
> patch you might do s@,@;@ instead.

The code in either form is neither broken nor
incorrect.  It's just "out of style".
Emacs did made it consistent.

> Hmm, but did not we conclude some time ago that we will not touch code 
> just to perform a whitespace cleanup?

It's a prelude to other patches so actually
that's done quite a lot.   git blame -w
doesn't even show my name on any of the
code in this patch.

> > It was a first pass and an overall improvement.
> 
> I hope no other passes are going to happen there or anywhere in TTY 
> drivers. I really do not want to solve zillion collisions in my ~100 
> local patches due to whitespace changes, sorry.

Perhaps you should submit your ~100 patches sooner
rather than later.  That's a lot of changes that
could have any number of collisions.

> Yes, but it does not pass our brain, does it? One should throw 
> "checkpatch --file" or alike away, finally.

Perhaps you might notice I did not use checkpatch
as a guide nor as a criteria for submission.

It was ~5MB patch btw.  Compilation was done to
verify lack of object delta only.

Thanks for noticing the oddly formatted code.
I'll send a patch to fix it.

cheers, Joe


