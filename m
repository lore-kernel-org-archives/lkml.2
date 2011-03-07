Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1CGNMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 08:12:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1CGNMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 08:12:50 -0500
Date: Mon, 7 Mar 2011 14:12:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>, Ingo Molnar <mingo@elte.hu>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Undefined TASK_INTERRUPTIBLE (Was: Re: [PATCH 1/3] iwlwifi: move
 rx handlers code to iwl-rx.c)
Message-ID: <20110307131217.GA9571@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
 <1299447258.5082.164.camel@wwguy-huron>
 <AANLkTimNjxguAFcRr-mJr-pPMkf6zTxzm4k7oV+6zngG@mail.gmail.com>
 <20110307081241.GA2216@redhat.com>
 <1299489602.2308.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299489602.2308.1.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 10:20:02AM +0100, Peter Zijlstra wrote:
> On Mon, 2011-03-07 at 09:12 +0100, Stanislaw Gruszka wrote:
> > 
> > But perhaps we need a more generic fix in wait.h for the future. Maybe
> > we should decouple definitions of TASK_INTERRUPTIBLE and friends from
> > sched.h into separate header and include that header in wait.h as
> > well?
> 
> No! That only makes the mess worse, the only sane option is to fix
> things so that wait.h can include sched.h and that is non-trivial.

I was not aware of recent discussion
http://marc.info/?t=129829886000004&r=1&w=2

