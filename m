Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2JQQko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:40:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50951 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab2JQQkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:40:43 -0400
Date: Wed, 17 Oct 2012 17:40:35 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
Message-ID: <20121017164035.GE27870@arm.com>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
 <20121015013009.GB2616@ZenIV.linux.org.uk>
 <CAHkRjk7QbybMx1Kc9dP-Mz_ujMmHf5htLViviNok=HKjac0G+A@mail.gmail.com>
 <20121017163424.GA2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20121017163424.GA2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 17 Oct 2012 16:40:39.0424 (UTC) FILETIME=[24101000:01CDAC86]
X-MC-Unique: 112101717404117601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:34:24PM +0100, Al Viro wrote:
> On Wed, Oct 17, 2012 at 03:02:15PM +0100, Catalin Marinas wrote:
> > Hi Al,
> > 
> > On 15 October 2012 02:30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > arch-arm64 - patches from maintainer with minor followup folded
> > 
> > Thanks for updating the arm64 branch. I've adapted the changes, tested
> > and folded them into the branch below (the AArch64 instruction set
> > does not have conditional instructions):
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git
> > execve
> 
> Fetched and merged, thanks.  I'll probably drop arch-arm64 branch, now
> that I have yours directly merged.  In any case, right now arch-arm64
> points to the current head or yours and for-next has
> 
> commit 0cea479343cbfaec3a9b8accdeadae53322d98a8
> Merge: 43cc05a 6a87277
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Wed Oct 17 12:29:32 2012 -0400
> 
>     Merge branch 'execve' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch
> 
> in it...

Sounds fine. Thanks.

-- 
Catalin

