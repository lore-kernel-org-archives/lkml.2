Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2DKQTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:19:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab2DKQTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:19:33 -0400
Date: Wed, 11 Apr 2012 09:19:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC/PATCH] trace: Remove unused workqueue tracer
Message-ID: <20120411161928.GB12887@google.com>
References: <1333994425-30379-1-git-send-email-sboyd@codeaurora.org>
 <20120409181152.GC7522@google.com>
 <CAFTL4hyrkCd7=AMY2ah-ynCekfYEN=wy55Xb9xngRwOP+mGNgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFTL4hyrkCd7=AMY2ah-ynCekfYEN=wy55Xb9xngRwOP+mGNgg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 08:20:37PM +0200, Frederic Weisbecker wrote:
> 2012/4/9 Tejun Heo <tj@kernel.org>:
> > On Mon, Apr 09, 2012 at 11:00:25AM -0700, Stephen Boyd wrote:
> >> This tracer was temporarily removed in 6416669 (workqueue:
> >> temporarily remove workqueue tracing, 2010-06-29) but never
> >> reinstated after concurrency managed workqueues were completed.
> >> For almost two years it hasn't been compilable so it seems nobody
> >> is using it. Delete it.
> >>
> >> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >> Cc: Tejun Heo <tj@kernel.org>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >
> > Yeah, I feel somewhat guilty about this.  The plan was to make it work
> > again once cmwq is stable but I never got around to it.  That said, if
> > nobody is using it, shedding code is always nice.  If nobody objects,
> > I'll push this patch through wq/for-3.5.  We can revive it later if
> > necessary.
> 
> No problem for me.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Applied to wq/for-3.5. Thanks.

-- 
tejun
