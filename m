Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1GDN2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:28:06 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34012 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1GDN2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:28:02 -0400
Date: Mon, 4 Jul 2011 18:57:46 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 2/6] hw_breakpoints: Migrate breakpoint conditional build
 under new config
Message-ID: <20110704132746.GA2963@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
 <1306273947-8410-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306273947-8410-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:52:23PM +0200, Frederic Weisbecker wrote:
> Migrate conditional hw_breakpoint code compilation under
> the new config to prepare for letting the user chose whether
> or not to build this feature
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/arm/include/asm/hw_breakpoint.h     |    4 ++--
>  arch/arm/include/asm/processor.h         |    2 +-
>  arch/arm/kernel/Makefile                 |    2 +-
>  arch/arm/kernel/entry-header.S           |    2 +-
>  arch/arm/kernel/ptrace.c                 |    4 ++--
>  arch/powerpc/include/asm/cputable.h      |    4 ++--
>  arch/powerpc/include/asm/hw_breakpoint.h |    6 +++---
>  arch/powerpc/include/asm/processor.h     |    4 ++--
>  arch/powerpc/kernel/Makefile             |    2 +-
>  arch/powerpc/kernel/process.c            |   18 +++++++++---------
>  arch/powerpc/kernel/ptrace.c             |   13 +++++++------
>  arch/powerpc/lib/Makefile                |    2 +-
>  arch/sh/kernel/Makefile                  |    2 +-
>  arch/sh/kernel/cpu/sh4a/Makefile         |    2 +-
>  include/linux/hw_breakpoint.h            |    6 +++---
>  include/linux/perf_event.h               |    4 ++--
>  include/linux/ptrace.h                   |    6 +++---
>  include/linux/sched.h                    |    2 +-
>  kernel/events/Makefile                   |    2 +-
>  kernel/events/core.c                     |    4 ++--
>  kernel/ptrace.c                          |    4 ++--
>  samples/Kconfig                          |    2 +-
>  22 files changed, 49 insertions(+), 48 deletions(-)
> 

Making the hardware breakpoint patches modular has always been a goal.
I've looked at the PowerPC parts of the code and they look harmless.

Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>

Thanks,
K.Prasad

