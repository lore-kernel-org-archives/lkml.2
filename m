Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab2HAWx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 18:53:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48340 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab2HAWx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:53:57 -0400
Message-ID: <5019B36A.4030604@zytor.com>
Date: Wed, 01 Aug 2012 15:53:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Meredydd Luff <meredydd@senatehouse.org>
CC: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org>
In-Reply-To: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 03:10 PM, Meredydd Luff wrote:
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index 51171ae..c35df9e 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -319,6 +319,7 @@
>  310	64	process_vm_readv	sys_process_vm_readv
>  311	64	process_vm_writev	sys_process_vm_writev
>  312	64	kcmp			sys_kcmp
> +313	64	execveat		stub_execveat
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact

I think that should be common, not 64 (as should kcmp be).

	-hpa

