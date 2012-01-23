Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2AWJ07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:26:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58163 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab2AWJ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:26:58 -0500
Date: Mon, 23 Jan 2012 09:26:24 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW
 definition
Message-ID: <20120123092624.GA11983@arm.com>
References: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
 <1327310131.2446.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327310131.2446.1.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 09:15:31AM +0000, Peter Zijlstra wrote:
> On Fri, 2012-01-20 at 17:42 +0000, Catalin Marinas wrote:
> > This is version 3 of the set of patches removing
> > __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM. The series was rebased on top of
> > 3.3-rc1 and fixed the conflicts with the kernel/sched/ changes and the
> > ARM LPAE patches. There are no functional changes from v2. I plan to
> > push this to -next and get it ready for 3.4-rc1.
> > 
> > Question for Peter/Ingo - how do we merge the first patch that
> > introduces finish_arch_post_lock_switch? Do you pick it up or I can
> > merge it via rmk (with your ack)?
> 
> I'm fine either way, I'll probably ask Ingo to pull your tree so that I
> can stack some other patches on top.

In which case I would need Russell's acked-by.

Thanks.

-- 
Catalin
