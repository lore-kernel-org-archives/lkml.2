Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1EYC24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 22:28:56 -0400
Received: from linux-sh.org ([111.68.239.195]:39818 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab1EYC2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 22:28:55 -0400
Date: Wed, 25 May 2011 11:27:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] hw_breakpoint: Let the user choose not to build it (and perf too)
Message-ID: <20110525022723.GE14329@linux-sh.org>
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:52:21PM +0200, Frederic Weisbecker wrote:
> Mostly just a rebase against latest upstream
> updates and acks from Will Deacon added In this second version.
> 
> Please tell me if you are ok with this set.
> 
> Thanks.
> 
> ---
> 
> Frederic Weisbecker (6):
>       hw_breakpoints: Split hardware breakpoints config
>       hw_breakpoints: Migrate breakpoint conditional build under new config
>       x86: Allow the user not to build hw_breakpoints
>       hw_breakpoints: Breakpoints arch ability don't need perf events
>       hw_breakpoints: Only force perf events if breakpoints are selected
>       hw_breakpoints: Drop remaining misplaced dependency on perf
> 
The series looks good to me:

Acked-by: Paul Mundt <lethal@linux-sh.org>
