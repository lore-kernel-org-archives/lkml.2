Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1LER2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:28:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57514 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab1LER2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:28:14 -0500
X-Greylist: delayed 3244 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 12:28:14 EST
Date: Mon, 5 Dec 2011 18:26:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@redhat.com, jonas@southpole.se, lennox.wu@gmail.com,
        sfr@canb.auug.org.au
Subject: Re: [PATCHSET tip:x86/memblock] memblock: Kill early_node_map[],
 take 2
Message-ID: <20111205172618.GA23387@elte.hu>
References: <1322508685-32532-1-git-send-email-tj@kernel.org>
 <20111205163148.GA25909@elte.hu>
 <20111205171209.GA627@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205171209.GA627@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> (cc'ing Stephen, hi!)
> 
> On Mon, Dec 05, 2011 at 05:31:48PM +0100, Ingo Molnar wrote:
> > * Tejun Heo <tj@kernel.org> wrote:
> > 
> > > Hello,
> > > 
> > > This patchset was posted quite a while ago but got lost during the
> > > korg disturbance and I forgot about it too.  Thankfully, benh pinged
> > > me about testing this patchset yesterday, so here's the refreshed
> > > version.
> > 
> > A bit scary - you should get it into linux-next i suspect - if 
> > that works out then we could then put it into tip:core/memblock 
> > if there are no objections from anyone.
> > 
> > It's not really an x86 tree and most of the changes are 
> > affecting non-x86 architectures, right?
> 
> Hmmm... this was part of the memblock updates going through
> x86/memblock and unless we're gonna setup a separate tree for memblock
> (I don't think that would be necessary at this point) I think it would
> be better to route this x86/memblock eventually.  That said, setting
> up temp linux-next branch for now sounds fine to me.  hpa, what do you
> think?

I'm fine with routing this through -tip - the branch can be 
tip:core/memblock as this is really not just an x86 series - but 
if you could pre-test all the arch impact in linux-next that 
would be great ...

Thanks,

	Ingo
