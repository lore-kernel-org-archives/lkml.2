Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2JOQLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:11:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40735 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2JOQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:11:49 -0400
MIME-Version: 1.0
In-Reply-To: <1350065376-23353-2-git-send-email-fweisbec@gmail.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com> <1350065376-23353-2-git-send-email-fweisbec@gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 15 Oct 2012 17:11:27 +0100
X-Google-Sender-Auth: xt4Ml6ezSznH9Vo_X7AnLgyrDuA
Message-ID: <CAHkRjk7yGZmFN6GoXXBciNAQV_Mw3yz7KQs6jc34D+bVpP3pbA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2012 19:09, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/arm/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>
> diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
> new file mode 100644
> index 0000000..f1bffa2
> --- /dev/null
> +++ b/arch/arm64/include/asm/irq_work.h
> @@ -0,0 +1 @@
> +#include <asm-generic/irq_work.h>

Just add generic-y += irq_work.h to arch/*/include/asm/Kbuild to avoid
creating new files.

-- 
Catalin
