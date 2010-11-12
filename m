Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0KLKsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:48:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41200 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab0KLKsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:48:06 -0500
Date: Fri, 12 Nov 2010 11:48:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
Message-ID: <20101112104804.GB8020@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
 <4CDC2DDD.50508@linux.vnet.ibm.com>
 <4CDC3845.4030104@linux.intel.com>
 <4CDC4628.8020109@linux.vnet.ibm.com>
 <20101111194936.GJ18718@basil.fritz.box>
 <1289505587.2084.193.camel@laptop>
 <AANLkTin3khDj2FpJ-SY+xhLykiKer23uAjRdBM4m8gXD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin3khDj2FpJ-SY+xhLykiKer23uAjRdBM4m8gXD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think you need special syntax. You can simply come up with
> the 64-bit raw hex value. corey recently added a small utility to do
> this via libpfm4: perf stat -e `evt2raw unhalted_core_cycles:u` ....

I added a small patch to perf to read event mappings from a flat mapping file.

> > Also, I think we can use the same mechanism to program the
> > PEBS-load-latency MSR, right?
> >
> Yes, we could hardcode the latency the same way.

At least right now it would still need a constraint, because only
one counter can use it. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
