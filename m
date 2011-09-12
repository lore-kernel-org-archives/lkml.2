Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1ILInv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 04:43:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54509 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753447Ab1ILInt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:43:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/xMoIfPonxBrJobm6HG0E/VI7y7Tc8VsKWtK4wqj
	8UsDYb7VvqXrGh
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1315814733.21927.16.camel@marge.simson.net>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
	 <1315764876.6352.61.camel@marge.simson.net>
	 <alpine.LFD.2.02.1109120924540.2723@ionos>
	 <1315814733.21927.16.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 10:43:46 +0200
Message-ID: <1315817026.21927.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Splitting ksoftirqd was somewhat useful.  Seems somebody is firing off
tasklets heftily, at least that's always current when the throttle kicks
in and saves the day.

(tip-rt13 UV100 box)

[   40.701221] ioatdma 0000:00:16.7: enabling device (0000 -> 0002)
[   40.701239] ioatdma 0000:00:16.7: PCI INT D -> GSI 46 (level, low) -> IRQ 46
[   40.701281] ioatdma 0000:00:16.7: setting latency timer to 64
[   40.701696] ioatdma 0000:00:16.7: irq 128 for MSI/MSI-X
[   40.951009] RT: throttling CPU25
[   40.951013] RT: Danger!  (sirq-tasklet/25) is potential runaway.
[   40.951016] sched: RT throttling activated
[   40.951019] RT: throttling CPU26
[   40.951026] RT: Danger!  (sirq-tasklet/26) is potential runaway.
[   40.960010] RT: throttling CPU13
[   40.960013] RT: Danger!  (sirq-tasklet/13) is potential runaway.
[   41.000014] RT: throttling CPU13
[   41.000014] RT: throttling CPU25
[   41.000014] RT: throttling CPU26
[   41.656925] Adding 1959924k swap on /dev/sda2.  Priority:-1 extents:1 across:1959924k 
[   41.950011] RT: throttling CPU25
[   41.950013] RT: Danger!  (sirq-tasklet/25) is potential runaway.
[   41.950024] RT: throttling CPU30
[   41.950031] RT: Danger!  (sirq-tasklet/30) is potential runaway.
[   41.951010] RT: throttling CPU21
[   41.951014] RT: Danger!  (sirq-tasklet/21) is potential runaway.
[   42.000014] RT: throttling CPU13


