Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1BHTGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:06:15 -0500
Received: from www.tglx.de ([62.245.132.106]:44277 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1BHTGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:06:14 -0500
Date: Tue, 8 Feb 2011 20:05:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
In-Reply-To: <20110208183937.GD4606@dumpdata.com>
Message-ID: <alpine.LFD.2.00.1102082003560.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de> <4D50641B.2090006@goop.org> <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6> <4D506AE6.6080900@goop.org> <1297173811.9388.95.camel@zakaz.uk.xensource.com> <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
 <1297177506.9388.135.camel@zakaz.uk.xensource.com> <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6> <20110208162045.GB4606@dumpdata.com> <alpine.LFD.2.00.1102081829330.31804@localhost6.localdomain6> <20110208183937.GD4606@dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Konrad Rzeszutek Wilk wrote:
> Aaaaah. I somehow thought the problems were with code proposed for
> 2.6.39, but you are referring to: "xen: events: do not unmask event channels
> on resume" (6903591f314b8947d0e362bda7715e90eb9df75e) which was added way
> back in November (post 2.6.37 time-frame) - and is already in Linus tree.

Ah, right. I was looking at 2.6.37 plain + pending irq changes and next :)
 
> > That's going to be impossible anyway when I'm done with the
> > encapsulation.
> 
> Any thoughts on how to fix that code Xen code for that issue?

That's what the patch you pulled and Ian tested is about. It does the
unmask in the core code when that IRQF_FORCE_RESUME flag is set.

Thanks,

	tglx
