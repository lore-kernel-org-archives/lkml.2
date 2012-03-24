Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2CYAau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:30:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2CYAas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:30:48 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
To: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>
In-Reply-To: <20120323094139.GA7231@sortiz-mobl>
References: <20120323143237.9b5917955cb42951f0368ec4@canb.auug.org.au> <20120323094139.GA7231@sortiz-mobl>
Date: Sat, 24 Mar 2012 17:31:52 +0000
Message-Id: <20120324173152.494DA3E0A26@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2012 10:41:39 +0100, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Stephen,
> 
> On Fri, Mar 23, 2012 at 02:32:37PM +1100, Stephen Rothwell wrote:
> > Hi Samuel,
> > 
> > Today's linux-next merge of the mfd tree got a conflict in
> > drivers/mfd/twl-core.c between commits 5769089ac725 ("mfd: twl-core.c:
> > Fix the number of interrupts managed by twl4030"), 75294957be1d
> > ("irq_domain: Remove 'new' irq_domain in favour of the ppc one") and
> > 964dba283439 ("devicetree: Add empty of_platform_populate() for !
> > CONFIG_OF_ADDRESS (sparc)") from Linus' tree and commits 9e1786202704
> > ("mfd: Make twl-core not depend on pdata->irq_base/end") and 78518ffa08fc
> > ("mfd: Move twl-core IRQ allocation into twl[4030|6030]-irq files") from
> > the mfd tree.
> > 
> > I *think* that the right thing to do is to use the version from the mfd
> > tree ...
> That's correct.
> I have a for-next-merge branch where I usually have the merge conflicts with
> Linus tree fixed, in case you're interested.
> 
> 
> > I do wonder why I only got this now (in the merge window) ...
> I got a pull request from Benoit a couple days before the merge window opened.
> Then I realized part of the pull request contained a merge of one of Grant's
> branch. So I wanted to wait for Grant's code to get in before picking the mfd
> work on top of it. I didn't want to send a pull request to Linus with a merge
> point for something that would have been already merged. Maybe I was wrong,
> you tell me.

It should have gone into linux-next before then.  Waiting for my tree
to hit linus' tree defeats the purpose of linux-next.  Now you're
branch hasn't had any testing and therefore is a risky merge.

If you've got a branch you intend to send to Linus, then it really
needs to be in linux-next.  If that branch depends on another branch,
that's fine; you can still hold off actually sending the pull req to
Linus until the dependency makes it in.  Better yet, *ask*.

g.

