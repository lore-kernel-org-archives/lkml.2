Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1HWIAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:00:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:54783 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab1HWIAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:00:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dheeraj Reddy <dheeraj.reddy@intel.com>
Subject: Re: [Bug #39342] [3.0.0-rc6-git7] possible recursive locking atcache_alloc_refill
Date: Tue, 23 Aug 2011 00:42:47 -0700
Organization: Intel Corp.
Message-ID: <87hb58inew.fsf@franklin.jf.intel.com>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.o3.YNCSOB@chimera>
	<alpine.DEB.2.00.1108142259120.4228@tiger>
	<201108150736.FFC69227.MQSJVFHFFOOOtL@I-love.SAKURA.ne.jp>
	<CAOJsxLH+qQxVwwx+2t-azc8fw+uz2+M9SCRzMUGdKKbUc1nC7A@mail.gmail.com>
	<1314003262.24275.2.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 134.134.139.76
X-Operating-System: x86_64-pc-linux-gnu
X-Attribution: DSR
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Cancel-Lock: sha1:GOiMubY3lWv5BETC5v1Fv8HO5tQ=
Cc: kernel-testers@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, 2011-08-15 at 08:46 +0300, Pekka Enberg wrote:
>> On Mon, Aug 15, 2011 at 1:36 AM, Tetsuo Handa
>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>> > Pekka Enberg wrote:
>> >> Tetsuio, did Peter's commit 30765b9 ("slab, lockdep: Annotate the locks
>> >> before using them") and commit 83835b3 ("slab, lockdep: Annotate slab ->
>> >> rcu -> debug_object -> slab") in Linus' git fix this for you?
>> >
>> > Yes. Applying these two commits fixes this problem.
>> >
>> > Thank you.
>> 
>> The commits weren't tagged for -stable, I'm afraid. Peter?
>
> I must have forgotten people were actually triggering this on 3.0. Feel
> free to tell gregkh to include those two patches in his next 3.0-stable
> lineup.

I have added some more info to the bug report. I can see a similar
lockdep issue in 3.1 rc3.

dheeraj
-- 

