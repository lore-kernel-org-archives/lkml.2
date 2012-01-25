Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2AYWdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:33:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab2AYWdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:33:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 0/3] PM / Sleep: Introduce new phases of device suspend/resume
Date: Wed, 25 Jan 2012 23:36:35 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <201112230029.20174.rjw@sisk.pl> <201201162321.38279.rjw@sisk.pl> <8739b4h9o1.fsf@ti.com>
In-Reply-To: <8739b4h9o1.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201252336.36179.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 25, 2012, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Hi,
> >
> > On Friday, December 23, 2011, Rafael J. Wysocki wrote:
> >> Hi,
> >> 
> >> On the request of some driver PM developers, that appears to have been quite
> >> popular lately, this series of patches adds new system suspend/resume (and
> >> hibernation/restore) callbacks to struct dev_pm_ops and makes the PM core
> >> use them during system power transitions.
> >> 
> >> [1/2] - Introduce "late suspend" and "early resume" of devices.
> >> [2/2] - Introduce generic callbacks for new device PM phases.
> >> 
> >> The series is on top of the linux-next branch of the linux-pm tree.
> >> 
> >> These patches have been tested on Toshiba Portege R500 with openSUSE 12.1
> >> without crashing the box in the process, which looks promising.  Also,
> >> they shouldn't actually have any impact on the existing setups other than
> >> adding a very short delay to the system suspend/resume code paths.
> >
> > The patches have received some more testing since the were first posted and
> > I've added a PM domains patch on top of them:
> >
> > [3/3] - Make generic PM domains use the new device suspend/resume phases.
> >
> > The series applies on top of linux-pm/pm-for-linus (although it should
> > apply on top of the current mainline too).
> >
> > I'm considering these patches as v3.4 material, if there are no objections.
> 
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> 
> Thanks Rafael for working on this.
> 
> So far I've only reviewed it, but I plan to convert my PM domain noirq
> usage to this and give it some testing as well, hopefully this week.

Great, thanks!

Rafael
