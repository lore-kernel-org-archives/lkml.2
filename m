Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab2ERPru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:47:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:59506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab2ERPrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:47:49 -0400
Message-ID: <1337356050.573.73.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 17:47:30 +0200
In-Reply-To: <alpine.DEB.2.00.1205181036380.21093@router.home>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <4FB66756.2060302@redhat.com>
	 <alpine.DEB.2.00.1205181022470.21093@router.home>
	 <1337355223.573.66.camel@twins>
	 <alpine.DEB.2.00.1205181036380.21093@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 10:37 -0500, Christoph Lameter wrote:
> On Fri, 18 May 2012, Peter Zijlstra wrote:
> 
> > Most of that is due to existing interfaces, I'm afraid we cannot
> > simplify without reducing those :/
> 
> I think some change to those would also be appropriate. Those have grown
> over a long time and there are some areas of problematic integration with
> the scheduler, numa policies and cpusets etc.

You're free to explore that avenue.. But afaict all these interfaces are
in active use. 

And yes, some of it is rather awkward, but such is the price we pay for
backwards compatibility.
