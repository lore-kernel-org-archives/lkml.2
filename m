Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0HRRH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab0HRRHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:07:24 -0400
Subject: Re: [GIT PULL] notification tree: directory events
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruen@suse.de>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <20100818164230.GA26034@infradead.org>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
	 <201008162232.36873.agruen@suse.de> <201008181747.15461.agruen@suse.de>
	 <1282147146.21419.165.camel@acb20005.ipt.aol.com>
	 <20100818164230.GA26034@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 13:07:03 -0400
Message-ID: <1282151223.21419.189.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 12:42 -0400, Christoph Hellwig wrote:
> On Wed, Aug 18, 2010 at 11:59:06AM -0400, Eric Paris wrote:
> > Thus far your e-mails have pointed out one bug in the permissions
> > implementation I am currently working fixing and a bunch of complaining
> > about features you can imagine someone might someday want but which
> > noone has actually stood up and said 'I will use this' or 'this sucks
> > for my use case'.  I can find all sorts of things around the kernel
> > where I can imagine some mythical users might want to do something
> > different but it isn't a reason to prevent merger.  I'd love to have
> > more review, I'm certainly going to look at your wish list, but don't
> > expect response to future trolling messages.
> 
> Eric, please stop that crap.  You've sent a pull request for stuff
> that's not only been contentious but also not reviewed at all in this
> form to Linus behind everyones back.  Andreas actually takes his time
> to review the clusterfuck you created, so better be really quite and
> listen to him.

I admit that there were a number of patches created since the last merge
request was held up based on Al's review that weren't sent to list.  I
said I screwed up and pointed out what was missed before it was merged.
Clearly those changes didn't live in linux-next long enough to catch all
of their problems (namely the f_count thing everyone agreed was dirty
and broke sound)  I wasn't the only person to look at most of those
changes, but they absolutely should have been on list.  I've screwed up
on that twice.

But an implication that the idea, the interface, the event types sent
and received, how things worked, or anything like that wasn't sent to
list or that I didn't beg for review just isn't true (all of which has
been implied).

I fucked up not posting some of my internal notification reworks to
improve system performance, maintainability, and reliability.  But any
belief that 'contentious' portions of code just magically showed up
behind anyone's back or at the last minute isn't true.

Like I said, I'd love more review.  I'll gladly add more things to my
todo list if people have useful ideas.  But multiple messages suggesting
code should be reverted because it doesn't implement some imagined
feature or because the code has a bug for I'm betting well over a year
obviously bothers me.

-Eric

