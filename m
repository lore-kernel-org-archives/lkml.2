Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753Ab0E0SPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:15:43 -0400
Received: from www.tglx.de ([62.245.132.106]:60311 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0E0SPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:15:42 -0400
Date: Thu, 27 May 2010 20:14:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527174019.GA3187@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005272012350.3032@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005271915540.3032@localhost.localdomain> <20100527173118.GE2468@srcf.ucam.org> <1274981680.27810.5636.camel@twins> <20100527174019.GA3187@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> On Thu, May 27, 2010 at 07:34:40PM +0200, Peter Zijlstra wrote:
> > > we still need to be able to enter suspend while the system isn't idle.
> > 
> > _WHY_!?
> 
> Because if I'm running a kernel build in a tmpfs and I hit the sleep 
> key, I need to go to sleep. Blocking processes on driver access isn't 
> sufficient.

That's the difference between opportunistic and enforced suspend. On
enforced suspend the QoS guarantee is forced to NONE for everything
and you go down no matter what. When you decide to push the wakeup
button the system restores.

Thanks,

	tglx
