Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab1LLGG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:06:29 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:43783 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab1LLGG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:06:27 -0500
Date: Mon, 12 Dec 2011 11:36:11 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/2] selftests: New x86 breakpoints selftest
Message-ID: <20111212060611.GA18998@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1322840475-19553-1-git-send-email-fweisbec@gmail.com>
 <1322840475-19553-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322840475-19553-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11121206-8936-0000-0000-000005555E49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 04:41:15PM +0100, Frederic Weisbecker wrote:
> Bring a first selftest in the relevant directory. This tests
> several combinations of breakpoints and watchpoints in x86, as
> well as icebp traps and int3 traps. Given the amount of breakpoint
> regressions we raised after we merged the generic breakpoint
> infrastructure, such selftest became necessary and can still serve
> today as a basis for new patches that touch the do_debug() path.
> 


Hi Frederic,
	Can we also including testing of watchpoints over kernel variables?
We could do this using the perf syscall or (in a convoluted way) use a
kernel module that works in tandem with this user-space testcase.

Thanks,
K.Prasad

