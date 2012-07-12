Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab2GLItX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:49:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:37598 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2GLItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:49:19 -0400
Date: Thu, 12 Jul 2012 10:49:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Subject: Re: [patch RT 0/7] Various fixes for the stable RT series - part I
In-Reply-To: <1342049492.14828.69.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1207121047310.32033@ionos>
References: <20120711214552.036760674@linutronix.de> <1342049492.14828.69.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Steven Rostedt wrote:

> On Wed, 2012-07-11 at 22:05 +0000, Thomas Gleixner wrote:
> > The following patch series is a collection of bug fixes, which should
> > go into the 3.x based stable RT trees.
> > 
> > I have them locally applied to my 3.5 devel queue, but I'm still
> > distracted by other events (leap seconds and the like) to get a 3.5
> > devel queue released.
> > 
> > Steven, please pick up the lot.
> > 
> > I have a part II series pending which is addressing the widely
> > observed CPU hotplug issue. I'm going to send that out soon, despite
> > the fact that I fundamentaly hate it. Though the hotplug rework which
> > I have in the queue has turned out to be more work than expected and
> > there is no real way to backport all of the necessary changes into any
> > of the existing 3.x based RT trees. So I bite the bullet and go with
> > the workarounds to get rid of the last obstacles in the 3.x based RT
> > series.
> 
> I'll pull these in and start running my tests. I noticed that some of
> them are Signed-off-by Carsten first. Did he author them? If so, I'll
> make it so his name gets the git author.
> 
> Same for Mike Galbraith on patch 6. Only patch 7 has a 'From:' tag.

Gah. Forgot to add the From lines. 1-4 are from Carsten, 5 is mine, 6
is Mike and 7 is Yong.

Thanks,

	tglx
