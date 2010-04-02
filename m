Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0DBTvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:51:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800Ab0DBTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:51:37 -0400
Date: Fri, 2 Apr 2010 12:47:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
cc: kgdb-bugreport@lists.sourceforge.net, Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] kgdb: Use atomic operators whichuse
 barriers
In-Reply-To: <4BB649E3.5060606@windriver.com>
Message-ID: <alpine.LFD.2.00.1004021246470.3634@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com><1270233145-29335-2-git-send-email-jason.wessel@windriver.com><1270233145-29335-3-git-send-email-jason.wessel@windriver.com><1270233145-29335-4-git-send-email-jason.wessel@windriver.com><1270233145-29335-5-git-send-email-jason.wessel@windriver.com><alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org>
 <4BB64762.6040806@windriver.com> <4BB649E3.5060606@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Apr 2010, Jason Wessel wrote:
> 
> Here is the revised patch, which is going into the kgdb-fixes branch.

Yeah, this patch I have no issues with.

Except:

> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: [PATCH] kgdb: Use atomic operators which use barriers
> 
> The cpu_relax() does not mandate that there is an smp memory barrier.
> As a result on the arm smp architecture the kernel debugger can hang
> on entry from time to time, as shown by the kgdb regression tests.

Now your changelog makes no sense any more.

		Linus
