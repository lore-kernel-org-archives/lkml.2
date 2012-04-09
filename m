Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2DISL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:11:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab2DISL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:11:56 -0400
Date: Mon, 9 Apr 2012 11:11:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC/PATCH] trace: Remove unused workqueue tracer
Message-ID: <20120409181152.GC7522@google.com>
References: <1333994425-30379-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333994425-30379-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:00:25AM -0700, Stephen Boyd wrote:
> This tracer was temporarily removed in 6416669 (workqueue:
> temporarily remove workqueue tracing, 2010-06-29) but never
> reinstated after concurrency managed workqueues were completed.
> For almost two years it hasn't been compilable so it seems nobody
> is using it. Delete it.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Yeah, I feel somewhat guilty about this.  The plan was to make it work
again once cmwq is stable but I never got around to it.  That said, if
nobody is using it, shedding code is always nice.  If nobody objects,
I'll push this patch through wq/for-3.5.  We can revive it later if
necessary.

Thank you.

-- 
tejun
