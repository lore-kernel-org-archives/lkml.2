Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2LEKse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:48:34 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50282 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2LEKs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:48:29 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Wed, 5 Dec 2012 11:48:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc7-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> (sfid-20121126_101746_129378_6672726D)
In-Reply-To: <20121126091202.GO32450@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212051148.28039.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 26. November 2012 schrieb Dave Chinner:
> On Sun, Nov 25, 2012 at 09:55:20PM -0500, Theodore Ts'o wrote:
> > On Mon, Nov 26, 2012 at 11:28:14AM +1100, Dave Chinner wrote:
> > > fs: revert commit bbdd6808 to fallocate UAPI
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Commit bbdd6808 ("fs: reserve fallocate flag codepoint") changes
> > > the fallocate(2) syscall interface. The flag that is reserved by
> > > this commit is for functionality that has previously been NAKed on
> > > the -fsdevel mailing list, and so exists out-of-tree.
> > 
> > Hi Linus,
> > 
> > It doesn't change the interface or break anything; it just reserves a
> > bit so that out-of-tree patches don't collide with future
> > allocations. There are significant usages of this bit within Google
> > and Tao Bao. It is true that there has been significant pushback
> > about adding this functionality on linux-fsdevel;
> 
> It's not the fact that you want to reserve a bit that is at issue
> here - it's the way it's been pushed into the tree that is the
> front-and-center issue.
> 
> > I find it personally frustrating that
> > in effect, if enough people scream, they can veto an optional feature
> > that might only be implemented by a single file system.
> 
> Having a significant portion of the wider fs development community
> disagree with your patches is no reason for subverting the review
> process.  Besides, that's irrelevant to the issue being discussed,
> unless you are describing your motives in an effort to justify your
> actions.
> 
> In fact, it's even more disturbing if this was your real motive.
> That is, is sounds somewhat like you've just admitted that you
> pushed this change silently through the ext4 tree to avoid review
> and discussion and that you are blaming the rest of the FS community
> for forcing you to take such actions.
> 
> > It's not like there is any shortage of flag bits, so what's the harm
> > of reserving the bit?
> 
> The harm has already been done - to the trust we've placed in you as
> a maintainer.  To argue that the code does no harm is to completely
> miss the crux of the issue at hand: principles, process and trust
> are far more important in our community than a single line of
> code.
> 
> Ted, it comes down to trust. If we can't trust you not to push your
> own changes to syscall APIs into the mainline tree via backdoor
> channels, then how can we trust you not to push the entire
> out-of-tree patch into the kernel the same way?

Ping.

Linus, while I am interested in an answer I think that Dave and Christoph 
as Linux filesystem developers actually deserve one (instead of silently 
being ignored which is also a decision in this matter).

I did not see an answer in linux-2.6 commit log as of today so far.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
