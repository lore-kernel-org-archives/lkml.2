Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1ECLkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:40:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64777 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab1ECLkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:40:40 -0400
Subject: Re: [PATCH 0/6] hw_breakpoint: Let the user choose not to build it
 (and perf too)
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 12:40:07 +0100
Message-ID: <1304422807.27863.6.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 17:59 +0100, Frederic Weisbecker wrote:
> Hi,

Hi Frederic,

> Until now, x86 and superh32 had to always build hw_breakpoint and perf.
> And powerpc and arm were always building hw_breakpoints when perf
> was enabled.
> 
> After this patchset, one can simply disable hw_breakpoints if he
> selected CONFIG_EXPERT. Afterward the user is free to select perf
> or not. Except on SH unfortunately because that would require a
> bit of change in ptrace to support singlestep failures.

For the ARM bits:

Acked-by: Will Deacon <will.deacon@arm.com>

Cheers,

Will

