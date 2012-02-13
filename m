Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab2BMX31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:29:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57769 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2BMX3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:29:25 -0500
Date: Mon, 13 Feb 2012 23:29:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
Message-ID: <20120213232901.GG25655@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.02.1202022016480.2759@xanadu.home> <1328234629-32735-1-git-send-email-sboyd@codeaurora.org> <CAH+eYFCKcPzMMp_Ef5iX0Xp=xK8MdvJoUBRgKGT56SVjY5DXoA@mail.gmail.com> <alpine.LFD.2.02.1202131307430.24536@xanadu.home> <4F3952C7.3040502@codeaurora.org> <20120213181501.GD25655@n2100.arm.linux.org.uk> <4F398D61.9080501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F398D61.9080501@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 02:23:29PM -0800, Stephen Boyd wrote:
> On 02/13/12 10:15, Russell King - ARM Linux wrote:
> > On Mon, Feb 13, 2012 at 10:13:27AM -0800, Stephen Boyd wrote:
> >> Thanks. Russell has already merged the original patch to the fixes
> >> branch. Hopefully he can fold this one in.
> > Nope, I've asked Linus to pull it.
> >
> > So do we conclude that the original patch wasn't properly tested? :P
> 
> Sigh. Lockdep strikes again! I promise I tested it with lockdep disabled.
> 
> It looks like Linus' hasn't pulled yet but maybe he just hasn't
> published it.

It's not nice to change something after you've sent a pull request -
there's no way of knowing when Linus actually pulls it before he's
published it, and if he gets something different then it can raise
questions.

So, it's gone in as-is, and, as I'm now intending asking for another
pull request soo soon after my previous one, this is something that
we will have to live with probably for the remainder of the week.

Note that you should, by default, build your development kernels with
lockdep enabled, it's there as a debugging tool to help you find
logical locking errors faster than people can provoke deadlocks.

