Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1INPju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:39:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:54685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1INPjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:39:49 -0400
Subject: Re: [RFC][PATCH 1/3] sched: Provide delayed wakeup list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Michel Lespinasse <walken@google.com>
Date: Wed, 14 Sep 2011 17:39:34 +0200
In-Reply-To: <4E70C9B3.5080503@linux.intel.com>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.739484417@chello.nl> <4E70C9B3.5080503@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316014774.5040.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 08:35 -0700, Darren Hart wrote:
> Missing here is what the value of state should be when
> calling wake_up_list. 

Depends on what all you want to wake up :-) Would a reference to the
comment of try_to_wake_up() be good enough?
