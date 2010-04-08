Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab0DHJtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:49:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:47727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105Ab0DHJtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:49:08 -0400
Date: Thu, 8 Apr 2010 11:49:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Message-ID: <20100408094905.GA3948@tiehlicka.suse.cz>
References: <20100401133923.GA4104@tiehlicka.suse.cz>
 <201004022131.47787.rjw@sisk.pl>
 <20100407073414.GA5174@tiehlicka.suse.cz>
 <201004072149.23791.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004072149.23791.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-04-10 21:49:23, Rafael J. Wysocki wrote:
> On Wednesday 07 April 2010, Michal Hocko wrote:
> > Sorry for late reply, but I was AFK during holiday.
> > 
> > On Fri 02-04-10 21:31:47, Rafael J. Wysocki wrote:
> > > On Thursday 01 April 2010, Michal Hocko wrote:
> > > > On Thu 01-04-10 14:45:35, Matthew Garrett wrote:
> > > > > On Thu, Apr 01, 2010 at 03:39:23PM +0200, Michal Hocko wrote:
> > > > > > Hi Rafael, Matthew,
> > > > > > my laptop changed behavior during poweroff recently (after upgrading
> > > > > > from .33 to .34-rc1). The system seems to be powered off (status display
> > > > > > is off) at first glance but when I close the lid then I can hear a noise
> > > > > > which sounds like HDD parking and when I open lid again it starts
> > > > > > booting without poweroff button (same like when I suspend to RAM).
> > > > > 
> > > > > Hm. At a guess, we're somehow managing to leave the lid GPE enabled at 
> > > > > poweroff. Can you send the output of the acpidump command?
> > > > 
> > > > Sure, see attached.
> > > 
> > > Thanks.
> > > 
> > > Please also send the contents of /proc/acpi/wakeup.
> > 
> > See attached. I have checked both kernels (with and without reverted
> > 9630bdd) and the output looks pretty much same. 2.6.34-rc3, however,
> > looks different a bit, so I am attaching it as well.
> 
> Well, I fail to see the possible failure scenario, so let's first try a blind
> shot.
> 
> Please check if this patch helps:
> https://patchwork.kernel.org/patch/86238/

No change, sorry. I have tried that on top of 0fdf867 which is not the
most recent one (does it make sense to retest on the most recent one
f5284e7?)

> 
> Rafael

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
