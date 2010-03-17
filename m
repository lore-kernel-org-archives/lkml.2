Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0CQEAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:00:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46512 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0CQEAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:00:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the tip tree
Cc: kosaki.motohiro@jp.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100317145702.e314f75b.sfr@canb.auug.org.au>
References: <20100317145702.e314f75b.sfr@canb.auug.org.au>
Message-Id: <20100317125844.4CA9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Mar 2010 13:00:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi all,
> 
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> kernel/sched.c: In function 'SYSC_sched_getaffinity':
> kernel/sched.c:4915: warning: comparison of distinct pointer types lacks a cast
> 
> Introduced by commit cd3d8031eb4311e516329aee03c79a08333141f1 ("sched:
> sched_getaffinity(): Allow less than NR_CPUS length").  Just a usage of
> min() with different types.

yup. I've posted the fixing patch today.

thanks!


