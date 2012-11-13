Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab2KMTX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:23:26 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41021 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab2KMTXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:23:24 -0500
Message-ID: <50A29E28.5040303@mit.edu>
Date: Tue, 13 Nov 2012 11:23:20 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.ports.arm.kernel
To: Kees Cook <keescook@chromium.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH v5 0/4] arch/arm: support seccomp
References: <1352587485-18348-1-git-send-email-keescook@chromium.org>
In-Reply-To: <1352587485-18348-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2012 02:44 PM, Kees Cook wrote:
> This adds support for seccomp BPF to ARM. When built with the seccomp
> improvement patch waiting in linux-next ("seccomp: Make syscall skipping
> and nr changes more consistent"), this passes the seccomp regression
> test suite: https://github.com/redpig/seccomp

I don't know if this matters much on ARM, but should something like
https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=commit;h=dee1ae5a05149f30baeccb4b8f68f22525ba9ca2
be added?

--Andy

> 
> Thanks,
> 
> -Kees
> 
> ---
> v5:
>  - clean up seccomp failure path, as requested by Will Deacon.
> v4:
>  - fixed syscall_get_arch, thanks to Will Deacon.
> v3:
>  - updates suggested by Russell King:
>    - reduced scope of expansion
>    - leveraged TIF_SYSCALL_WORK bit mask
>    - fixed syscall==-1 short-circuit logic
> v2:
>  - expanded ptrace_syscall_trace() into both callers and do
>    secure_computing() hookup there, as requested by Al Viro.
> 

