Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2AQAA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:00:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab2AQAA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:00:56 -0500
Date: Mon, 16 Jan 2012 15:59:03 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/3] PM / Sleep: Introduce new phases of device
 suspend/resume
Message-ID: <20120116235903.GA6280@suse.de>
References: <201112230029.20174.rjw@sisk.pl>
 <201201162321.38279.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201162321.38279.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 11:21:37PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> On Friday, December 23, 2011, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On the request of some driver PM developers, that appears to have been quite
> > popular lately, this series of patches adds new system suspend/resume (and
> > hibernation/restore) callbacks to struct dev_pm_ops and makes the PM core
> > use them during system power transitions.
> > 
> > [1/2] - Introduce "late suspend" and "early resume" of devices.
> > [2/2] - Introduce generic callbacks for new device PM phases.
> > 
> > The series is on top of the linux-next branch of the linux-pm tree.
> > 
> > These patches have been tested on Toshiba Portege R500 with openSUSE 12.1
> > without crashing the box in the process, which looks promising.  Also,
> > they shouldn't actually have any impact on the existing setups other than
> > adding a very short delay to the system suspend/resume code paths.
> 
> The patches have received some more testing since the were first posted and
> I've added a PM domains patch on top of them:
> 
> [3/3] - Make generic PM domains use the new device suspend/resume phases.
> 
> The series applies on top of linux-pm/pm-for-linus (although it should
> apply on top of the current mainline too).
> 
> I'm considering these patches as v3.4 material, if there are no objections.

No objection from me.

greg k-h
