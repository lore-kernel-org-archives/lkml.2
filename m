Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2EOLLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:11:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:47740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab2EOLLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:11:35 -0400
Message-ID: <1337080288.27694.38.camel@twins>
Subject: Re: linux-next oops in __lock_acquire for process_one_work
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 13:11:28 +0200
In-Reply-To: <20120514212753.GM2366@google.com>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
	 <20120507175743.GC19417@google.com> <1336482202.16236.29.camel@twins>
	 <20120508165819.GB10687@google.com>
	 <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
	 <1336516260.8226.61.camel@twins>
	 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils>
	 <20120509092536.GC8585@gmail.com>
	 <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
	 <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
	 <20120514212753.GM2366@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 14:27 -0700, Tejun Heo wrote:
> On Thu, May 10, 2012 at 10:52:46AM -0700, Hugh Dickins wrote:
> > On Wed, 9 May 2012, Hugh Dickins wrote:
> > > On Wed, 9 May 2012, Ingo Molnar wrote:
> > > > * Hugh Dickins <hughd@google.com> wrote:
> > > > 
> > > > > I'll set it going when I get home later - thanks.
> > > 
> > > Going fine so far, but a more convincing final report tomorrow.
> > 
> > Yes, as expected, Peter's patch (+ ,) is good: that load ran four
> > times longer than the longest it managed before without the patch.
> > Just needs Peter's signoff, I think.
> 
> Peter, can I take your patch with Hugh's description w/ your SOB?

Yes, sorry, I meant to queue it up the lockdep tree but got distracted
by other stuff.

If you want it, feel tree to take it.
