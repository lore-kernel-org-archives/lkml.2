Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0ERPXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:23:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab0ERPXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:23:00 -0400
Date: Tue, 18 May 2010 08:19:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] core/locking changes for v2.6.35
In-Reply-To: <20100518145212.GA21448@elte.hu>
Message-ID: <alpine.LFD.2.00.1005180815460.4195@i5.linux-foundation.org>
References: <20100517212848.GA28536@elte.hu> <alpine.LFD.2.00.1005180729340.4195@i5.linux-foundation.org> <20100518145212.GA21448@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 May 2010, Ingo Molnar wrote:
> 
> But we can also chop off the final commit and redo it 
> without the jiffies timeout.

Ok. I pulled your top-commit-missing version instead. Thanks,

		Linus
