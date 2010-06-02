Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab0FBPx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:53:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758417Ab0FBPx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:53:57 -0400
Date: Wed, 2 Jun 2010 08:52:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       benh@kernel.crashing.org, paulus@samba.org, sparse@chrisli.org
Subject: Re: [GIT PULL] rcu: finalize debugobjects, first round of RCU
 sparse pointer checks
Message-Id: <20100602085254.778aaf31.akpm@linux-foundation.org>
In-Reply-To: <20100602192749.F512.A69D9226@jp.fujitsu.com>
References: <20100601165034.GA9522@linux.vnet.ibm.com>
	<20100602192749.F512.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Jun 2010 19:34:41 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Hello, Ingo,
> > 
> > Here are the final commits from Mathieu's debugobjects series and the
> > first few from Arnd's RCU-pointer sparse series.  The first three remove
> > RCU's (useless) initializations from mm, fs, and powerpc:
> > 
> > mm:	http://lkml.org/lkml/2010/5/18/562
> > fs:	http://lkml.org/lkml/2010/5/18/500
> > powerpc:http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg43510.html
> > 
> > Kosaki Motohiro agreed that the mm patch should go up -tip, and none of
> > the other maintainers objected to the prospect of their patches going
> > up -tip.
> 
> Andrew, can we hear your opinion? I think this patch series have some
> dependencies, then -tip is best place. If any code confliction occur,
> I promise I'll solve it soon.
> 

A wee little two-line patch?  Go wild!
