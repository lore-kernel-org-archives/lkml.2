Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0HCKG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:06:29 -0400
Received: from www.tglx.de ([62.245.132.106]:32939 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab0HCKG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:06:28 -0400
Date: Tue, 3 Aug 2010 12:06:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <teheo@suse.de>
cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
In-Reply-To: <4C572327.7040801@suse.de>
Message-ID: <alpine.LFD.2.00.1008031205040.3225@localhost.localdomain>
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de> <4C56E5C7.90206@suse.de>
 <alpine.LFD.2.00.1008022022560.27107@localhost.localdomain> <4C572327.7040801@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010, Tejun Heo wrote:
> > And it's even less of an issue as the main users of this misfeature
> > are laptops and desktop machines, where locality is not really that
> > important. If an enterprise admin decides to ignore the fact that the
> > hardware is flaky, then he does not care about the cache line bounces
> > either.
> 
> These problems do happen on intel chipset machines and is something
> which can be worked around with some effort.  Eh, let's talk on the
> other reply.

So you're saying that the ATA problem is restricted to Intel chipsets?
Do we know the root cause ?

Thanks,

	tglx
