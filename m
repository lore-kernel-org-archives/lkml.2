Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1CGJUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 04:20:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:54317 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1CGJUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 04:20:13 -0500
Subject: Re: Undefined TASK_INTERRUPTIBLE (Was: Re: [PATCH 1/3] iwlwifi:
 move rx handlers code to iwl-rx.c)
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>, Ingo Molnar <mingo@elte.hu>,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110307081241.GA2216@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
	 <1299447258.5082.164.camel@wwguy-huron>
	 <AANLkTimNjxguAFcRr-mJr-pPMkf6zTxzm4k7oV+6zngG@mail.gmail.com>
	 <20110307081241.GA2216@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 07 Mar 2011 10:20:02 +0100
Message-ID: <1299489602.2308.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 09:12 +0100, Stanislaw Gruszka wrote:
> 
> But perhaps we need a more generic fix in wait.h for the future. Maybe
> we should decouple definitions of TASK_INTERRUPTIBLE and friends from
> sched.h into separate header and include that header in wait.h as
> well?

No! That only makes the mess worse, the only sane option is to fix
things so that wait.h can include sched.h and that is non-trivial.
