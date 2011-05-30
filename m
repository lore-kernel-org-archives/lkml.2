Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1E3RQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:16:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:60346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1E3RQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:16:21 -0400
Subject: Re: Very high CPU load when idle with 3.0-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110530162354.GQ2668@linux.vnet.ibm.com>
References: <20110530055924.GA9169@brouette>
	 <1306755291.1200.2872.camel@twins>
	 <20110530162354.GQ2668@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 19:19:49 +0200
Message-ID: <1306775989.2497.527.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 09:23 -0700, Paul E. McKenney wrote:
>         sp.sched_priority = RCU_KTHREAD_PRIO;
>         sched_setscheduler_nocheck(t, SCHED_FIFO, &sp); 

Why are those things RT tasks anyway? The old ksoftirq runs as a regular
task. And once you start boosting things you can boost this into FIFO as
well...

just wondering..

