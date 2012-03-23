Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab2CWM0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:26:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61303 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CWM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:26:00 -0400
Date: Fri, 23 Mar 2012 13:25:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, josh@joshtriplett.org,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Merge x86_32 and x86_64 cpu_idle()
Message-ID: <20120323122556.GE13920@gmail.com>
References: <4F63AF10.9030101@zytor.com>
 <1331934010-24740-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331934010-24740-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard Weinberger <richard@nod.at> wrote:

> Both functions are mostly identical, so we can merge them.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/x86/include/asm/idle.h  |    1 +
>  arch/x86/kernel/process.c    |  114 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/process_32.c |   60 ----------------------
>  arch/x86/kernel/process_64.c |  109 ----------------------------------------
>  4 files changed, 115 insertions(+), 169 deletions(-)

Doesn't apply on latest -tip:

patching file arch/x86/include/asm/idle.h
patching file arch/x86/kernel/process.c
Hunk #2 succeeded at 26 with fuzz 2 (offset 1 line).
Hunk #3 succeeded at 392 (offset 1 line).
patching file arch/x86/kernel/process_32.c
Hunk #3 succeeded at 55 (offset 1 line).
Hunk #4 FAILED at 65.
1 out of 4 hunks FAILED -- rejects in file arch/x86/kernel/process_32.c
patching file arch/x86/kernel/process_64.c
Hunk #3 FAILED at 48.
1 out of 3 hunks FAILED -- rejects in file arch/x86/kernel/process_64.c

Is a good idea otherwise.

Thanks,

	Ingo
