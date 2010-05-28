Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab0E1Px4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:53:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758892Ab0E1Pxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:53:55 -0400
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
From: Peter Zijlstra <peterz@infradead.org>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <20100528035147.GD11364@uudg.org>
References: <20100527180431.GP13035@uudg.org>
	 <20100527183319.GA22313@redhat.com>
	 <20100528090357.7DFB.A69D9226@jp.fujitsu.com>
	 <20100528035147.GD11364@uudg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 28 May 2010 17:53:27 +0200
Message-ID: <1275062007.27810.9749.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 00:51 -0300, Luis Claudio R. Goncalves wrote:
> +       param.sched_priority = MAX_RT_PRIO-1;
> +       sched_setscheduler_nocheck(p, SCHED_FIFO, &param);


Argh, so you got me confused as well.

the sched_param ones are userspace values, so you should be using 1.


