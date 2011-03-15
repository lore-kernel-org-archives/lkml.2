Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1COJOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:14:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:52538 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1COJOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:14:17 -0400
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
In-Reply-To: <sched-ipi-callback-comment-2@mdm.bga.com>
References: <20110302174120.313761743@chello.nl>
	 <sched-ipi-callback-comment@mdm.bga.com> <1299857247.2308.5990.camel@twins>
	 <sched-ipi-callback-comment-2@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Mar 2011 10:13:41 +0100
Message-ID: <1300180421.2203.57.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 21:59 -0600, Milton Miller wrote:
> 
> I went ahead and sent this when I saw the comments questioning the
> sparc 32 part of the patch and thought you might respin.  But if this is
> already committed then I will submit a followup patch for consideration
> after this is merged. 

No, its not yet committed, and I do indeed need to respin. If you want
that comment gone, consider it so :-)


