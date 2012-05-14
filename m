Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab2ENV2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:28:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab2ENV16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:27:58 -0400
Date: Mon, 14 May 2012 14:27:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
Message-ID: <20120514212753.GM2366@google.com>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
 <20120507175743.GC19417@google.com>
 <1336482202.16236.29.camel@twins>
 <20120508165819.GB10687@google.com>
 <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
 <1336516260.8226.61.camel@twins>
 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils>
 <20120509092536.GC8585@gmail.com>
 <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
 <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:52:46AM -0700, Hugh Dickins wrote:
> On Wed, 9 May 2012, Hugh Dickins wrote:
> > On Wed, 9 May 2012, Ingo Molnar wrote:
> > > * Hugh Dickins <hughd@google.com> wrote:
> > > 
> > > > I'll set it going when I get home later - thanks.
> > 
> > Going fine so far, but a more convincing final report tomorrow.
> 
> Yes, as expected, Peter's patch (+ ,) is good: that load ran four
> times longer than the longest it managed before without the patch.
> Just needs Peter's signoff, I think.

Peter, can I take your patch with Hugh's description w/ your SOB?

Thanks.

-- 
tejun
