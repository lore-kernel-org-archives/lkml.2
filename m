Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0KKUNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:13:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39349 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0KKUNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:13:07 -0500
Date: Thu, 11 Nov 2010 21:12:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, eranian@google.com
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
Message-ID: <20101111201259.GL18718@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
 <4CDC2DDD.50508@linux.vnet.ibm.com>
 <4CDC3845.4030104@linux.intel.com>
 <4CDC4628.8020109@linux.vnet.ibm.com>
 <20101111194936.GJ18718@basil.fritz.box>
 <1289505587.2084.193.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289505587.2084.193.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 08:59:47PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-11 at 20:49 +0100, Andi Kleen wrote:
> > > I think it would have parsed OK, but it is a confusing syntax to
> > > look at.  I should point out that there are also the u,k,h modifiers
> > > which can be specified, even on raw events, so the full syntax looks
> > > something like:
> > > 
> > > -e rXXXX[+YYYY][:u|:k|:h]
> > 
> > Ok I can fix the help text for that.
> 
> If we're frobbing it in the existing config qword, do we still need
> special syntax?

No, it could be all merged then.

> 
> Also, I think we can use the same mechanism to program the
> PEBS-load-latency MSR, right?

I haven't looked at that, but if it's a per core resource
the infrastructure can be reused at least.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
