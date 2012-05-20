Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab2ETCXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:23:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2ETCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:23:07 -0400
Date: Sat, 19 May 2012 19:23:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, tip-bot for Peter Zijlstra wrote:

> Commit-ID:  3a0fea961b98d1838f35dba51a639d40f4a5589f
> Gitweb:     http://git.kernel.org/tip/3a0fea961b98d1838f35dba51a639d40f4a5589f
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 8 Mar 2012 17:56:08 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 18 May 2012 08:16:27 +0200
> 
> sched/numa: Introduce sys_numa_{t,m}bind()
> 

This depends on 931ea9d1a6e0 ("rcu: Implement per-domain single-threaded 
call_srcu() state machine") from core/rcu.
