Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1HOFqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:46:23 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56356 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1HOFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:46:19 -0400
MIME-Version: 1.0
In-Reply-To: <201108150736.FFC69227.MQSJVFHFFOOOtL@I-love.SAKURA.ne.jp>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.o3.YNCSOB@chimera>
	<alpine.DEB.2.00.1108142259120.4228@tiger>
	<201108150736.FFC69227.MQSJVFHFFOOOtL@I-love.SAKURA.ne.jp>
Date: Mon, 15 Aug 2011 08:46:19 +0300
X-Google-Sender-Auth: GXQUCQGnKr6FaN6VWs3hloPGVW0
Message-ID: <CAOJsxLH+qQxVwwx+2t-azc8fw+uz2+M9SCRzMUGdKKbUc1nC7A@mail.gmail.com>
Subject: Re: [Bug #39342] [3.0.0-rc6-git7] possible recursive locking atcache_alloc_refill
From: Pekka Enberg <penberg@kernel.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, florian@mickler.org, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 1:36 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Pekka Enberg wrote:
>> Tetsuio, did Peter's commit 30765b9 ("slab, lockdep: Annotate the locks
>> before using them") and commit 83835b3 ("slab, lockdep: Annotate slab ->
>> rcu -> debug_object -> slab") in Linus' git fix this for you?
>
> Yes. Applying these two commits fixes this problem.
>
> Thank you.

The commits weren't tagged for -stable, I'm afraid. Peter?
