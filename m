Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208Ab1LPIqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:46:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760152Ab1LPIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:46:43 -0500
Date: Fri, 16 Dec 2011 09:44:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: fix select_idle_sibling() regression in selecting
 an idle SMT sibling
Message-ID: <20111216084448.GC4170@elte.hu>
References: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323978421.1984.244.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

I changed this to Signed-off-by as you are forwarding Peter's 
patch. (let me know if that is not fine by you)

Thanks,

	Ingo
