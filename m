Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1KQWmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:42:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1KQWmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:42:20 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=rTd_Mk60H-wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8 a=zfQy0ej6lb62geqezSkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 5/8] trace: Include <asm/asm-offsets.h> in
 trace_syscalls.c
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1321569446-20433-6-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
	 <1321569446-20433-6-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 17:42:17 -0500
Message-ID: <1321569737.3533.20.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 14:37 -0800, H. Peter Anvin wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> Include <asm/asm-offsets.h> into trace_syscalls.c, to allow for
> NR_syscalls to be automatically generated.

Did this cause some sort of bug before? What was the issue before this
patch?

-- Steve

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  kernel/trace/trace_syscalls.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index cb65454..5f35f6f 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -6,6 +6,7 @@
>  #include <linux/ftrace.h>
>  #include <linux/perf_event.h>
>  #include <asm/syscall.h>
> +#include <asm/asm-offsets.h>
>  
>  #include "trace_output.h"
>  #include "trace.h"


