Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab2IERTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:19:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2IERT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:19:29 -0400
Message-ID: <1346865555.2600.38.camel@twins>
Subject: Re: lockdep WARNING for run_timer_softirq()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Sep 2012 19:19:15 +0200
In-Reply-To: <1346865298.27919.58.camel@gandalf.local.home>
References: <20120831072149.GA7821@localhost>
	 <1346845644.2461.27.camel@laptop>
	 <1346854836.27919.51.camel@gandalf.local.home>
	 <1346864947.2600.33.camel@twins>
	 <1346865298.27919.58.camel@gandalf.local.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 13:14 -0400, Steven Rostedt wrote:
> 
> This looks very familiar to Fengguang's previous bug report. I can't
> seem to find it on LKML.org. Probably because of the two attachments
> (dmesg and config) caused lkml to nuke it.
> 
> I'll forward it to you. 

Yuck that looks like fun too.. doesn't look like the if() thing though.
