Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0LIGD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 01:03:29 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:36045 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab0LIGD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 01:03:28 -0500
Subject: Re: [PATCH 1/2] AVR32: Fix sys_execve breakage
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Sven Schnelle <svens@stackframe.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1290382087-3849-2-git-send-email-svens@stackframe.org>
References: <1290382087-3849-1-git-send-email-svens@stackframe.org>
	 <1290382087-3849-2-git-send-email-svens@stackframe.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Thu, 09 Dec 2010 07:03:21 +0100
Message-ID: <1291874601.2794.5.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2010 06:03:24.0316 (UTC) FILETIME=[CA1715C0:01CB9766]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 00:28 +0100, Sven Schnelle wrote: 
> commit d7627467b7a8dd6944885290a03a07ceb28c10eb change sys_execve()
> arch/avr32, but the version in syscalls.h is still the old one.
> 
> Signed-off-by: Sven Schnelle <svens@stackframe.org>
> ---
>  arch/avr32/include/asm/syscalls.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/avr32/include/asm/syscalls.h b/arch/avr32/include/asm/syscalls.h
> index ab608b7..dd69aa0 100644
> --- a/arch/avr32/include/asm/syscalls.h
> +++ b/arch/avr32/include/asm/syscalls.h
> @@ -24,6 +24,11 @@ asmlinkage int sys_vfork(struct pt_regs *);
>  asmlinkage int sys_execve(const char __user *, char __user *__user *,
>  			  char __user *__user *, struct pt_regs *);
>  
> +asmlinkage int sys_execve(const char __user *ufilename,

Invalid patch, double definition of sys_execve.

<snipp>

-- 
Hans-Christian Egtvedt

