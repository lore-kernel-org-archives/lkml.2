Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1JAJfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 05:35:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48245 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab1JAJft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 05:35:49 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Matt Fleming <matt@console-pimps.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
In-Reply-To: <m21uuxirxi.fsf@firstfloor.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <m21uuxirxi.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 10:35:38 +0100
Message-ID: <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 15:30 -0700, Andi Kleen wrote:
> Matt Fleming <matt@console-pimps.org> writes:
> >
> > And just like last time, these patches break ia64 because it
> > implements rt_sigprocmask() in assembly. I'll work on the ia64 stuff
> > while these patches are being reviewed.
> 
> Since we don't want to tie everyone changing signals in the future to
> learning IA64 assembler, maybe the best approach would be simply to
> change that function to just use the syscall. It can't be that
> performance critical and everyone else has it as a syscall too.
> 
> I think that would be the best solution for long term maintainability.

You and me both. Unfortunately, the ia64 guys had a different opinion,
http://www.spinics.net/lists/linux-ia64/msg08363.html

-- 
Matt Fleming, Intel Open Source Technology Center

