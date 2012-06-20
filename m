Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2FTVkC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:40:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126Ab2FTVkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:40:00 -0400
Date: Wed, 20 Jun 2012 14:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add tested-by signature
Message-Id: <20120620143959.394b9930.akpm@linux-foundation.org>
In-Reply-To: <1340209526.29885.14.camel@joe2Laptop>
References: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com>
	<1340209526.29885.14.camel@joe2Laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 09:25:26 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-06-20 at 08:51 -0300, Alexandre Pereira da Silva wrote:
> > The tester of the patch should also be listed to receive patch
> > notifications.
> []
> > diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> []
> > @@ -81,6 +81,7 @@ my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
> >  my @signature_tags = ();
> >  push(@signature_tags, "Signed-off-by:");
> >  push(@signature_tags, "Reviewed-by:");
> > +push(@signature_tags, "Tested-by:");
> >  push(@signature_tags, "Acked-by:");
> 
> I have no objections to this, but maybe Florian Mickler
> (cc'd) who did analysis on signatures awhile ago might.
> 

Yes.  In my experience, a lot of tested-by's come from random internet
victims who happened to report a bug and who we'll never hear from
again and who don't want to be told other things about
whatever-part-of-the-kernel-that-was.

Perhaps the set "has a tested-by, doesn't have reported-by" would
filter out a lot of these, dunno.  It all sounds a bit marginal.



Also, lots of people have used a "Reported-and-tested-by" and there are
even a few lysdexic "Tested-and-[rR]eported-by" tags in there.

Any time I see one of these things I stomp on it and turn it into
separate reported-by and tested-by lines, as Reported-and-tested-by
just adds pointless duplication, work and noise.  But I appear to have
lost that fight.


This fashion of adding new and innovative changelog tags just creates
inaccuracy and work for people who wish to mine that data for something
useful, as Alexandre is finding out.

<does some data mining>

Geeze, guys.  Who knew there were so many Kernel Komedians?


ACKed-by:
AOLed-by:
About-fscking-timed-by:
Accked-by:
Aced-by:
Ached-by:
Acked-By:
Acked-and-Tested-by:
Acked-and-appreciated-by:
Acked-and-reviewed-by:
Acked-and-tested-by:
Acked-by:
Ackeded-by:
Aked-by:
Also-Bisected-by:
Also-Reported-by:
Also-Suggested-by:
Also-analyzed-by:
Also-reported-and-tested-by:
Also-reported-by:
Analysed-by:
Analyzed-by:
Antagonized-by:
Approved-by:
Bisected-and-reported-by:
Bisected-and-requested-by:
Bisected-and-tested-by:
Bisected-by:
Bisected-reported-and-tested-by:
Bitten-by-and-tested-by:
Bug-Identified-by:
Bug-fixed-by:
Bug-identified-by:
Bug-spotted-by:
Cause-discovered-by:
Cautiously-acked-by:
Checked-by:
Committed-by:
Compile-Tested-by:
Compile-tested-by:
Confirmed-by:
Debugged-and-tested-by:
Debugged-by:
Debugged-by:Gautham
Delightedly-acked-by:
Diagnoised-by:
Diagnosed-by:
Discovered-by:
Earlier-version-tested-by:
Embarrassingly-Acked-by:
Emphatically-Acked-by:
Encouraged-by:
Explained-by:
Fatfingered-by:
Finished-by:
Fix-proposed-by:
Fix-suggested-by:
Fixed-by:
Forwarded-by:
Gcc-bug-acked-by:
Grudgingly-acked-by:
Grumpily-requested-by:
Hacked-by:
Hardware-supplied-by:
Hella-acked-by:
Helped-by:
Hinted-by:
Humbly-acked-by:
Identified-by:
Inspired-by:
Inspried-by:
Jffs2-bit-acked-by:
Last-bug-reported-by:
Lightly-Tested-by:
Lightly-tested-by:
Liked-by:
List-Composed-By:
Located-by:
Maybe-reported-by:
Mentored-by:
Modified-by:
More-or-less-tested-by:
Most-Definitely-Acked-by:
Mostly-acked-by:
NACKed-by:
Noted-by:
Noticed-and-Acked-by:
Noticed-by:
Original-coded-by:
Origionally-authored-by:
Partly-suggested-by:
Patch-Inspired-by:
Patch-inspired-by:
Patch-updated-by:
Pointed-out-and-tested-by:
Poked-by:
Proposed-by:
Pushed-by:
Re-reported-by:
Reminded-by:
Repented-by:
Reporeted-by:
Reported--and-debugged-by:
Reported-And-Tested-by:
Reported-Bisected-Tested-by:
Reported-Bistected-and-Tested-by:
Reported-By:
Reported-Debuged-Tested-Acked-by:
Reported-Reviewed-and-Acked-by:
Reported-Tested-by:
Reported-and-Acked-by:
Reported-and-Bisected-by:
Reported-and-Debugged-by:
Reported-and-Reviewed-and-Tested-by:
Reported-and-Reviwed-by:
Reported-and-Tested-By:
Reported-and-Tested-by:
Reported-and-acked-by:
Reported-and-analyzed-by:
Reported-and-bisected-by:
Reported-and-compile-tested-by:
Reported-and-debugged-by:
Reported-and-helped-by:
Reported-and-introduced-by:
Reported-and-isolated-by:
Reported-and-requested-by:
Reported-and-reviewed-by:
Reported-and-root-caused-by:
Reported-and-tested-by:
Reported-any-tested-by:
Reported-bisected-and-tested-by:
Reported-bisected-tested-by:
Reported-by-Tested-by:
Reported-by-and-Tested-by:
Reported-by:
Reported-requested-and-tested-by:
Reported-tested-and-acked-by:
Reported-tested-and-bisected-by:
Reported-tested-and-fixed-by:
Reporteed-by:
Reproduced-by:
Requested-and-acked-by:
Requested-and-tested-by:
Requested-by:
Requsted-by:
Reveiewed-by:
Reviewed-By:
Reviewed-and-Acked-by:
Reviewed-and-Tested-by:
Reviewed-and-discussed-by:
Reviewed-and-tested-by:
Reviewed-and-wanted-by:
Reviewed-by:
Reviewied-by:
Reviwed-by:
Rewieved-by:
Root-caused-by:
Seconded-by:
Serial-parts-Acked-by:
Sight-catched-by:
Signed-by:
Signed-off-and-morning-tea-spilled-by:
Sort-Of-Acked-By:
Spotted-by:
Submitted-by:
Suggested-and-Acked-by:
Suggested-and-acked-by:
Suggested-and-tested-by:
Suggested-by:
Tentatively-acked-by:
Tested-By:
Tested-and-Acked-by:
Tested-and-Reported-by:
Tested-and-Verified-By:
Tested-and-acked-by:
Tested-and-bugfixed-by:
Tested-and-reported-by:
Tested-and-requested-by:
Tested-and-reviewed-by:
Tested-by:
Testted-by:
Triaged-by:
Verified-by:
Was-Acked-by:
Whatevered-by:

