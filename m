Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0CQIC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:02:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58003 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab0CQICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:02:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: build warning after merge of the tip tree
Cc: kosaki.motohiro@jp.fujitsu.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100317070239.GA16374@elte.hu>
References: <20100317145702.e314f75b.sfr@canb.auug.org.au> <20100317070239.GA16374@elte.hu>
Message-Id: <20100317170228.870F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Mar 2010 17:02:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > After merging the tip tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > kernel/sched.c: In function 'SYSC_sched_getaffinity':
> > kernel/sched.c:4915: warning: comparison of distinct pointer types lacks a cast
> 
> I already reported this yesterday, see:
> 
>   http://patchwork.kernel.org/patch/86244/

yup, very thanks.



