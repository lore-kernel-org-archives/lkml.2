Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3AEWFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 17:05:10 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32955 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab3AEWFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 17:05:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-pm@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/1] Delete legacy power trace API
Date: Sat, 05 Jan 2013 23:10:46 +0100
Message-ID: <5190666.Mu6UtpjCCL@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357350544-32704-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357350544-32704-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 04, 2013 08:49:03 PM Paul Gortmaker wrote:
> The actual deletion is mind-numbingly simple; and if you go by the
> comments in the code, it is well overdue.  However, in discussions
> with Frederic, he suggested to me that those comments might have
> been overly optimistic, and that there may still be people out
> there who are still unknowingly using this dead API.
> 
> So, that is the crux of the RFC component -- to check whether the
> comments saying "delete by v3.1" can be taken at face value, or
> whether they were overly optimistic, and hence this stuff is still
> actively used even though it is overdue for deletion.

Do you want me or the tracing maintainers to handle this?

Rafael


> ---
> 
> Paul Gortmaker (1):
>   tracing: remove deprecated power trace API
> 
>  Documentation/trace/events-power.txt | 27 +----------
>  arch/arm/mach-omap2/pm34xx.c         |  2 -
>  arch/x86/kernel/process.c            |  6 ---
>  drivers/cpufreq/cpufreq.c            |  1 -
>  drivers/cpuidle/cpuidle.c            |  2 -
>  include/trace/events/power.h         | 92 ------------------------------------
>  kernel/trace/Kconfig                 | 15 ------
>  kernel/trace/power-traces.c          |  3 --
>  8 files changed, 1 insertion(+), 147 deletions(-)
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
