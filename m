Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab2HITTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:19:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63229 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2HITTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:19:42 -0400
Message-ID: <50240D47.7050906@amacapital.net>
Date: Thu, 09 Aug 2012 12:19:35 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Meredydd Luff <meredydd@senatehouse.org>
CC: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RFC] syscalls,x86: Add execveat() system call (v2)
References: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org>
In-Reply-To: <1343859049-3632-1-git-send-email-meredydd@senatehouse.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 03:10 PM, Meredydd Luff wrote:
>  
> +#ifndef sys_execveat
> +asmlinkage long sys_execveat(int dfd, const char __user *filename,
> +			     const char __user *const __user *argv,
> +			     const char __user *const __user *envp,
> +			     struct pt_regs *regs);
> +#endif

Should this have a flags argument for future extension?

--Andy

