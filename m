Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1AaFIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 00:08:38 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59835 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab1AaFIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 00:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NU8j61Vjer1PYr9tgLdOY6/i9osdmQMsHqeJ83d0ynCmD7BYRBsKO/abqRydhZOb4n
         +Wp1oyMlB8CBd6ThitB2cc00eejtiiABtc+V9dcYvIovd96NBMroKhSKN0/98FIj6KwB
         NbQBWhdr79GG+Xn/HB8CzNwWelWzcA0zBnWdE=
MIME-Version: 1.0
In-Reply-To: <20110131152756.0f1b1026.sfr@canb.auug.org.au>
References: <20110131152756.0f1b1026.sfr@canb.auug.org.au>
Date: Mon, 31 Jan 2011 10:38:35 +0530
Message-ID: <AANLkTi=+VtHwRMkxq+BK3wRDE9fiAZCy=5dypn45o=Hz@mail.gmail.com>
Subject: Re: linux-next: build warnings after merge of the tip tree
From: Jaswinder Singh <jaswinderlinux@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 31, 2011 at 9:57 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
>
> kernel/sched.c:3719: warning: 'irqtime_account_idle_ticks' defined but not used
> kernel/sched.c:3720: warning: 'irqtime_account_process_tick' defined but not used
>

These functions should move inside ifndef CONFIG_VIRT_CPU_ACCOUNTING

Thanks,
--
Jaswinder Singh.
