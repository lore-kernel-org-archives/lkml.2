Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1DKQ2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:28:54 -0400
Received: from linux-sh.org ([111.68.239.195]:43560 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1DKQ2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:28:53 -0400
Date: Tue, 12 Apr 2011 01:28:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/5] sh, hw_breakpoints: Fix racy access to ptrace breakpoints
Message-ID: <20110411162818.GB13545@linux-sh.org>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com> <1302284067-7860-6-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302284067-7860-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 07:34:27PM +0200, Frederic Weisbecker wrote:
> While the tracer accesses ptrace breakpoints, the child task may
> concurrently exit due to a SIGKILL and thus release its breakpoints
> at the same time. We can then dereference some freed pointers.
> 
> To fix this, hold a reference on the child breakpoints before
> manipulating them.
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
