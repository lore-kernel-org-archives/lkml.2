Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2LLC7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:59:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab2LLC7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:59:48 -0500
Message-ID: <1355281172.3224.188.camel@bling.home>
Subject: Re: [GIT PULL] VFIO updates for v3.8
From: Alex Williamson <alex.williamson@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        fengguang.wu@intel.com, julia.lawall@lip6.fr, jiang.liu@huawei.com
Date: Tue, 11 Dec 2012 19:59:32 -0700
In-Reply-To: <20121212114430.cceef241f595a95e16c48874@canb.auug.org.au>
References: <1355252887.3224.176.camel@bling.home>
	 <20121212104632.b01520d6015486dd3ae507ef@canb.auug.org.au>
	 <1355270816.3224.179.camel@bling.home>
	 <20121212114430.cceef241f595a95e16c48874@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 2012-12-12 at 11:44 +1100, Stephen Rothwell wrote:
> Hi Alex,
> 
> On Tue, 11 Dec 2012 17:06:56 -0700 Alex Williamson <alex.williamson@redhat.com> wrote:
> >
> > Is that a bad thing?  I can start tagging from my next branch if that's
> > preferred.  Thanks,
> 
> Linus has said many times to not rebase before sending a pull request.
> When you rebase your tree you effectively throw away your testing (since
> the thing you rebased on top of may have introduced semantic conflicts
> with the work in your tree).  If you don't rebase your tested tree, any
> conflicts are then restricted to the actual merge and can be fixed there
> (or at least the diagnosis will lead there).
> 
> So, if I was a maintiner, at the start of the merge window (or just
> before) I would create a test branch that contained my work plus a
> *merge* with Linus' tree and do some testing on that and then ask Linus
> to pull my tree (not the merged version).  It may prove that the test
> merge with Linus' tree produces an "interesting" syntactic conflict - in
> this case I would mention that to Linus and put the merged tree somewhere
> public for him to use as a guide.  (Mind you, this conflict would already
> have most likely been noted by the linux-next maintainer.)
> 
> Also, your testing may have brought to light a semantic conflict, in
> which case the fix could be supplied to Linus with the pull request, or a
> well changed logged back merge of Linus' tree containing the fix could be
> done and Linus asked to pull the result.

Thanks for the tip.  I certainly retested after doing the rebase to
v3.7, but I can see the point.  I'll do as you suggest, a merge on a
separate branch for testing only and tag what I currently have in my
next branch.  v2 forthcoming.  Thanks,

Alex

