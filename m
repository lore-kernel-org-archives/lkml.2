Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab2CWJdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:33:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:13099 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab2CWJda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="132343221"
Date: Fri, 23 Mar 2012 10:41:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the mfd tree with Linus' tree
Message-ID: <20120323094139.GA7231@sortiz-mobl>
References: <20120323143237.9b5917955cb42951f0368ec4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323143237.9b5917955cb42951f0368ec4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Mar 23, 2012 at 02:32:37PM +1100, Stephen Rothwell wrote:
> Hi Samuel,
> 
> Today's linux-next merge of the mfd tree got a conflict in
> drivers/mfd/twl-core.c between commits 5769089ac725 ("mfd: twl-core.c:
> Fix the number of interrupts managed by twl4030"), 75294957be1d
> ("irq_domain: Remove 'new' irq_domain in favour of the ppc one") and
> 964dba283439 ("devicetree: Add empty of_platform_populate() for !
> CONFIG_OF_ADDRESS (sparc)") from Linus' tree and commits 9e1786202704
> ("mfd: Make twl-core not depend on pdata->irq_base/end") and 78518ffa08fc
> ("mfd: Move twl-core IRQ allocation into twl[4030|6030]-irq files") from
> the mfd tree.
> 
> I *think* that the right thing to do is to use the version from the mfd
> tree ...
That's correct.
I have a for-next-merge branch where I usually have the merge conflicts with
Linus tree fixed, in case you're interested.


> I do wonder why I only got this now (in the merge window) ...
I got a pull request from Benoit a couple days before the merge window opened.
Then I realized part of the pull request contained a merge of one of Grant's
branch. So I wanted to wait for Grant's code to get in before picking the mfd
work on top of it. I didn't want to send a pull request to Linus with a merge
point for something that would have been already merged. Maybe I was wrong,
you tell me.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
