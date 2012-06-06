Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab2FFOfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:35:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:31344 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab2FFOfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:35:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148897206"
Date: Wed, 6 Jun 2012 07:35:36 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
Message-ID: <20120606143536.GH28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
 <1338979188.2749.92.camel@twins>
 <20120606141247.GD28225@tassilo.jf.intel.com>
 <1338992061.2749.111.camel@twins>
 <20120606142323.GG28225@tassilo.jf.intel.com>
 <1338992910.2749.121.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338992910.2749.121.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:28:30PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 07:23 -0700, Andi Kleen wrote:
> > 
> > But it's very clear this cannot be done without a model check.
> > I don't understand how you can even argue against that. 
> 
> Who said I fixed it without a model check?

Do you mean the explicit PEBS disable?
That's only for one model, but it did not address the underlying
problem that Linux did non architecturally guaranteed things
just based on ArchPerfmon.

The PEBS disable still is needed even with my patch of course.

> 
> But simply disabling it for a model isn't how you do things. 

Do you want it enabled per model?  I can turn the flag around.
Anything else?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
