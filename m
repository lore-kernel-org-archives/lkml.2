Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0DSS5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:57:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:48044 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0DSS5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:57:00 -0400
Subject: Re: [REGRESSION 2.6.30][PATCH v3] sched: update load count only
 once per cpu in 10 tick update window
From: Peter Zijlstra <peterz@infradead.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <1271703130.1676.214.camel@laptop>
References: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
	 <1271703130.1676.214.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 20:56:52 +0200
Message-ID: <1271703412.1676.224.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 20:52 +0200, Peter Zijlstra wrote:
> 
> So the only early updates can come from
> pick_next_task_idle()->calc_load_account_active(), so why not specialize
> that callchain instead of the below? 

To clarify, when I wrote that your patch was still below.. ;-)

