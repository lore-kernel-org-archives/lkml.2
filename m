Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab2IKSet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:34:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:24949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab2IKSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:34:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,406,1344236400"; 
   d="scan'208";a="143898776"
Subject: Re: [PATCH 1/2] nohz: clean up select_nohz_load_balancer()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Date: Tue, 11 Sep 2012 11:33:44 -0700
In-Reply-To: <504E937C.4020903@intel.com>
References: <1347261059-24747-1-git-send-email-alex.shi@intel.com>
	 <1347290774.2124.16.camel@twins> <504E937C.4020903@intel.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347388424.26695.133.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 09:27 +0800, Alex Shi wrote:
> On 09/10/2012 11:26 PM, Peter Zijlstra wrote:
> 
> > On Mon, 2012-09-10 at 15:10 +0800, Alex Shi wrote:
> >> There is no load_balancer to be selected now. It just set state of
> >> nohz tick stopping.
> >>
> >> So rename the function, pass the 'cpu' from parameter and then
> >> remove the useless calling from tick_nohz_restart_sched_tick().
> > 
> > Please check who wrote the code you're patching and attempt to CC them
> > as well, in this case Venki and Suresh.
> 
> 
> Thanks! will care about this from now on.
> 
> > 
> > I think the patch is fine, although I think we could have picked a
> > better name, how about nohz_balance_enter_idle() ?
> 
> 
> nohz_balance_enter_idle is good a name too. but I name it as
> set_nohz_tick_stopped, since there is a clear_nohz_tick_stopped(), that
> just do the opposed action of this function. According to this, is it
> better to another function to nohz_balance_leave_idle()?
> Or keep their current name?
> 

Yes that will be more appropriate name.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

