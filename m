Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1EaQfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:35:13 -0400
Received: from mail.perches.com ([173.55.12.10]:2345 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab1EaQfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:35:11 -0400
Subject: Re: [GIT PULL] x86 fixes
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110531163022.GA15435@elte.hu>
References: <20110531163022.GA15435@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 09:35:09 -0700
Message-ID: <1306859709.20175.27.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 18:30 +0200, Ingo Molnar wrote:
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
[]
> @@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
>  		boot_option_idle_override = IDLE_POLL;
>  	} else if (!strcmp(str, "mwait")) {
>  		boot_option_idle_override = IDLE_FORCE_MWAIT;
> -		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
> +		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\"\n");

Extra quote at end.  More likely you want:

		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\n");


