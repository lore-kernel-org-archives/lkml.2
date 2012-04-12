Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab2DLGZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:25:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:12279 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085Ab2DLGZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:25:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129954906"
Date: Thu, 12 Apr 2012 14:25:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        venki@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kernel panic on NHM EX machine
Message-ID: <20120412062526.GA11011@localhost>
References: <4F7ED569.6080103@intel.com>
 <20120409223100.GQ2430@linux.vnet.ibm.com>
 <4F838734.9090700@intel.com>
 <20120410143551.GA2428@linux.vnet.ibm.com>
 <20120412024651.GA7250@localhost>
 <1334204985.2279.2.camel@sbsiddha-mobl2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334204985.2279.2.camel@sbsiddha-mobl2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:29:45PM -0700, Suresh Siddha wrote:
> On Thu, 2012-04-12 at 10:46 +0800, Fengguang Wu wrote:
> > Hi all,
> > 
> > This commit makes a difference. Found by auto bisection and confirmed
> > by reverting it on top of v3.4-rc2.  Attached is my kconfig.
> > 
> > commit 77b0d60c5adf39c74039e2142a1d3cd1e4d53799
> > Author: Suresh Siddha <suresh.b.siddha@intel.com>
> > Date:   Fri Nov 4 17:18:21 2011 -0700
> > 
> >     clockevents: Leave the broadcast device in shutdown mode when not needed
> 
> 
> Fengguang, There is a fix queued up on top of that patch.
> 
> https://lkml.org/lkml/2012/4/10/105
> 
> Does this change anything?

Yeah it boots fine with the fix. Thank you!

Fengguang
