Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0HTNvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0HTNvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:51:41 -0400
Date: Fri, 20 Aug 2010 09:51:18 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100820135118.GI4879@redhat.com>
References: <20100809194829.GB26154@erda.amd.com>
 <20100817152225.GQ26154@erda.amd.com>
 <1282214753.1926.4669.camel@laptop>
 <20100819141240.GO4879@redhat.com>
 <1282228033.2605.204.camel@laptop>
 <20100820015017.GA4879@redhat.com>
 <20100820081605.GD17551@elte.hu>
 <1282298651.2605.769.camel@laptop>
 <20100820123901.GE4879@redhat.com>
 <20100820132737.GD3321@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820132737.GD3321@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 03:27:37PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Fri, Aug 20, 2010 at 12:04:11PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2010-08-20 at 10:16 +0200, Ingo Molnar wrote:
> > > > 
> > > > 
> > > > Please someone send the final version with a changelog, with all the acks and 
> > > > tested-by's added, so that i can send it Linuswards. 
> > > 
> > > I've got two patches queued, one from Robert (with a slight
> > > modification, which removes a goto) and one from myself converting the
> > > intel and p4 irq handler.
> > > 
> > > They're available at:
> > > 
> > >   programming.kicks-ass.net/sekrit/patches.tar.bz2
> > > 
> > > I did add Tested-by tags, although I suspect its not the exact same bits
> > > Don tested..
> > 
> > I can re-test those exact patches later today if needed.
> 
> Please pick up -tip in an hour or two and holler if something looks wrong.

Easy enough.

Cheers,
Don
