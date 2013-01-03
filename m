Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3ACIm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 03:42:58 -0500
Received: from magic.merlins.org ([209.81.13.136]:59086 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3ACIm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 03:42:56 -0500
Date: Thu, 3 Jan 2013 00:42:53 -0800
From: Marc MERLIN <marc@merlins.org>
To: Romain Francoise <romain@orebokech.com>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fairly reproduceable crash in 3.7.1 Null pointer
 rb_erase+0xc4/0x292
Message-ID: <20130103084253.GG8631@merlins.org>
References: <20130102222757.GC8631@merlins.org>
 <87sj6izqnh.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj6izqnh.fsf@silenus.orebokech.com>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.6.6-amd64-preempt-20120903/Debian
 wheezy/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-No-Run: Yes
X-SA-Exim-Connect-IP: 82.235.219.215
X-SA-Exim-Mail-From: merlin@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 08:12:18AM +0100, Romain Francoise wrote:
> Marc MERLIN <marc@merlins.org> writes:
> 
> > I had pretty repeated crashes when plugging power back into my running
> > laptop, but the display just freezes and I can't get a dump.
> 
> > For the crash here, I did: suspend to RAM, plug power back in, wake up.
> > Laptop crashed about 3 seconds after wakeup.
> 
> Sounds like https://bugzilla.kernel.org/show_bug.cgi?id=51661 which is
> fixed by 3935e89505a1c3ab3f3b0c7ef0eae54124f48905 ("watchdog: Fix
> disable/enable regression"), expect that in 3.7.2...

That looks like a good match, thank you. 
Hopefully this quick thread will help google steer folks who do get a
crash to the right page and fix.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
