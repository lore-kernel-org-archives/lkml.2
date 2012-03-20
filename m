Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2CTJ0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:26:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36811 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2CTJ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:26:43 -0400
Date: Tue, 20 Mar 2012 09:26:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vivek Singh <vivek.siwan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Existence of NR_create_module for arm
Message-ID: <20120320092634.GQ15988@n2100.arm.linux.org.uk>
References: <CAJrcCc3By5gxvN4VY2OQUxBmTcSSWmpZuQGn6HqRDErAUKAmjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJrcCc3By5gxvN4VY2OQUxBmTcSSWmpZuQGn6HqRDErAUKAmjA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 02:02:06PM +0530, Vivek Singh wrote:
> Hello There,
> 
> While compiling tomoyo-tools for arm I  found that NR_create_module  is not
> available in
> arch/arm/include/asm/unistd.h
> 
> #define __NR_sigprocmask                (__NR_SYSCALL_BASE+126)
>                                                        /* 127 was
> sys_create_module */
> #define __NR_init_module                (__NR_SYSCALL_BASE+128)
> 
> 
> But it is available in
> 
> ./arch/x68/include/asm/unistd_32.h
> 
> #define __NR_sigprocmask        126
> #define __NR_create_module      127
> #define __NR_init_module        128
> 
> is there any reason why it is not available for arm ?

The syscall is obsolete, and has been for many years.
