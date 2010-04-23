Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0DWS0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:26:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0DWS0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:26:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform_bus: Allow runtime PM by default
Date: Fri, 23 Apr 2010 20:26:37 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20100423162811.GA31231@rakim.wolfsonmicro.main> <201004231840.20041.rjw@sisk.pl>
In-Reply-To: <201004231840.20041.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004232026.37114.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 April 2010, Rafael J. Wysocki wrote:
> On Friday 23 April 2010, Mark Brown wrote:
> > On Fri, Apr 23, 2010 at 09:11:57AM -0700, Greg KH wrote:
> > > On Fri, Apr 23, 2010 at 04:57:21PM +0100, Mark Brown wrote:
> > 
> > > > Turns out it's commit ad53012 "i2c: Fix bus-level power management
> > > > callbacks" in the PM tree that it depends on.  Does it make sense to
> > > > merge this via there rather than via your tree?
> > 
> > > Why would an i2c specific patch be needed here?  Do you have a pointer
> > > to that patch?
> > 
> > Despite the patch title being I2C specific it actually includes exposing
> > some of the runtime PM implementation to external users - I2C being the
> > first user of the generic PM runtime callbacks that I'm trying to use in
> > the platform device implementation.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=ad530128cd302e5df930b6eb4d4c7e162c40fcb2;hp=b938b00444e900f1c86e754539e3d00f172c184e
> > http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=d690b2cd222afc75320b9b8e9da7df02e9e630ca
> > 
> > > And yes, if it depends on something else in the PM tree, feel free to
> > > send this patch also through it, I have no objection to that.  Rafael,
> > > care to pick it up?  Mark, you might have to resend it to him.
> > 
> > OK, Raphael please let me know if you need a resend.
> 
> No, thanks, I have your original post.

Now applied to suspend-2.6/linux-next .

Thanks,
Rafael
