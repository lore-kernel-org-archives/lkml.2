Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2HQAUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:20:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43031 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2HQAUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:20:06 -0400
MIME-Version: 1.0
Message-ID: <a8bfd9e8-7286-42f5-b8ef-16af00fceb8b@default>
Date: Thu, 16 Aug 2012 17:19:28 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: RE: [PATCH 0/3] staging: zcache+ramster: move to new code base and
 re-merge
References: <1345156293-18852-1-git-send-email-dan.magenheimer@oracle.com>
 <20120816224814.GA18737@kroah.com>
 <9f2da295-4164-4e95-bbe8-bd234307b83c@default>
 <20120816230817.GA14757@kroah.com>
In-Reply-To: <20120816230817.GA14757@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [PATCH 0/3] staging: zcache+ramster: move to new code base and re-merge
> 
> On Thu, Aug 16, 2012 at 03:53:11PM -0700, Dan Magenheimer wrote:
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Subject: Re: [PATCH 0/3] staging: zcache+ramster: move to new code base and re-merge
> > >
> > > On Thu, Aug 16, 2012 at 03:31:30PM -0700, Dan Magenheimer wrote:
> > > > Greg, please pull for staging-next.
> > >
> > > Pull what?
> >
> > Doh!  Sorry, I did that once before and used the same template for the
> > message.  Silly me, I meant please apply.  Will try again when my
> > head isn't fried. :-(
> >
> > > You sent patches, in a format that I can't even apply.
> > > Consider this email thread deleted :(
> >
> > Huh?  Can you explain more?  I used git format-patch and git-email
> > just as for previous patches and even checked the emails with
> > a trial send to myself.  What is un-apply-able?
> 
> Your first patch, with no patch description, and no signed-off-by line.
> 
> Come on, you know better...

Doh! Script error, and I completely didn't look at the content
of the delete patch, just the add patches.

I am _really_ sorry and suitably embarrassed.  Please forgive me!
 
> On a larger note, I _really_ don't want a set of 'delete and then add it
> back' set of patches.  That destroys all of the work that people had
> done up until now on the code base.
> 
> I understand your need, and want, to start fresh, but you still need to
> abide with the "evolve over time" model here.  Surely there is some path
> from the old to the new codebase that you can find?

While I in absolutely no way want to minimize the contribution
of others, it was very clear (even to you) that things were
not progressing very fast toward an on-by-default end-user-usable
non-hobbyist-distro-shippable zcache.  Major work needed to
be done, and you rejected a first step in that direction, here:
https://lkml.org/lkml/2012/3/16/472  It certainly seemed that
the time for major changes for zcache in staging were at an end.

In my investigation of what needed to be fixed (and we can always
quibble about what is a feature or a design flaw or a bug fix),
I found a lot of interdependency and "did it all at once"
with the intent of (1) proving the fixes were possible and (2)
completing a suitable replacement ready to propose directly into
mm, since it appeared staging was now closed.  I got very close
but ran out of time.

(My jaw dropped when I saw this response from you last week
http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/02244.html )

Yes, it is always possible to retrofit a massive change into
a bunch of smaller ones, but my use of the word Sisyphean
was intentional.  It will certainly take weeks of debugging and,
to be completely honest, I don't have the patience to re-do it
and I don't think anyone else will invest the time either.

So, unless someone else steps up to retrofit, we have a choice
of the in-tree code (which I call "demo" code because that's
what it is/was) and the massive rewrite.  I'm really not
trying to present this as an ultimatum, just trying to be real.

> Also, I'd like to get some agreement from everyone else involved here,
> that this is what they all agree is the correct way forward.  I don't
> think we have that agreement yet, right?

Correct, though I think we all have roughly the same destination
in mind, and we are mostly disagreeing on tactics.  Seth says
"ship sh##it NOW and pick up the pieces later", Minchan says
"current code is very bad, Andrew will never take it, how do
we fix it", and I have invested months of my time into a monolithic
patch which I (as author of both) say is much better.  Bias noted ;-)

In any case, Minchan asked me to post my code as a formal patch
http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/02466.html 
so I have done so (however awkwardly, sorry).  Thanks for listening,
Greg, and I hope you have the wisdom of Solomon on this one.

Dan
