Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab2BPN6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:58:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40800 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2BPN63 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:58:29 -0500
Message-ID: <1329400699.2293.221.camel@twins>
Subject: Re: [PATCH v3 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW
 definition
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>
Date: Thu, 16 Feb 2012 14:58:19 +0100
In-Reply-To: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
References: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 17:42 +0000, Catalin Marinas wrote:
> Hi,
> 
> This is version 3 of the set of patches removing
> __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM. The series was rebased on top of
> 3.3-rc1 and fixed the conflicts with the kernel/sched/ changes and the
> ARM LPAE patches. There are no functional changes from v2. I plan to
> push this to -next and get it ready for 3.4-rc1.
> 
> Question for Peter/Ingo - how do we merge the first patch that
> introduces finish_arch_post_lock_switch? Do you pick it up or I can
> merge it via rmk (with your ack)?

Russell, what's the status of these patches? I'd like to see them land
in 3.4 if possible.

If you take them in your arm tree, I can ask Ingo to pull from there and
then I can build on them from there..
