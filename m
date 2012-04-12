Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2DLE3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:29:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:46667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab2DLE3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:29:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131454718"
Subject: Re: kernel panic on NHM EX machine
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alex Shi <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
        venki@google.com, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20120412024651.GA7250@localhost>
References: <4F7ED569.6080103@intel.com>
	 <20120409223100.GQ2430@linux.vnet.ibm.com> <4F838734.9090700@intel.com>
	 <20120410143551.GA2428@linux.vnet.ibm.com>
	 <20120412024651.GA7250@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Wed, 11 Apr 2012 21:29:45 -0700
Message-ID: <1334204985.2279.2.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 10:46 +0800, Fengguang Wu wrote:
> Hi all,
> 
> This commit makes a difference. Found by auto bisection and confirmed
> by reverting it on top of v3.4-rc2.  Attached is my kconfig.
> 
> commit 77b0d60c5adf39c74039e2142a1d3cd1e4d53799
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Fri Nov 4 17:18:21 2011 -0700
> 
>     clockevents: Leave the broadcast device in shutdown mode when not needed


Fengguang, There is a fix queued up on top of that patch.

https://lkml.org/lkml/2012/4/10/105

Does this change anything?

thanks,
suresh

