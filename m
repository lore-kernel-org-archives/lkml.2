Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1HXUuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:50:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35639 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1HXUuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:50:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 2/2 v2] sh-sci / PM: Use power.irq_safe
Date: Wed, 24 Aug 2011 22:52:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-sh@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201108202131.19479.rjw@sisk.pl> <201108212111.45012.rjw@sisk.pl> <20110824053317.GC26391@linux-sh.org>
In-Reply-To: <20110824053317.GC26391@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108242252.25098.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 24, 2011, Paul Mundt wrote:
> On Sun, Aug 21, 2011 at 09:11:44PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Since sci_port_enable() and sci_port_disable() may be run with
> > interrupts off and they execute pm_runtime_get_sync() and
> > pm_runtime_put_sync(), respectively, the SCI device's
> > power.irq_safe flags has to be used to indicate that it is safe
> > to execute runtime PM callbacks for this device with interrupts off.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Not sure how you want this one handled. Did you simply want to roll this
> in with your other patch with my Acked-by, or should I be taking this
> through my tree already regardless of the 1/2 patch?

I'd prefer to push it through my tree, if you don't mind.  Magnus has
already acked it for me, hopefully that's OK?

Rafael
