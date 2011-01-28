Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1A1Un0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:43:26 -0500
Received: from www.tglx.de ([62.245.132.106]:38693 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1A1UnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:43:25 -0500
Date: Fri, 28 Jan 2011 21:41:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vamos@i4.informatik.uni-erlangen.de, Julia Lawall <julia@diku.dk>
Subject: Re: [ANNOUNCE] undertaker 1.0
In-Reply-To: <87y666tvag.fsf@faui44a.informatik.uni-erlangen.de>
Message-ID: <alpine.LFD.2.00.1101282126210.31804@localhost6.localdomain6>
References: <87y666tvag.fsf@faui44a.informatik.uni-erlangen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Reinhard Tartler wrote:
> [2] http://www4.informatik.uni-erlangen.de/Research/VAMOS/linux-trees/

Nice effort.

I had a quick look into kernel/irq/

The red section in irqdesc.c

280 #if defined(CONFIG_KSTAT_IRQS_ONDEMAND)

is indeed dead code.

The one in manage.c is not:

 921 #ifdef CONFIG_IRQ_RELEASE_METHOD

CONFIG_IRQ_RELEASE_METHOD is set by arch/um. Ditto for include/linux/irq.h

It'd be nice if the web interface would have a knob to jump to the
next red section. Scrolling through is annoying.

Thanks,

	tglx


