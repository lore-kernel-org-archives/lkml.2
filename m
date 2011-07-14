Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1GNQhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:37:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:58505 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1GNQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:37:23 -0400
Subject: Re: INFO: possible circular locking dependency detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110714144946.GA3354@swordfish.minsk.epam.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 18:41:39 +0200
Message-ID: <1310661699.2309.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 17:49 +0300, Sergey Senozhatsky wrote:
> Hello,
> 
> [ 4172.371094] =======================================================
> [ 4172.371097] [ INFO: possible circular locking dependency detected ]
> [ 4172.371103] 3.0.0-rc7-dbg-00565-g6b31efc #644
> [ 4172.371105] -------------------------------------------------------
> [ 4172.371108] make/11702 is trying to acquire lock:
> [ 4172.371111]  (rcu_node_level_0){..-...}, at: [<ffffffff810a55e2>] __rcu_read_unlock+0xb9/0x217
> [ 4172.371123] 
> [ 4172.371123] but task is already holding lock:
> [ 4172.371125]  (&p->pi_lock){-.-.-.}, at: [<ffffffff8103775e>] try_to_wake_up+0x29/0x28b
> [ 4172.371135] 
> [ 4172.371135] which lock already depends on the new lock.

Happen to have a .config and means of reproduction? We're a little
stumped at trying to explain how this can actually happen.



