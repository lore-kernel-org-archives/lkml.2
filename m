Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab2ESLKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 07:10:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59924 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478Ab2ESLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 07:10:05 -0400
Date: Sat, 19 May 2012 13:09:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, cl@linux.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
Message-ID: <20120519110959.GB2012@gmail.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
 <4FB66756.2060302@redhat.com>
 <1337355341.573.68.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337355341.573.68.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

< [...]
> 
> That said, I'll leave the door open and will consider 
> something like his scanning stuff as an optional add on on-top 
> of this.
> 
> I very much believe in doing the simple thing first, and this 
> is that, this is much like what the userspace daemons try to 
> do and many of the traditional Unixes have also done (albeit 
> many of those didn't go the way of home-node migration).

Probably because those Unices didnt survive long enough to reach 
NUMA machines in earnest. SMP was a big deal already.

Thanks,

	Ingo
