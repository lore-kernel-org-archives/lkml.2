Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1LFSOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:14:45 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:60513 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752650Ab1LFSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:14:44 -0500
Date: Tue, 6 Dec 2011 13:14:22 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Hutchings <ben@decadent.org.uk>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206181422.GA11881@elliptictech.com>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <20111206175443.GB25031@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206175443.GB25031@elte.hu>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-06 18:54 +0100, Ingo Molnar wrote:
> * Ben Hutchings <ben@decadent.org.uk> wrote:
> > On Tue, 2011-12-06 at 01:38 -0800, tip-bot for Ben Hutchings wrote:
> > > Commit-ID:  fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
> > > Gitweb:     http://git.kernel.org/tip/fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
> > > Author:     Ben Hutchings <ben@decadent.org.uk>
> > > AuthorDate: Fri, 28 Oct 2011 04:36:55 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Tue, 6 Dec 2011 08:16:49 +0100
> > > 
> > > lockdep, rtmutex, bug: Show taint flags on error
> > > 
> > > Show the taint flags in all lockdep and rtmutex-debug error messages.
> > > 
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Link: http://lkml.kernel.org/r/1319773015.6759.30.camel@deadeye
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > [...]
> > 
> > If you disagree with a patch, do not silently drop parts of 
> > it.  I demand that you remove my 'Signed-off-by' as this is 
> > not the change I submitted.
> 
> FYI, there's no "I will only sign off on a patch doing two 
> things if it's applied in full" kind of condition in the SOB 
> definition, allowing that would break the GPL: people have the 
> right to take your modifications to the GPL-ed kernel and modify 
> it further.

If you want to play the GPL card, you will note that the GPL requires
modified versions of a work to carry prominent notices that they have
been modified, including the date of any change.

A signoff by a maintainer does not imply that any modifications have
been made, so I don't think that counts as "prominent".

> Your original patch did two things. Peter did the sensible 
> thing: he split out the print_kernel_ident() changes from your 
> patch which stand on their own and kept your authorship in place 
> - that is what the above patch does.

In which case, the changelog should have been amended to state that
it's a modification of Ben's original submission.

> Once you send it out the SOB is valid and people can (and 
> typically will) modify it - and if you are still the main author 
> (which you are here 100%) then keeping you as the author is the 
> proper approach - Peter added his own SOB after yours.

Linux convention is to add a signoff *and* a description of any changes
to the original submission in square brackets.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
