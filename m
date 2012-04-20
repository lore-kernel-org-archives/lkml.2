Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2DTOGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:06:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45076 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2DTOGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120420122120.097464672@linutronix.de>
References: <20120420122120.097464672@linutronix.de>
Date: Fri, 20 Apr 2012 16:06:04 +0200
Message-ID: <CAFLxGvzgRpJq_BRrfgGh-V-k9XQmSvSN6hmK+6jm86Vy7v3EVg@mail.gmail.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 3:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> This converts all architectures except m32r, mn10300, tile and UM to
> the new core facility. These architecture are calling fork_idle() in
> the very early boot code in smp_prepare_cpus() for unknown reasons.
> I haven't analyzed yet, whether this is on purpose or can be moved
> over to the generic facility. It'd be nice if the responsible maintainers
> could look into that as well.

SMP is marked as broken on UM, so I don't have any objections. :-)

-- 
Thanks,
//richard
