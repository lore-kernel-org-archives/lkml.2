Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab0CPRLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:11:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872Ab0CPRLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:11:04 -0400
Date: Tue, 16 Mar 2010 18:10:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, travis@sgi.com, peterz@infradead.org,
       drepper@redhat.com, rja@sgi.com, sharyath@in.ibm.com,
       akpm@linux-foundation.org, steiner@sgi.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: sched_getaffinity(): Allow less than
 NR_CPUS length
Message-ID: <20100316171034.GA17211@elte.hu>
References: <20100312161316.9520.A69D9226@jp.fujitsu.com>
 <tip-cd3d8031eb4311e516329aee03c79a08333141f1@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-cd3d8031eb4311e516329aee03c79a08333141f1@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Commit-ID:  cd3d8031eb4311e516329aee03c79a08333141f1
> Gitweb:     http://git.kernel.org/tip/cd3d8031eb4311e516329aee03c79a08333141f1
> Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> AuthorDate: Fri, 12 Mar 2010 16:15:36 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 15 Mar 2010 08:28:44 +0100
> 
> sched: sched_getaffinity(): Allow less than NR_CPUS length

> +		int retlen = min(len, cpumask_size());

this one causes:

kernel/sched.c:4850: warning: comparison of distinct pointer types lacks a cast

	Ingo
