Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1HYBeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 21:34:13 -0400
Received: from linux-sh.org ([111.68.239.195]:44334 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab1HYBeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 21:34:12 -0400
Date: Thu, 25 Aug 2011 10:33:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-sh@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2 v2] sh-sci / PM: Use power.irq_safe
Message-ID: <20110825013346.GD26391@linux-sh.org>
References: <201108202131.19479.rjw@sisk.pl> <201108212111.45012.rjw@sisk.pl> <20110824053317.GC26391@linux-sh.org> <201108242252.25098.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108242252.25098.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 10:52:24PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, August 24, 2011, Paul Mundt wrote:
> > On Sun, Aug 21, 2011 at 09:11:44PM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Since sci_port_enable() and sci_port_disable() may be run with
> > > interrupts off and they execute pm_runtime_get_sync() and
> > > pm_runtime_put_sync(), respectively, the SCI device's
> > > power.irq_safe flags has to be used to indicate that it is safe
> > > to execute runtime PM callbacks for this device with interrupts off.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Not sure how you want this one handled. Did you simply want to roll this
> > in with your other patch with my Acked-by, or should I be taking this
> > through my tree already regardless of the 1/2 patch?
> 
> I'd prefer to push it through my tree, if you don't mind.  Magnus has
> already acked it for me, hopefully that's OK?
> 
Sure, sounds fine to me. I'll just ignore it then.
