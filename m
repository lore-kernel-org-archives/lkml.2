Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2IMI0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:26:50 -0400
Received: from [205.233.59.134] ([205.233.59.134]:57337 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2IMI0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:26:48 -0400
Message-ID: <1347524725.15764.102.camel@twins>
Subject: Re: [PATCH 1/2] nohz: clean up select_nohz_load_balancer()
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Date: Thu, 13 Sep 2012 10:25:25 +0200
In-Reply-To: <1347388424.26695.133.camel@sbsiddha-desk.sc.intel.com>
References: <1347261059-24747-1-git-send-email-alex.shi@intel.com>
	 <1347290774.2124.16.camel@twins> <504E937C.4020903@intel.com>
	 <1347388424.26695.133.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 11:33 -0700, Suresh Siddha wrote:
> > nohz_balance_enter_idle is good a name too. but I name it as
> > set_nohz_tick_stopped, since there is a clear_nohz_tick_stopped(), that
> > just do the opposed action of this function. According to this, is it
> > better to another function to nohz_balance_leave_idle()?
> > Or keep their current name?
> > 
> 
> Yes that will be more appropriate name.

I've made it:

  nohz_balance_{enter,exit}_idle()

Most of the nohz stuff has the {enter,exit}.
