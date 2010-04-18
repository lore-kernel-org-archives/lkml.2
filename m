Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0DRTPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 15:15:25 -0400
Received: from www.tglx.de ([62.245.132.106]:56799 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0DRTPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 15:15:24 -0400
Date: Sun, 18 Apr 2010 21:14:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guillaume Knispel <gknispel@proformatique.com>
cc: linux-kernel@vger.kernel.org, Linuxppc-dev@lists.ozlabs.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Lars-Peter Clausen <lars@metafoo.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Buesch <mb@bu3sch.de>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Pending interrupts not always replayed
In-Reply-To: <20100418164614.771d4f01@xilun.lan.proformatique.com>
Message-ID: <alpine.LFD.2.00.1004182112280.2972@localhost.localdomain>
References: <20100418053439.4d2ffe11@xilun.lan.proformatique.com> <20100418164614.771d4f01@xilun.lan.proformatique.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Apr 2010, Guillaume Knispel wrote:
> Now everything seems to work fine: my device was not previously not
> interrupting anymore after typically 1 or 2 minutes (because the
> interrupt signal stays at level low until the device is served, so

So you are having a level interrupt device and the irq line is handled
by an edge type handler ? Why not configuring the irq line for level
and in the first place ?

Thanks,

	tglx
