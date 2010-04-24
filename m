Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab0DXFma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 01:42:30 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57719 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750729Ab0DXFm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 01:42:28 -0400
Date: Sat, 24 Apr 2010 07:42:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Leisner, Martin" <Martin.Leisner@xerox.com>,
       linux-pm@lists.linux-foundation.org, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: document open(/dev/snapshot) sideeffects -- was Re: [linux-pm]
 syncing the disks when entering sleep
Message-ID: <20100424054224.GB2290@elf.ucw.cz>
References: <76FA3B279DD9DA48896E2B404944957204E0B241@USA7061MS02.na.xerox.net>
 <201001281143.08993.rjw@sisk.pl>
 <20100405063852.GA1924@elf.ucw.cz>
 <201004232028.56005.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004232028.56005.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-04-23 20:28:55, Rafael J. Wysocki wrote:
> On Monday 05 April 2010, Pavel Machek wrote:
> > Hi!
> > 
> > > > > Please note that merely _opening_ /dev/snapshot has side effects, so that's
> > > > > not just "three ioctls".
> > > > 
> > > > I search Doc*/power/userland-swsusp.txt, and could not find mentions
> > > > of sideeffects. Perhaps that should be fixed?
> > > 
> > > Please feel free to make the docs more complete, then.
> > 
> > Yes, something like this?
> 
> Yes, looks reasonable.
> 
> I've applied it to suspend-2.6/linux-next (added a changelog).

Thanks!
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
