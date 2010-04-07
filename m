Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0DGTq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 15:46:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab0DGTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 15:46:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Date: Wed, 7 Apr 2010 21:49:23 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <20100401133923.GA4104@tiehlicka.suse.cz> <201004022131.47787.rjw@sisk.pl> <20100407073414.GA5174@tiehlicka.suse.cz>
In-Reply-To: <20100407073414.GA5174@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201004072149.23791.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 April 2010, Michal Hocko wrote:
> Sorry for late reply, but I was AFK during holiday.
> 
> On Fri 02-04-10 21:31:47, Rafael J. Wysocki wrote:
> > On Thursday 01 April 2010, Michal Hocko wrote:
> > > On Thu 01-04-10 14:45:35, Matthew Garrett wrote:
> > > > On Thu, Apr 01, 2010 at 03:39:23PM +0200, Michal Hocko wrote:
> > > > > Hi Rafael, Matthew,
> > > > > my laptop changed behavior during poweroff recently (after upgrading
> > > > > from .33 to .34-rc1). The system seems to be powered off (status display
> > > > > is off) at first glance but when I close the lid then I can hear a noise
> > > > > which sounds like HDD parking and when I open lid again it starts
> > > > > booting without poweroff button (same like when I suspend to RAM).
> > > > 
> > > > Hm. At a guess, we're somehow managing to leave the lid GPE enabled at 
> > > > poweroff. Can you send the output of the acpidump command?
> > > 
> > > Sure, see attached.
> > 
> > Thanks.
> > 
> > Please also send the contents of /proc/acpi/wakeup.
> 
> See attached. I have checked both kernels (with and without reverted
> 9630bdd) and the output looks pretty much same. 2.6.34-rc3, however,
> looks different a bit, so I am attaching it as well.

Well, I fail to see the possible failure scenario, so let's first try a blind
shot.

Please check if this patch helps:
https://patchwork.kernel.org/patch/86238/

Rafael
