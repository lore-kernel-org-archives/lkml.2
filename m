Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1HBSjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:39:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33413 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754663Ab1HBSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:39:19 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/+y+x7Qyf+owbvxrReFBK/Ilwv0umfRn5pCemgxa
	cgIbfar0hlpiht
From: Sven Joachim <svenjoac@gmx.de>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [ANNOUNCE] The longterm Linux 2.6.35.14 kernel is released
References: <20110801215908.GA11448@tassilo.jf.intel.com>
	<87sjpk9ttf.fsf@turtle.gmx.de>
	<20110802181751.GB7087@tassilo.jf.intel.com>
Date: Tue, 02 Aug 2011 20:39:16 +0200
In-Reply-To: <20110802181751.GB7087@tassilo.jf.intel.com> (Andi Kleen's
	message of "Tue, 2 Aug 2011 11:17:51 -0700")
Message-ID: <87aabraca3.fsf@turtle.gmx.de>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-02 20:17 +0200, Andi Kleen wrote:

> On Tue, Aug 02, 2011 at 09:05:48AM +0200, Sven Joachim wrote:
>> On 2011-08-01 23:59 +0200, Andi Kleen wrote:
>> 
>> > The longterm Linux kernel 2.6.35.14 is released.
>> >
>> > A note on the 2.6.35.13 git tags & branches: when releasing 2.6.35.13 I made
>> > a mistake which resulted in the v2.6.35.13 tag being on a different
>> > branch than the master tree.  I decided the continue on the branch,
>> > not the tag, so you have to delete the v2.6.35.13 tag -- if you're
>> > using that -- and refetch the new tag. If you just use the "master" branch
>> > or the released patches/tarballs you don't need to do anything. Sorry about that.
>> 
>> Well, there is still a little problem with the git repository.  You have
>> pushed the tag but not the master branch to git.kernel.org.
>
> I checked the tree on master, it is uptodate. Don't know why it's 
> not reaching the main git server. Maybe have to wait a bit longer.

I don't think that's the problem, since the v2.6.35.14 tag and the
commits that lead to it have been at
git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git for
at least twelve hours.  The problem is that while the tag is there, the
master branch is still at v2.6.35.13-original.  This happens if you just
"git push v2.6.35.14" without _also_ explicitly pushing the master
branch.  In that case, the commits leading to v2.6.35.14 get pushed (and
can be fetched with "git fetch -t") but are not on any branch.

Linus himself had already made this mistake at least twice, so it can
happen to anyone, I guess. :-)

Cheers,
       Sven
