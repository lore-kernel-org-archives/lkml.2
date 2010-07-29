Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0G2Iod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:44:33 -0400
Received: from www.tglx.de ([62.245.132.106]:59829 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab0G2Io3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:44:29 -0400
Date: Thu, 29 Jul 2010 10:44:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <teheo@suse.de>
cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
In-Reply-To: <4C50349F.7020002@suse.de>
Message-ID: <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain>
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010, Tejun Heo wrote:

> On 07/28/2010 03:42 PM, Tejun Heo wrote:
> > Hello, Thomas.
> > 
> > With Jeff's acks added, patches to make libata use irq-expect are
> > commited.  Please pull from the following branch to receive patches[1]
> > to improve lost/spurious irq handling.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git lost-spurious-irq
> 
> I'll ask Stephen to pull the above branch into linux-next until it
> shows up via tip so that we don't lose any more linux-next testing
> time.

I'm working on it already and I'm currently twisting my brain around
the problem this patches will impose to the RT stuff, where we cannot
access timer_list timers from atomic regions :(

Thanks,

	tglx
