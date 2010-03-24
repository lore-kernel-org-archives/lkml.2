Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab0CXQNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:13:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:17112 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0CXQNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:13:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,301,1267430400"; 
   d="scan'208";a="258216815"
Subject: Re: [patch 2/2] x86,pat Convert memtype_lock into an rw_lock.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "holt@sgi.com" <holt@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <1269430347.5109.164.camel@twins>
References: <ff8c11be-b22d-4849-9b19-d9107c4fea47@email.android.com>
	 <1268871558.2696.60.camel@sbs-t61.fm.intel.com>
	 <1269430347.5109.164.camel@twins>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 24 Mar 2010 09:12:26 -0700
Message-Id: <1269447146.2881.0.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 04:32 -0700, Peter Zijlstra wrote:
> On Wed, 2010-03-17 at 16:19 -0800, Suresh Siddha wrote:
> > On Wed, 2010-03-17 at 12:51 -0700, H. Peter Anvin wrote:
> > > Well, as you know :) tglx and I are on the road ... I'll try to get to it on Friday before I take off again.
> > 
> > Also I talked to Thomas about this rwlock conversion and he referred to
> > RT issues with rwlock. And the best is to avoid this using RCU.
> 
> Its not just RT, even for mainline rwlock_t is a massive pain and often
> is no better (actually worse) than a spinlock due to the massive
> cacheline bouncing it introduces.

Don't we have the same cacheline bouncing issues with the ticket
spinlocks?

thanks,
suresh

