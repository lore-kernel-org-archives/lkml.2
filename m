Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1HVIzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 04:55:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab1HVIzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 04:55:16 -0400
Subject: Re: [Bug #39342] [3.0.0-rc6-git7] possible recursive locking
 atcache_alloc_refill
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org
Date: Mon, 22 Aug 2011 10:54:22 +0200
In-Reply-To: <CAOJsxLH+qQxVwwx+2t-azc8fw+uz2+M9SCRzMUGdKKbUc1nC7A@mail.gmail.com>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	 <bkwpSnItbJM.A.o3.YNCSOB@chimera>
	 <alpine.DEB.2.00.1108142259120.4228@tiger>
	 <201108150736.FFC69227.MQSJVFHFFOOOtL@I-love.SAKURA.ne.jp>
	 <CAOJsxLH+qQxVwwx+2t-azc8fw+uz2+M9SCRzMUGdKKbUc1nC7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314003262.24275.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 08:46 +0300, Pekka Enberg wrote:
> On Mon, Aug 15, 2011 at 1:36 AM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > Pekka Enberg wrote:
> >> Tetsuio, did Peter's commit 30765b9 ("slab, lockdep: Annotate the locks
> >> before using them") and commit 83835b3 ("slab, lockdep: Annotate slab ->
> >> rcu -> debug_object -> slab") in Linus' git fix this for you?
> >
> > Yes. Applying these two commits fixes this problem.
> >
> > Thank you.
> 
> The commits weren't tagged for -stable, I'm afraid. Peter?

I must have forgotten people were actually triggering this on 3.0. Feel
free to tell gregkh to include those two patches in his next 3.0-stable
lineup.
