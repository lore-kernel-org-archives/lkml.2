Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab2DISUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:20:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38807 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2DISUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120409181152.GC7522@google.com>
References: <1333994425-30379-1-git-send-email-sboyd@codeaurora.org>
	<20120409181152.GC7522@google.com>
Date: Mon, 9 Apr 2012 20:20:37 +0200
Message-ID: <CAFTL4hyrkCd7=AMY2ah-ynCekfYEN=wy55Xb9xngRwOP+mGNgg@mail.gmail.com>
Subject: Re: [RFC/PATCH] trace: Remove unused workqueue tracer
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/9 Tejun Heo <tj@kernel.org>:
> On Mon, Apr 09, 2012 at 11:00:25AM -0700, Stephen Boyd wrote:
>> This tracer was temporarily removed in 6416669 (workqueue:
>> temporarily remove workqueue tracing, 2010-06-29) but never
>> reinstated after concurrency managed workqueues were completed.
>> For almost two years it hasn't been compilable so it seems nobody
>> is using it. Delete it.
>>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>
> Yeah, I feel somewhat guilty about this.  The plan was to make it work
> again once cmwq is stable but I never got around to it.  That said, if
> nobody is using it, shedding code is always nice.  If nobody objects,
> I'll push this patch through wq/for-3.5.  We can revive it later if
> necessary.

No problem for me.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
