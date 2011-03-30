Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab1C3VNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:13:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965321Ab1C3VKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH] PM / Hibernate: Introduce CONFIG_HIBERNATE_INTERFACE
Date: Wed, 30 Mar 2011 23:10:24 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201103261229.44770.rjw@sisk.pl> <1301414013.18413.29.camel@zakaz.uk.xensource.com> <201103292139.35645.rjw@sisk.pl>
In-Reply-To: <201103292139.35645.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103302310.24717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 29, 2011, Rafael J. Wysocki wrote:
> On Tuesday, March 29, 2011, Ian Campbell wrote:
> > Hi Rafael,
> > 
> > On Sat, 2011-03-26 at 11:29 +0000, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Xen save/restore is going to use hibernate device callbacks for
> > > quiescing devices and putting them back to normal operations and it
> > > would need to select CONFIG_HIBERNATION for this purpose.  However,
> > > that also would cause the hibernate interfaces for user space to be
> > > enabled, which might confuse user space, because the Xen kernels
> > > don't support hibernation.  Moreover, it would be wasteful, as it
> > > would make the Xen kernels include a substantial amount of code that
> > > they would never use.
> > > 
> > > To address this issue introduce new power management Kconfig option
> > > CONFIG_HIBERNATE_INTERFACE, such that the hibernate interfaces for
> > > user space and the image-handling code will depend on it and it will
> > > select CONFIG_HIBERNATION.  Then, Xen save/restore will be able to
> > > select CONFIG_HIBERNATION without dragging the entire hibernate code
> > > along with it.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Were you planning to put this forward for 2.6.39 or are you waiting for
> > 2.6.40?
> 
> I'm goint to push it for 2.6.39.  In fact, I'm going to send the pull request
> shortly.

Unfortunately Linus didn't like it, so I need to rework it to make him happy.

As a result the patch is not going to go into 2.6.39.

Thanks,
Rafael
