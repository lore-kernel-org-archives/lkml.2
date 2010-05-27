Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab0E0V7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:59:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab0E0V7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:59:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Fri, 28 May 2010 00:01:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271334560.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005272006560.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005272006560.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280001.07364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Alan Stern wrote:
> 
> > On Thu, 27 May 2010, Thomas Gleixner wrote:
> > 
> > > Crap. Stop beating on those lost wakeup events. If we lose them then
> > > the drivers are broken and do not handle the switch over correctly. Or
> > > the suspend mechanism is broken as it does not evaluate the system
> > > state correctly. Blockers are just papering over that w/o tackling the
> > > real problem.
> > 
> > That's the point -- suspend does not evaluate the system state 
> > correctly because it doesn't have the necessary information.  Suspend 
> > blockers are a way of providing it that information.  They don't paper 
> > over the problem; they solve it.
> 
> Nonsense. The system state is well defined when a event is pending and
> we just have to say good bye to the idea that forced suspend is a good
> solution. It's not as it does not guarantee the event processing in
> badly written apps and it does move the power consumption to a later
> point in time for those apps which acquire/drop the blockers.

Well, now you have stated that Android actually doesn't work. :-)

Rafael
