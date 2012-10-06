Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2JFQUC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 12:20:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50671 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2JFQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 12:20:00 -0400
Date: Sat, 6 Oct 2012 17:19:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
Message-ID: <20121006161954.GG2616@ZenIV.linux.org.uk>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
 <CAHkRjk6oaZh643hciXyVbvq74KTWgZjfKhyZW1gi8oNEMw3h-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkRjk6oaZh643hciXyVbvq74KTWgZjfKhyZW1gi8oNEMw3h-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 05:07:47PM +0100, Catalin Marinas wrote:
> Al,
> 
> On 1 October 2012 22:38, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         Right now the tree lives in
> > git.kernel.org/pub/scm/linux/kernel/git/viro/signal experimental-kernel_thread
> > Some of that had been in -next for a while.
> >
> >         Folks, help with review, testing and filling the missing bits, please.
> 
> I tested this branch with the arm64 kernel and runs ok (I get couple
> of compiler warnings because reparent_to_kthread and
> __set_special_pids are no longer used with the removal of daemonize).

Applied and pushed.  Also there - folded fixes from jejb into parisc part,
optimizations of the fork-related paths in parisc on top of that (completely
untested), fixed the sparc64 breakage davem had spotted yesterday.
