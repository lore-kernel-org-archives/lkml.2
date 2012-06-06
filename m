Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2FFOMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:12:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:12833 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab2FFOMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148888187"
Date: Wed, 6 Jun 2012 07:12:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
Message-ID: <20120606141247.GD28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
 <1338979188.2749.92.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338979188.2749.92.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:39:48PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > cycles:p uses an special cycles encoding by default. However that is not
> > architectural, so it can only be used when the CPU is known
> > (it already caused problems on Sandy Bridge). It may or may not work
> > on future CPUs.
> > 
> > So make it opt-in only. Right now I enabled it on Core2, Nehalem, Westmere
> > and not on Sandy-Bridge or Atom.
> 
> No. 

What do you mean? Are you claiming it's architectural?

> Also, c0 is a PEBS capable event on Atom just fine.

Ok can enable it there.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
