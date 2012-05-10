Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab2EJRxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:53:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60409 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133Ab2EJRxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:53:06 -0400
Date: Thu, 10 May 2012 10:52:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
In-Reply-To: <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils> <20120507175743.GC19417@google.com> <1336482202.16236.29.camel@twins> <20120508165819.GB10687@google.com> <alpine.LSU.2.00.1205081106160.4071@eggly.anvils> <1336516260.8226.61.camel@twins>
 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils> <20120509092536.GC8585@gmail.com> <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Hugh Dickins wrote:
> On Wed, 9 May 2012, Ingo Molnar wrote:
> > * Hugh Dickins <hughd@google.com> wrote:
> > 
> > > I'll set it going when I get home later - thanks.
> 
> Going fine so far, but a more convincing final report tomorrow.

Yes, as expected, Peter's patch (+ ,) is good: that load ran four
times longer than the longest it managed before without the patch.
Just needs Peter's signoff, I think.

Hugh
