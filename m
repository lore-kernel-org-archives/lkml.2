Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0FRNXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:23:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42014 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab0FRNXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:23:34 -0400
Date: Fri, 18 Jun 2010 15:23:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100618132326.GD9045@basil.fritz.box>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com> <1276862130.1875.7.camel@laptop> <20100618122532.GB9045@basil.fritz.box> <1276865304.1875.12.camel@laptop> <20100618130921.GC9045@basil.fritz.box> <1276866769.1875.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276866769.1875.14.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 03:12:49PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-06-18 at 15:09 +0200, Andi Kleen wrote:
> > > You generally want to pass more information along anyway, now your
> > > callback function needs to go look for it. Much better to pass a
> > > work_struct like thing around that is contained in the state it needs.
> > 
> > But how would you allocate the work queue in an NMI?
> > 
> > If it's only a single instance (like this bit) it can be always put
> > into a per cpu variable.
> 
> Pre-allocate. For the perf-event stuff we use the perf_event allocated
> at creation time. But yeah, per-cpu storage also works.

So you could just preallocate the bits instead ?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
