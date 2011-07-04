Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1GDOhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:37:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63756 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1GDOhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:37:02 -0400
Date: Mon, 4 Jul 2011 16:36:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110704143655.GE5551@somewhere>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
 <1309362157-6596-2-git-send-email-avi@redhat.com>
 <20110629160841.GA2032@somewhere>
 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>
 <20110704135820.GD5551@somewhere>
 <4E11C9CC.2070909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E11C9CC.2070909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 05:10:20PM +0300, Avi Kivity wrote:
> On 07/04/2011 04:58 PM, Frederic Weisbecker wrote:
> >Another thing I would like to do in the even longer term is to not use perf anymore
> >for ptrace breakpoints, because that involves a heavy dependency and few people are
> >happy with that. Instead we should just have a generic hook into the sched_switch()
> >and handle pure ptrace breakpoints there. The central breakpoint API would still be
> >there to reserve/schedule breakpoint resources between ptrace and perf.
> >
> 
> 'struct preempt_notifier' may be the hook you're looking for.

Yeah looks like a perfect fit as it's per task.

Thanks.
