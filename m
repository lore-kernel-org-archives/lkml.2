Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0LCJf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 04:35:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59647 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab0LCJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 04:35:27 -0500
Date: Fri, 3 Dec 2010 10:35:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net,
        Andi Kleen <andi@firstfloor.org>, tim.bird@am.sony.com
Subject: Plans for 2.6.35-longterm was Re: Linux stable kernel release
 procedure changes
Message-ID: <20101203093519.GA8800@basil.fritz.box>
References: <20101203004247.GA21762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203004247.GA21762@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I already have someone lined up who wants to maintain the .35 kernel in
> a longterm manner that I trust, Andi Kleen, and I'll let him write to
> explain his goals for this kernel and what he's going to do.

Thanks Greg, for all your work on this.

I plan to maintain the 2.6.35 tree longterm for now. My employer 
(Intel) is interested in basing a distribution on it, and there are others 
(like CELF) who also want to base long term trees on 2.6.35.

The longterm tree will continue where Greg left 2.6.35-stable.
It will not be called "stable", but called "longterm" to make
the distinction clear.

The tree will follow the stable rules in Documentation/stable_kernel_rules.txt.

My plan is to look at all patches that go into later stables (that is which 
are sent to stable@ or marked Cc: stable@kernel.org in the git description) 
and merge them into 2.6.35 when applicable. I don't expect there will be many
patches only for 2.6.35 and not for later stable trees. If there are and
they are submitted to stable@ I will consider them.  I plan to be fairly 
conservative.

I will follow a similar flow as Greg: There will be candidate trees which
are posted to Linux kernel and have a 48h review period, with patches
being dropped then as needed. Then the candidates will turn into 
releases.

Right now I only plan to post them to linux-kernel and not bother the 
usual review comittee, but this may change if the reviewers want to see 
2.6.35 too. There are also at least one volunteer (hi Tim) who plans
to test the tree (but it still needs to be worked out if that should
be done before or after the release). Any others doing reviewing and testing
would be also appreciated.

For security problems there will be faster releases, using a similar
procedure as Greg uses today.

The exact locations for the candidate and release trees on kernel.org
still need to be worked out and will be announced at a future date.

I should also add I will be on vacation for three weeks in December. I plan
to release a catchup release before that and then pick up everything 
else left after that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
