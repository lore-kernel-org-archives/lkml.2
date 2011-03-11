Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1CKP22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:28:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:43851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab1CKP21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:28:27 -0500
Subject: Re: [01/22] sched: Provide scheduler_ipi() callback in response to
 smp_send_reschedule()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Milton Miller <miltonm@bga.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <sched-ipi-callback-comment@mdm.bga.com>
References: <20110302174120.313761743@chello.nl>
	 <sched-ipi-callback-comment@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 11 Mar 2011 16:27:27 +0100
Message-ID: <1299857247.2308.5990.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 09:07 -0600, Milton Miller wrote:
> >       case PPC_MSG_RESCHEDULE:
> >               /* we notice need_resched on exit */
> 
> This comment should also be removed, as it was documenting the empty
> action. 

But its still true, TIF_NEED_RESCHED isn't going away and we still
notice that on the interrupt return path.
