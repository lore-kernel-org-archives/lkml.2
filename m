Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1DEIcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:32:39 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41156 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504Ab1DEIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:32:37 -0400
Date: Tue, 5 Apr 2011 09:32:14 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3/8] kernel/signal.c: add kernel-doc notation to
 syscalls
Message-ID: <20110405093214.0dd7278d@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110404150026.46478a04.rdunlap@xenotime.net>
References: <20110404145803.8663081d.rdunlap@xenotime.net>
	<20110404150026.46478a04.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011 15:00:26 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> @@ -2660,6 +2708,13 @@ out:
>  #endif /* __ARCH_WANT_SYS_SIGPROCMASK */
>  
>  #ifdef __ARCH_WANT_SYS_RT_SIGACTION
> +/**
> + *  sys_rt_sigaction - alter an action taken by a process
> + *  @sig: signal to be sent
> + *  @act: the thread group ID of the thread
> + *  @oact: the PID of the thread
> + *  @sigsetsize: size of sigset_t type
> + */
>  SYSCALL_DEFINE4(rt_sigaction, int, sig,
>  		const struct sigaction __user *, act,
>  		struct sigaction __user *, oact,

This isn't right. @act and @oct are the new and old actions for @sig.

-- 
Matt Fleming, Intel Open Source Technology Center
