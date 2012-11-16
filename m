Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2KPBdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:33:51 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48360 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2KPBdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:33:50 -0500
Date: Fri, 16 Nov 2012 02:34:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.7-rc3: mouses stopped working
Message-ID: <20121116013405.GA2002@elf.ucw.cz>
References: <20121115132849.GA4062@elf.ucw.cz>
 <alpine.LNX.2.00.1211151429240.15877@pobox.suse.cz>
 <20121115140736.GA2651@elf.ucw.cz>
 <alpine.LNX.2.00.1211151508350.15877@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1211151508350.15877@pobox.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2012-11-15 15:10:03, Jiri Kosina wrote:
> On Thu, 15 Nov 2012, Pavel Machek wrote:
> 
> > > > I'm using thinkpad x60 with external USB mouse. On first boot, both
> > > > mice stopped working after minute-or-so in X. Lets see if it breaks on
> > > > the next boot, too..
> > > > 
> > > > USB keyboard still works, and dmesg seems to contain repeated
> > > > detections of USB mouse. But unplugging USB mouse does not bring
> > > > internal trackpoint to work, so...
> > > > 
> > > > Any ideas?
> > > 
> > > Does the dmesg also contain information regarding disconnection of the 
> > > mouse before it stopped working?
> > 
> > See the other mail, /dev/input/mice is not working.
> > 
> > And yes, mouse seems to be detected multiple times; it may have
> > happened before, with /dev/input/mice I would not notice.
> > 
> > dmesg attached.
> 
> If you have mouse that is buggy and periodically 
> disconnecting/reconnecting itself, you need commit df0cfd6990347c, which 
> went into 3.7-rc5 (it's a regression fix from -rc1).

I have -rc5 now, and still no mice for me.

root@amd:/tmp# uname -a
Linux amd 3.7.0-rc5+ #236 SMP Thu Nov 15 20:07:26 CET 2012 i686 GNU/Linux
root@amd:/tmp# cat /dev/input/mice
cat: /dev/input/mice: No such device or address
root@amd:/tmp# ls -al /dev/input/mice
crw-rw---- 1 root root 13, 63 Apr 25  2010 /dev/input/mice
root@amd:/tmp# 

										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
