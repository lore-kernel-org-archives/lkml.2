Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0GIVo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:44:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34070 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0GIVoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:44:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Norbert Preining <preining@logic.at>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Date: Fri, 9 Jul 2010 23:42:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <20100709081239.4eb8fddd@virtuousgeek.org> <20100709160408.GU30043@gamma.logic.tuwien.ac.at>
In-Reply-To: <20100709160408.GU30043@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092342.18286.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010, Norbert Preining wrote:
> Hi Jesse,
> 
> (stripping some people from Cc, hopefully not too many)
> 
> On Fr, 09 Jul 2010, Jesse Barnes wrote:
> > > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16179
> > > > Subject         : 2.6.35-rc2 completely hosed on intel gfx?
> > > > Submitter       : Norbert Preining <preining@logic.at>
> > > > Date            : 2010-06-06 11:55 (33 days old)
> > > > Message-ID      : <20100606115534.GA9399@gamma.logic.tuwien.ac.at>
> > > > References      : http://marc.info/?l=linux-kernel&m=127582534931581&w=2  
> > > 
> > > Hmm. That one is the vt.c bug coupled with another problem, which in
> > > turn got opened as a separate bugzilla entry:
> > > 
> > >    http://bugzilla.kernel.org/show_bug.cgi?id=16252
> > > 
> > > which in turn then got closed. I dunno.
> > 
> > Yeah, this is weird.  Norbert, do you still see this?  Have you tried
> > to bisect it?
> 
> I wrote in my last comment of this bug that in *most* of the cases
> the 
> 	echo "mem" > /sys/power/state
> works perfectly, and I'm using it permanently now.
> 
> The problem seems to be in combination with some pm-utils scripts.
> I still haven't been able to pin-point the actual pm-utils script that
> causes the problem, since that is something not 100% reproducible.
> 
> Futhermore, *once* (only once!) the echo mem > method failed as written in
> the bug report with :
> [16273.....] PM: resume of devices complete after 2115.046 msecs
> [16273.....] Restarting tasks ... done
> [16273.....] video LNXVIDEO:00: Restoring backlight state
> hanging here, but only once, not any time again.
> 
> It is hard to say what the culprit is, some new pm-utils script maybe,
> since it happens even when I switch pm-utils to use the kernel method
> (echo mem) to suspend, and not uswsusp (s2ram prog).
> 
> I would suggest keeping that bug closed until I have found the pm-utils
> or a specific culprit, then I can reopen it or open a new bug.
> 
> (more disturbing are iwlagn bugs, they are a PITA without any progress)

OK, closing.

Thanks,
Rafael
