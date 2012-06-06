Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2FFOhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:37:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:11641 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab2FFOho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108542074"
Date: Wed, 6 Jun 2012 07:37:43 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 3/5] perf, x86: Check LBR format capability
Message-ID: <20120606143743.GI28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
 <1338944211-28275-3-git-send-email-andi@firstfloor.org>
 <1338979224.2749.93.camel@twins>
 <20120606141419.GE28225@tassilo.jf.intel.com>
 <1338992556.2749.118.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338992556.2749.118.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:22:36PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 07:14 -0700, Andi Kleen wrote:
> > On Wed, Jun 06, 2012 at 12:40:24PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > Double check the CPU has a LBR format we support before using it.
> > > > 
> > > > Also I made the init functions __init while I was on it. 
> > > 
> > > Why? Its all after a model test anyway.
> > 
> > Because the spec says we should check it.
> 
> The spec says lots of things.. but being that LBR is very much model
> specific I really can't be bothered.

Well you don't need to be, I did it already :-)

> 
> > It could catch bad VMs and other inconsistencies and it's the right thing
> > to do.
> 
> That might be a reason, but does it?, and why wasn't that in the
> changelog?

No it will not catch KVM because zero is a valid version :-/
That would still need the MISC_ENABLE re-read I think.

Still it's the right thing to do I believe.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only
