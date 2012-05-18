Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2ERPkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:40:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:59364 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab2ERPkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:40:22 -0400
Message-ID: <1337355610.573.70.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 17:40:10 +0200
In-Reply-To: <1337355341.573.68.camel@twins>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 17:35 +0200, Peter Zijlstra wrote:
> I've also said many times over that I absolutely detest all the async
> stuff because it messes up accounting. And until someone comes up with a
> sane means of sorting that I'll stick to migrate-on-fault.

The other nice advantage of migrate-on-fault is that you don't have to
play lifetime games with vmas. This much simplifies that aspect.

Again, simple things first.
