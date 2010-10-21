Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0JUXwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:52:31 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:35697 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783Ab0JUXwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:52:30 -0400
Date: Fri, 22 Oct 2010 10:52:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101021235227.GI12506@dastard>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
 <20101021132034.GB13620@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021132034.GB13620@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 12:20:34AM +1100, Nick Piggin wrote:
> It seems we are at an impasse.
> 
> It doesn't help that you are ignoring the most important concerns
> I've been raising with these patches. The locking model and the
> patch split up. I'd really like not to get deadlocked on this (haha),
> so please let's try to debate points. I've tried to reply to each
> point others have questioned me about, whether I agree or not I've
> given reasons.
> 
> So, you know my objections to this approach already... I've got an
> update on my patchset coming, so I'd like to get some discussion
> going. I've cut out some of the stuff from mine so we don't get
> bogged down in boring things like per-zone locking or changing of
> the hash table data structure.

No point appealing to me, Nick, it's not me that you have to
convince. As I've said from the start, all I really care about is
getting the code into shape that is acceptable to the reviewers.

As such, I don't think there is anything _new_ to discuss - I'd
simply be rehashing the same points I've already made to you over
the past couple of weeks. That has done nothing to change you mind
about anything, so it strikes me as a continuing exercise in
futility.

We have different ways of acheiving the same thing which have their
pros and cons, and I think that the reviewers of the patch sets are
aware of this. The reviewers are the people that will make the
decision on the best way to proceed, and I'll follow their lead
exactly as I have been since I started this process.

So, if you want to continue arguing that your locking model is the
One True Way, you need to convince the reviewers of the fact, not
me. I'm just going to continue to address the concerns of the
reviewers and fix bugs that reported until a decision is made one
way or the other....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
