Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab2EWUE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:04:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56195 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2EWUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:04:58 -0400
Date: Wed, 23 May 2012 22:04:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fix
Message-ID: <20120523200451.GA19288@gmail.com>
References: <20120523185054.GA17700@gmail.com>
 <CA+5PVA5m5U67mt8mXH_i_2Zu7OuVWiHfR82kBwqJm5ey4R26sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA5m5U67mt8mXH_i_2Zu7OuVWiHfR82kBwqJm5ey4R26sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Boyer <jwboyer@gmail.com> wrote:

> On Wed, May 23, 2012 at 2:50 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > Linus,
> >
> > Please pull the latest perf-urgent-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus
> >
> >   HEAD: 5bcdf5e4fee3c45e1281c25e4941f2163cb28c65 perf/x86: Update event scheduling constraints for AMD family 15h models
> >
> > Leftover AMD PMU driver fix fix from the end of the v3.4
> > stabilization cycle.
> 
> Perf doesn't even build in Linus' current tree.

Yes, that's a regression in some build environments. (it builds 
fine in our environments, that's why it wasn't noticed.)

> [...]  You might want to include
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=8784eb7497b928de33a715e26da2bd51d424bec1
> 
> with your pull request.

I sent that (and other fixes) to Linus too, earlier today.

This pull request you replied to is the v3.4 era fixes tree, 
with one remaining fix in it.

Thanks,

	Ingo
