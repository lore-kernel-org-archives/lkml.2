Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0KLK17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:27:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41509 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab0KLK16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:27:58 -0500
Date: Fri, 12 Nov 2010 11:27:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, eranian@google.com
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
Message-ID: <20101112102748.GA8020@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
 <4CDC2DDD.50508@linux.vnet.ibm.com>
 <4CDC3845.4030104@linux.intel.com>
 <4CDC4628.8020109@linux.vnet.ibm.com>
 <20101111194936.GJ18718@basil.fritz.box>
 <1289505587.2084.193.camel@laptop>
 <20101111201259.GL18718@basil.fritz.box>
 <1289507858.2084.195.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289507858.2084.195.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 09:37:38PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-11 at 21:12 +0100, Andi Kleen wrote:
> > > Also, I think we can use the same mechanism to program the
> > > PEBS-load-latency MSR, right?
> > 
> > I haven't looked at that, but if it's a per core resource
> > the infrastructure can be reused at least. 
> 
> Can't remember if the load-latency msr is per-core, but its an extra reg
> that needs to be set.

Ok. I guess it shouldn't be too hard to add.

Load-latency is pretty useful too.

> 
> The nhm/wsm LBR config msr is per-core though, so that could use your
> infrastructure too.

Stephane mentioned that too. Not right now, but perhaps later I'll
look at using this.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
