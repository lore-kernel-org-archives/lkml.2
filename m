Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2EBKfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:35:01 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:49532 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2EBKfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:35:00 -0400
Date: Wed, 2 May 2012 16:04:53 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, pjt@google.com, suresh.b.siddha@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/5] sched, fair: Let minimally loaded cpu balance
 the group
Message-ID: <20120502103453.GB22740@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120501181430.007891123@chello.nl>
 <20120501182610.745844312@chello.nl>
 <20120502102541.GA22740@linux.vnet.ibm.com>
 <1335954690.13683.178.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1335954690.13683.178.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050210-3864-0000-0000-000002854B88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-05-02 12:31:30]:

> > IOW :
> > 
> > 		balance_load = 0 iff idle_cpu(i) ??
> 
> I think so, even for !0 load_idx, load will only reach zero when we're
> idle, just takes longer.

Right ...so should we force it to select a idle_cpu by having
balance_load = 0 for a idle cpu (ignoring what target_load(i, load_idx)
told us as its load?

- vatsa

