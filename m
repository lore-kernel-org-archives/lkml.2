Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1LFR4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:56:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35452 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1LFR4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:56:23 -0500
Date: Tue, 6 Dec 2011 18:54:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206175443.GB25031@elte.hu>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323185640.7454.269.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ben Hutchings <ben@decadent.org.uk> wrote:

> On Tue, 2011-12-06 at 01:38 -0800, tip-bot for Ben Hutchings wrote:
> > Commit-ID:  fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
> > Gitweb:     http://git.kernel.org/tip/fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
> > Author:     Ben Hutchings <ben@decadent.org.uk>
> > AuthorDate: Fri, 28 Oct 2011 04:36:55 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 6 Dec 2011 08:16:49 +0100
> > 
> > lockdep, rtmutex, bug: Show taint flags on error
> > 
> > Show the taint flags in all lockdep and rtmutex-debug error messages.
> > 
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Link: http://lkml.kernel.org/r/1319773015.6759.30.camel@deadeye
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> [...]
> 
> If you disagree with a patch, do not silently drop parts of 
> it.  I demand that you remove my 'Signed-off-by' as this is 
> not the change I submitted.

FYI, there's no "I will only sign off on a patch doing two 
things if it's applied in full" kind of condition in the SOB 
definition, allowing that would break the GPL: people have the 
right to take your modifications to the GPL-ed kernel and modify 
it further.

Your original patch did two things. Peter did the sensible 
thing: he split out the print_kernel_ident() changes from your 
patch which stand on their own and kept your authorship in place 
- that is what the above patch does.

Once you send it out the SOB is valid and people can (and 
typically will) modify it - and if you are still the main author 
(which you are here 100%) then keeping you as the author is the 
proper approach - Peter added his own SOB after yours.

Thanks,

	Ingo
