Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423243Ab2KNTHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:07:16 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58764 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423130Ab2KNTHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:07:14 -0500
MIME-Version: 1.0
In-Reply-To: <1352587485-18348-1-git-send-email-keescook@chromium.org>
References: <1352587485-18348-1-git-send-email-keescook@chromium.org>
Date: Wed, 14 Nov 2012 11:07:13 -0800
X-Google-Sender-Auth: z4WUNJEQ4TYQFrkzFKFNs5Qn3DU
Message-ID: <CAGXu5jKYGCkL3GS4Tbep==WUAqP-c_0edAdgy0XQ84rJxZUU2Q@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] arch/arm: support seccomp
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, any more thoughts on this series? I'd really like to get it into
-next. It's been running happily for a while now in the Chrome OS ARM
devices.

Thanks,

-Kees

On Sat, Nov 10, 2012 at 2:44 PM, Kees Cook <keescook@chromium.org> wrote:
> This adds support for seccomp BPF to ARM. When built with the seccomp
> improvement patch waiting in linux-next ("seccomp: Make syscall skipping
> and nr changes more consistent"), this passes the seccomp regression
> test suite: https://github.com/redpig/seccomp
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

-- 
Kees Cook
Chrome OS Security
