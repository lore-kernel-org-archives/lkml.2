Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1BHRiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:38:11 -0500
Received: from www.tglx.de ([62.245.132.106]:58085 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1BHRiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:38:09 -0500
Date: Tue, 8 Feb 2011 18:38:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
In-Reply-To: <20110208162442.GC4606@dumpdata.com>
Message-ID: <alpine.LFD.2.00.1102081836370.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de> <4D50641B.2090006@goop.org> <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6> <4D506AE6.6080900@goop.org> <1297173811.9388.95.camel@zakaz.uk.xensource.com> <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
 <1297177506.9388.135.camel@zakaz.uk.xensource.com> <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6> <20110208162442.GC4606@dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Konrad Rzeszutek Wilk wrote:

> > Core change is in 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/for-xen
> 
> I just noticed that the patch you put in there differs from the
> one you posted: "genirq: Add IRQF_FORCE_RESUME". You missed the
> changes in include/linux/interrupt.h for the IRQF_MODIFY_MASK.
> 
> Was that intentional?

Yes, because irq.h is missing the IRQ_... flag as well. It's only
settable via: IRQF_... which is a flag for request/setup_irq.

Thanks,

	tglx

 
