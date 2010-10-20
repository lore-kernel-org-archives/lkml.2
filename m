Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0JTMSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:18:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36859 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0JTMSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:18:49 -0400
Date: Wed, 20 Oct 2010 14:18:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [PATCH 2/2]x86: spread tlb flush vector between nodes
Message-ID: <20101020121847.GE20124@basil.fritz.box>
References: <1287544023.4571.8.camel@sli10-conroe.sh.intel.com>
 <1287551797.2700.76.camel@edumazet-laptop>
 <20101020073155.GB20124@basil.fritz.box>
 <1287573652.3488.6.camel@twins>
 <20101020120619.GD20124@basil.fritz.box>
 <1287576512.3488.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287576512.3488.13.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:08:32PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-20 at 14:06 +0200, Andi Kleen wrote:
> > On Wed, Oct 20, 2010 at 01:20:52PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2010-10-20 at 09:31 +0200, Andi Kleen wrote:
> > > > Really a lot of the per CPU scaling we have today should be per core
> > > > or per node to avoid explosion. 
> > > 
> > > Shouldn't that be per-cache instead of per-core?
> > 
> > That's the same on modern x86:
> 
> Last time I checked there's more than 1 directory in arch/

Not sure what your point is? 

I believe non x86 server processors have similar cache
layouts as the one I described, occasionally with another
cache level, and should do well with a similar setup.

For non server it typically doesn't matter too much
because there are not enough cores.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
