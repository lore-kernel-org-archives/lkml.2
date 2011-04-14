Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab1DNOYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:24:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64821 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab1DNOYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:24:06 -0400
Message-ID: <4DA70319.8000902@mvista.com>
Date: Thu, 14 Apr 2011 18:22:17 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        x86@kernel.org, Paul Mundt <lethal@linux-sh.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] sh: convert to asm-generic ptrace.h
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-5-git-send-email-vapier@gentoo.org>
In-Reply-To: <1302760895-13459-5-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mike Frysinger wrote:

> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  arch/sh/include/asm/ptrace.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

> diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
> index b219a08..3f2a6e7 100644
> --- a/arch/sh/include/asm/ptrace.h
> +++ b/arch/sh/include/asm/ptrace.h
[...]
> @@ -137,6 +136,9 @@ static inline unsigned long profile_pc(struct pt_regs *regs)
>  
>  	return pc;
>  }
> +#define profile_pc profile_pc

    Same question about preprocessor...

WBR, Sergei
