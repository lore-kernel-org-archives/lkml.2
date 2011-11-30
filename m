Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1K3CgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:36:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47081 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab1K3CgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:36:03 -0500
Date: Wed, 30 Nov 2011 10:35:49 +0800
From: Shan Hai <haishan.bai@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH 1/1] sched/rt: code cleanup, remove a redundant function
 call
Message-ID: <20111130023548.GA31187@ubuntu.corp.ad.wrs.com>
References: <1322535836-13590-1-git-send-email-haishan.bai@gmail.com>
 <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
 <1322572622.2921.231.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322572622.2921.231.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 02:17:02PM +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-29 at 11:03 +0800, Shan Hai wrote:
> > The second time call to sched_rt_period is redundant, because the value of the
> > rt_runtime was already read and it was protected by the rurt_runtime_lock.
> > 
> > Signed-off-by: Shan Hai <haishan.bai@gmail.com>
> > ---
> >  kernel/sched_rt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Note that that file doesn't exist anymore, scheduler patches should be
> posted against tip/master.
>

Got it, thanks.

Cheers
Shan Hai
 
> Anyway, fixed that up and applied it. Thanks!
